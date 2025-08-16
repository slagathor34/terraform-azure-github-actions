# Test Azure authentication with the same credentials used in GitHub Actions
# This script helps verify that your Azure Service Principal works correctly

param(
    [string]$ClientId,
    [string]$ClientSecret,
    [string]$TenantId,
    [string]$SubscriptionId
)

# If parameters not provided, try to read from azure-secrets.txt
if (-not $ClientId -and (Test-Path "azure-secrets.txt")) {
    Write-Host "Reading credentials from azure-secrets.txt..." -ForegroundColor Yellow
    $content = Get-Content "azure-secrets.txt"
    foreach ($line in $content) {
        if ($line -match "AZURE_CLIENT_ID=(.+)") { $ClientId = $matches[1] }
        if ($line -match "AZURE_CLIENT_SECRET=(.+)") { $ClientSecret = $matches[1] }
        if ($line -match "AZURE_TENANT_ID=(.+)") { $TenantId = $matches[1] }
        if ($line -match "AZURE_SUBSCRIPTION_ID=(.+)") { $SubscriptionId = $matches[1] }
    }
}

# Verify we have all required parameters
if (-not $ClientId -or -not $ClientSecret -or -not $TenantId -or -not $SubscriptionId) {
    Write-Error "Missing required parameters. Please provide or ensure azure-secrets.txt exists."
    Write-Host ""
    Write-Host "Usage: .\test-azure-auth.ps1 -ClientId 'xxx' -ClientSecret 'xxx' -TenantId 'xxx' -SubscriptionId 'xxx'"
    Write-Host "Or ensure azure-secrets.txt file exists with the credentials."
    exit 1
}

Write-Host "Testing Azure Service Principal Authentication..." -ForegroundColor Green
Write-Host "Client ID: $ClientId" -ForegroundColor Gray
Write-Host "Tenant ID: $TenantId" -ForegroundColor Gray
Write-Host "Subscription ID: $SubscriptionId" -ForegroundColor Gray
Write-Host ""

# Add Azure CLI to PATH
$env:PATH += ";C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin"

try {
    # Test Service Principal login
    Write-Host "🔐 Testing Service Principal login..." -ForegroundColor Blue
    az login --service-principal --username $ClientId --password $ClientSecret --tenant $TenantId --output none
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Service Principal login successful!" -ForegroundColor Green
    } else {
        Write-Host "❌ Service Principal login failed!" -ForegroundColor Red
        exit 1
    }
    
    # Set subscription
    Write-Host "🔄 Setting subscription..." -ForegroundColor Blue
    az account set --subscription $SubscriptionId
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Subscription set successfully!" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed to set subscription!" -ForegroundColor Red
        exit 1
    }
    
    # Test permissions by listing resource groups
    Write-Host "🏗️ Testing permissions (listing resource groups)..." -ForegroundColor Blue
    $resourceGroups = az group list --output json | ConvertFrom-Json
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Successfully listed $($resourceGroups.Count) resource groups!" -ForegroundColor Green
        if ($resourceGroups.Count -gt 0) {
            Write-Host "Sample resource groups:" -ForegroundColor Gray
            $resourceGroups | Select-Object -First 3 | ForEach-Object {
                Write-Host "  - $($_.name) ($($_.location))" -ForegroundColor Gray
            }
        }
    } else {
        Write-Host "❌ Failed to list resource groups!" -ForegroundColor Red
        exit 1
    }
    
    # Test Terraform state storage account access
    Write-Host "💾 Testing Terraform state storage access..." -ForegroundColor Blue
    $tfStateRg = "tfstate-rg"
    $storageAccounts = az storage account list --resource-group $tfStateRg --output json 2>$null | ConvertFrom-Json
    
    if ($storageAccounts -and $storageAccounts.Count -gt 0) {
        Write-Host "✅ Found Terraform state storage account: $($storageAccounts[0].name)" -ForegroundColor Green
    } else {
        Write-Host "⚠️ No Terraform state storage account found. Will be created during deployment." -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "🎉 All authentication tests passed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your GitHub Actions should now work correctly with these credentials:" -ForegroundColor Yellow
    Write-Host "✅ AZURE_CLIENT_ID: $ClientId"
    Write-Host "✅ AZURE_CLIENT_SECRET: [HIDDEN]"
    Write-Host "✅ AZURE_TENANT_ID: $TenantId"
    Write-Host "✅ AZURE_SUBSCRIPTION_ID: $SubscriptionId"
    
} catch {
    Write-Host "❌ Authentication test failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
} finally {
    # Logout to clean up
    az logout --output none 2>$null
}
