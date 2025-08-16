# PowerShell script to set up Azure Service Principal for Terraform GitHub Actions
# This script creates a service principal and provides the necessary credentials for GitHub secrets

param(
    [string]$ServicePrincipalName = "terraform-github-actions-$(Get-Date -Format 'yyyyMMddHHmmss')"
)

# Function to write colored output
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

try {
    # Check if Azure CLI is installed
    if (!(Get-Command az -ErrorAction SilentlyContinue)) {
        Write-Error "Azure CLI is not installed. Please install it first:"
        Write-Host "https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
        exit 1
    }

    # Check if user is logged in
    $accountInfo = az account show 2>$null
    if (!$accountInfo) {
        Write-Warning "You are not logged in to Azure CLI."
        Write-Info "Please log in..."
        az login
    }

    # Get current subscription
    $subscription = az account show | ConvertFrom-Json
    $subscriptionId = $subscription.id
    $subscriptionName = $subscription.name

    Write-Info "Current subscription: $subscriptionName ($subscriptionId)"

    # Prompt for confirmation
    $confirmation = Read-Host "Do you want to create a service principal for this subscription? (y/n)"
    if ($confirmation -ne 'y' -and $confirmation -ne 'Y') {
        Write-Warning "Operation cancelled."
        exit 0
    }

    Write-Info "Creating service principal: $ServicePrincipalName"

    # Create service principal
    Write-Info "Creating service principal with Contributor role..."
    $spOutput = az ad sp create-for-rbac `
        --name "$ServicePrincipalName" `
        --role "Contributor" `
        --scopes "/subscriptions/$subscriptionId" `
        --json-auth | ConvertFrom-Json

    # Extract values
    $clientId = $spOutput.clientId
    $clientSecret = $spOutput.clientSecret
    $tenantId = $spOutput.tenantId

    Write-Success "Service principal created successfully!"
    Write-Host ""

    Write-Info "GitHub Secrets Configuration"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "Add the following secrets to your GitHub repository:"
    Write-Host "Go to: Settings > Secrets and variables > Actions > New repository secret"
    Write-Host ""
    Write-Host "Secret Name: AZURE_CLIENT_ID"
    Write-Host "Secret Value: $clientId"
    Write-Host ""
    Write-Host "Secret Name: AZURE_CLIENT_SECRET" 
    Write-Host "Secret Value: $clientSecret"
    Write-Host ""
    Write-Host "Secret Name: AZURE_SUBSCRIPTION_ID"
    Write-Host "Secret Value: $subscriptionId"
    Write-Host ""
    Write-Host "Secret Name: AZURE_TENANT_ID"
    Write-Host "Secret Value: $tenantId"
    Write-Host ""

    Write-Warning "Important: Save these values securely. The client secret cannot be retrieved again."
    Write-Warning "Store these values in your GitHub repository secrets immediately."

    # Optionally save to file
    $saveToFile = Read-Host "Do you want to save these values to a file (azure-secrets.txt)? (y/n)"
    if ($saveToFile -eq 'y' -or $saveToFile -eq 'Y') {
        $secretsContent = @"
# Azure Service Principal Credentials for GitHub Actions
# Add these as secrets in your GitHub repository

AZURE_CLIENT_ID=$clientId
AZURE_CLIENT_SECRET=$clientSecret
AZURE_SUBSCRIPTION_ID=$subscriptionId
AZURE_TENANT_ID=$tenantId

# Service Principal Details
SP_NAME=$ServicePrincipalName
SUBSCRIPTION_NAME=$subscriptionName
CREATED_DATE=$(Get-Date)
"@
        $secretsContent | Out-File -FilePath "azure-secrets.txt" -Encoding UTF8
        Write-Success "Secrets saved to azure-secrets.txt"
        Write-Warning "Remember to delete this file after adding secrets to GitHub!"
    }

    Write-Success "Setup complete! You can now use GitHub Actions for Terraform deployments."
}
catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
    exit 1
}
