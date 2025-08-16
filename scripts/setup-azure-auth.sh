#!/bin/bash

# Script to set up Azure Service Principal for Terraform GitHub Actions
# This script creates a service principal and provides the necessary credentials for GitHub secrets

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    print_error "Azure CLI is not installed. Please install it first:"
    echo "https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Check if user is logged in
if ! az account show &> /dev/null; then
    print_warning "You are not logged in to Azure CLI."
    print_status "Please log in..."
    az login
fi

# Get current subscription
SUBSCRIPTION_ID=$(az account show --query id --output tsv)
SUBSCRIPTION_NAME=$(az account show --query name --output tsv)

print_status "Current subscription: $SUBSCRIPTION_NAME ($SUBSCRIPTION_ID)"

# Prompt for confirmation
read -p "Do you want to create a service principal for this subscription? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Operation cancelled."
    exit 0
fi

# Set service principal name
SP_NAME="${1:-terraform-github-actions-$(date +%s)}"
print_status "Creating service principal: $SP_NAME"

# Create service principal
print_status "Creating service principal with Contributor role..."
SP_OUTPUT=$(az ad sp create-for-rbac \
    --name "$SP_NAME" \
    --role "Contributor" \
    --scopes "/subscriptions/$SUBSCRIPTION_ID" \
    --json-auth)

# Extract values
CLIENT_ID=$(echo $SP_OUTPUT | jq -r .clientId)
CLIENT_SECRET=$(echo $SP_OUTPUT | jq -r .clientSecret)
TENANT_ID=$(echo $SP_OUTPUT | jq -r .tenantId)

print_success "Service principal created successfully!"
echo ""

print_status "GitHub Secrets Configuration"
echo "========================================"
echo ""
echo "Add the following secrets to your GitHub repository:"
echo "Go to: Settings > Secrets and variables > Actions > New repository secret"
echo ""
echo "Secret Name: AZURE_CLIENT_ID"
echo "Secret Value: $CLIENT_ID"
echo ""
echo "Secret Name: AZURE_CLIENT_SECRET" 
echo "Secret Value: $CLIENT_SECRET"
echo ""
echo "Secret Name: AZURE_SUBSCRIPTION_ID"
echo "Secret Value: $SUBSCRIPTION_ID"
echo ""
echo "Secret Name: AZURE_TENANT_ID"
echo "Secret Value: $TENANT_ID"
echo ""

print_warning "Important: Save these values securely. The client secret cannot be retrieved again."
print_warning "Store these values in your GitHub repository secrets immediately."

# Optionally save to file
read -p "Do you want to save these values to a file (azure-secrets.txt)? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cat > azure-secrets.txt << EOF
# Azure Service Principal Credentials for GitHub Actions
# Add these as secrets in your GitHub repository

AZURE_CLIENT_ID=$CLIENT_ID
AZURE_CLIENT_SECRET=$CLIENT_SECRET
AZURE_SUBSCRIPTION_ID=$SUBSCRIPTION_ID
AZURE_TENANT_ID=$TENANT_ID

# Service Principal Details
SP_NAME=$SP_NAME
SUBSCRIPTION_NAME=$SUBSCRIPTION_NAME
CREATED_DATE=$(date)
EOF
    print_success "Secrets saved to azure-secrets.txt"
    print_warning "Remember to delete this file after adding secrets to GitHub!"
fi

print_success "Setup complete! You can now use GitHub Actions for Terraform deployments."
