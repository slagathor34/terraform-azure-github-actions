#!/usr/bin/env pwsh

# Script to verify and display the exact values needed for GitHub Secrets
# Run this to get the exact values to manually add to GitHub repository secrets

Write-Host "=== Azure Service Principal Information for GitHub Secrets ===" -ForegroundColor Cyan

# Get current subscription and tenant
$subscription = az account show --query "id" -o tsv
$tenant = az account show --query "tenantId" -o tsv

if (-not $subscription -or -not $tenant) {
    Write-Error "Please run 'az login' first to authenticate with Azure"
    exit 1
}

Write-Host "`nCurrent Azure Context:" -ForegroundColor Yellow
Write-Host "Subscription ID: $subscription"
Write-Host "Tenant ID: $tenant"

# Get the Service Principal details
$spName = "terraform-github-actions-$(Get-Date -Format 'yyyyMMddHHmmss')"
Write-Host "`nLooking for existing Service Principal..." -ForegroundColor Yellow

$existingSP = az ad sp list --display-name "terraform-github-actions" --query "[0]" 2>$null
if ($existingSP -and $existingSP -ne "null") {
    $spInfo = $existingSP | ConvertFrom-Json
    $clientId = $spInfo.appId
    Write-Host "Found existing Service Principal: $($spInfo.displayName)"
    Write-Host "Client ID: $clientId"
} else {
    Write-Host "No existing Service Principal found. Creating new one..." -ForegroundColor Yellow
    
    # Create new Service Principal
    $sp = az ad sp create-for-rbac --name $spName --role Contributor --scopes "/subscriptions/$subscription" | ConvertFrom-Json
    
    if ($sp) {
        $clientId = $sp.appId
        $clientSecret = $sp.password
        
        Write-Host "`nService Principal created successfully!" -ForegroundColor Green
        Write-Host "Display Name: $spName"
        Write-Host "Client ID: $clientId"
        Write-Host "Client Secret: $clientSecret"
    } else {
        Write-Error "Failed to create Service Principal"
        exit 1
    }
}

Write-Host "`n=== GITHUB SECRETS TO CREATE ===" -ForegroundColor Green
Write-Host "Go to: https://github.com/slagathor34/terraform-azure-github-actions/settings/secrets/actions"
Write-Host "Create these secrets with EXACT values shown below:"
Write-Host ""
Write-Host "AZURE_CLIENT_ID = $clientId" -ForegroundColor White
Write-Host "AZURE_TENANT_ID = $tenant" -ForegroundColor White
Write-Host "AZURE_SUBSCRIPTION_ID = $subscription" -ForegroundColor White

if ($clientSecret) {
    Write-Host "AZURE_CLIENT_SECRET = $clientSecret" -ForegroundColor White
} else {
    Write-Host "AZURE_CLIENT_SECRET = [You need to create a new client secret for existing SP]" -ForegroundColor Red
    Write-Host ""
    Write-Host "To create a new client secret for existing SP, run:" -ForegroundColor Yellow
    Write-Host "az ad sp credential reset --id $clientId --display-name 'GitHub Actions Secret'"
}

Write-Host ""
Write-Host "=== VERIFICATION COMMAND ===" -ForegroundColor Magenta
Write-Host "After creating the secrets, test authentication with:" -ForegroundColor White
Write-Host "az login --service-principal --username $clientId --password [CLIENT_SECRET] --tenant $tenant"
Write-Host ""
