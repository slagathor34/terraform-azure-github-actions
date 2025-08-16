# ============================================================================
# TERRAFORM BACKEND IMPORT SCRIPT (PowerShell)
# ============================================================================
# This script helps import existing Azure resources into Terraform state
# to avoid conflicts when resources already exist.

Write-Host "🔄 Terraform Backend Resource Import Script" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

# Check if we're in the right directory
if (-not (Test-Path "main.tf")) {
    Write-Host "❌ Error: This script must be run from a Terraform configuration directory containing main.tf" -ForegroundColor Red
    exit 1
}

# Get Azure subscription info
Write-Host "📋 Getting Azure subscription information..." -ForegroundColor Yellow
$subscriptionId = ""

try {
    $subscriptionId = az account show --query id --output tsv
    if (-not $subscriptionId) {
        throw "No subscription found"
    }
} catch {
    Write-Host "❌ Error: Not logged into Azure CLI. Please run 'az login' first." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Using subscription: $subscriptionId" -ForegroundColor Green

# Default values
$resourceGroupName = if ($args[0]) { $args[0] } else { "tfstate-rg" }
$location = if ($args[1]) { $args[1] } else { "East US" }

# Generate storage account name (same logic as in Terraform)
$hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($subscriptionId))
$hashString = [System.BitConverter]::ToString($hash).Replace("-", "").ToLower()
$storageAccountName = "tfstate" + $hashString.Substring(0, 16)

Write-Host ""
Write-Host "🔍 Checking for existing resources..." -ForegroundColor Yellow
Write-Host "Resource Group: $resourceGroupName"
Write-Host "Storage Account: $storageAccountName"
Write-Host "Location: $location"

# Check if resources exist
$rgExists = (az group exists --name $resourceGroupName) -eq "true"
$storageExists = $false

if ($rgExists) {
    Write-Host "✅ Resource group '$resourceGroupName' exists" -ForegroundColor Green
    try {
        $existingStorage = az storage account list --resource-group $resourceGroupName --query "[?name=='$storageAccountName'].name | [0]" -o tsv
        $storageExists = -not [string]::IsNullOrEmpty($existingStorage)
        
        if ($storageExists) {
            Write-Host "✅ Storage account '$storageAccountName' exists" -ForegroundColor Green
        } else {
            Write-Host "ℹ️  Storage account '$storageAccountName' does not exist" -ForegroundColor Blue
        }
    } catch {
        Write-Host "ℹ️  Storage account '$storageAccountName' does not exist" -ForegroundColor Blue
    }
} else {
    Write-Host "ℹ️  Resource group '$resourceGroupName' does not exist" -ForegroundColor Blue
}

Write-Host ""
Write-Host "🚀 Initializing Terraform..." -ForegroundColor Yellow
terraform init

Write-Host ""
Write-Host "📥 Importing existing resources..." -ForegroundColor Yellow

# Import resource group if it exists
if ($rgExists) {
    Write-Host "Importing resource group..."
    try {
        terraform import module.terraform_backend.azurerm_resource_group.tfstate "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
    } catch {
        Write-Host "Note: Resource group may already be imported or import failed" -ForegroundColor Yellow
    }
}

# Import storage account if it exists
if ($storageExists) {
    Write-Host "Importing storage account..."
    try {
        terraform import module.terraform_backend.azurerm_storage_account.tfstate "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$storageAccountName"
    } catch {
        Write-Host "Note: Storage account may already be imported or import failed" -ForegroundColor Yellow
    }
}

# Check if container exists and import it
if ($storageExists) {
    Write-Host "Checking for tfstate container..."
    try {
        $containerExists = (az storage container exists --name "tfstate" --account-name $storageAccountName --query "exists" -o tsv) -eq "true"
        
        if ($containerExists) {
            Write-Host "Importing storage container..."
            terraform import module.terraform_backend.azurerm_storage_container.tfstate "https://$storageAccountName.blob.core.windows.net/tfstate"
        }
    } catch {
        Write-Host "Note: Container may not exist or import failed" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "🔧 Running Terraform plan..." -ForegroundColor Yellow
terraform plan `
    -var="resource_group_name=$resourceGroupName" `
    -var="location=$location" `
    -var="storage_account_name=$storageAccountName"

Write-Host ""
Write-Host "✅ Import process completed!" -ForegroundColor Green
Write-Host ""
Write-Host "📌 Next steps:" -ForegroundColor Cyan
Write-Host "1. Review the Terraform plan above"
Write-Host "2. If everything looks correct, run: terraform apply"
Write-Host "3. If there are issues, you may need to manually adjust the state"
Write-Host ""
Write-Host "💡 Tip: You can now use this backend configuration in other Terraform projects:" -ForegroundColor Cyan
Write-Host "terraform {"
Write-Host "  backend `"azurerm`" {"
Write-Host "    resource_group_name  = `"$resourceGroupName`""
Write-Host "    storage_account_name = `"$storageAccountName`""
Write-Host "    container_name       = `"tfstate`""
Write-Host "    key                  = `"terraform.tfstate`""
Write-Host "  }"
Write-Host "}"
