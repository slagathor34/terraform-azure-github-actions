# Helper script to push to GitHub repository
# Run this script after creating your GitHub repository

param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubUrl
)

# Add Git to PATH
$env:PATH += ";C:\Program Files\Git\bin"

Write-Host "Setting up GitHub repository..." -ForegroundColor Green

# Add remote origin
git remote add origin $GitHubUrl

# Rename branch to main (GitHub's default)
git branch -M main

# Push to GitHub
git push -u origin main

Write-Host ""
Write-Host "✅ Repository successfully pushed to GitHub!" -ForegroundColor Green
Write-Host "🔗 Repository URL: $GitHubUrl" -ForegroundColor Blue
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Set up Azure Service Principal using: .\scripts\setup-azure-auth.ps1" -ForegroundColor White
Write-Host "2. Add the Azure credentials as GitHub secrets" -ForegroundColor White
Write-Host "3. Customize terraform\terraform.tfvars.example and rename to terraform.tfvars" -ForegroundColor White
Write-Host "4. Create a pull request to test the pipeline" -ForegroundColor White
