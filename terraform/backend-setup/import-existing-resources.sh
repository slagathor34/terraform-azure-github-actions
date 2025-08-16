#!/bin/bash
# ============================================================================
# TERRAFORM BACKEND IMPORT SCRIPT
# ============================================================================
# This script helps import existing Azure resources into Terraform state
# to avoid conflicts when resources already exist.

set -e

echo "🔄 Terraform Backend Resource Import Script"
echo "============================================"

# Check if we're in the right directory
if [ ! -f "main.tf" ]; then
    echo "❌ Error: This script must be run from a Terraform configuration directory containing main.tf"
    exit 1
fi

# Get Azure subscription info
echo "📋 Getting Azure subscription information..."
SUBSCRIPTION_ID=$(az account show --query id --output tsv 2>/dev/null || echo "")

if [ -z "$SUBSCRIPTION_ID" ]; then
    echo "❌ Error: Not logged into Azure CLI. Please run 'az login' first."
    exit 1
fi

echo "✅ Using subscription: $SUBSCRIPTION_ID"

# Default values
RESOURCE_GROUP_NAME=${1:-"tfstate-rg"}
LOCATION=${2:-"East US"}

# Generate storage account name (same logic as in Terraform)
STORAGE_ACCOUNT_NAME="tfstate$(echo -n $SUBSCRIPTION_ID | sha256sum | cut -c1-16)"

echo ""
echo "🔍 Checking for existing resources..."
echo "Resource Group: $RESOURCE_GROUP_NAME"
echo "Storage Account: $STORAGE_ACCOUNT_NAME"
echo "Location: $LOCATION"

# Check if resources exist
RG_EXISTS=$(az group exists --name "$RESOURCE_GROUP_NAME")
STORAGE_EXISTS=""

if [ "$RG_EXISTS" = "true" ]; then
    echo "✅ Resource group '$RESOURCE_GROUP_NAME' exists"
    STORAGE_EXISTS=$(az storage account list --resource-group "$RESOURCE_GROUP_NAME" --query "[?name=='$STORAGE_ACCOUNT_NAME'].name | [0]" -o tsv 2>/dev/null || echo "")
    
    if [ -n "$STORAGE_EXISTS" ]; then
        echo "✅ Storage account '$STORAGE_ACCOUNT_NAME' exists"
    else
        echo "ℹ️  Storage account '$STORAGE_ACCOUNT_NAME' does not exist"
    fi
else
    echo "ℹ️  Resource group '$RESOURCE_GROUP_NAME' does not exist"
fi

echo ""
echo "🚀 Initializing Terraform..."
terraform init

echo ""
echo "📥 Importing existing resources..."

# Import resource group if it exists
if [ "$RG_EXISTS" = "true" ]; then
    echo "Importing resource group..."
    terraform import module.terraform_backend.azurerm_resource_group.tfstate "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP_NAME" || true
fi

# Import storage account if it exists
if [ -n "$STORAGE_EXISTS" ]; then
    echo "Importing storage account..."
    terraform import module.terraform_backend.azurerm_storage_account.tfstate "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.Storage/storageAccounts/$STORAGE_ACCOUNT_NAME" || true
fi

# Check if container exists and import it
if [ -n "$STORAGE_EXISTS" ]; then
    echo "Checking for tfstate container..."
    CONTAINER_EXISTS=$(az storage container exists --name "tfstate" --account-name "$STORAGE_ACCOUNT_NAME" --query "exists" -o tsv 2>/dev/null || echo "false")
    
    if [ "$CONTAINER_EXISTS" = "true" ]; then
        echo "Importing storage container..."
        terraform import module.terraform_backend.azurerm_storage_container.tfstate "https://$STORAGE_ACCOUNT_NAME.blob.core.windows.net/tfstate" || true
    fi
fi

echo ""
echo "🔧 Running Terraform plan..."
terraform plan \
    -var="resource_group_name=$RESOURCE_GROUP_NAME" \
    -var="location=$LOCATION" \
    -var="storage_account_name=$STORAGE_ACCOUNT_NAME"

echo ""
echo "✅ Import process completed!"
echo ""
echo "📌 Next steps:"
echo "1. Review the Terraform plan above"
echo "2. If everything looks correct, run: terraform apply"
echo "3. If there are issues, you may need to manually adjust the state"
echo ""
echo "💡 Tip: You can now use this backend configuration in other Terraform projects:"
echo "terraform {"
echo "  backend \"azurerm\" {"
echo "    resource_group_name  = \"$RESOURCE_GROUP_NAME\""
echo "    storage_account_name = \"$STORAGE_ACCOUNT_NAME\""
echo "    container_name       = \"tfstate\""
echo "    key                  = \"terraform.tfstate\""
echo "  }"
echo "}"
