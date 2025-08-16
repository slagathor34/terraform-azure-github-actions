# Quick Start Guide

This guide will help you get your Terraform Azure infrastructure up and running with GitHub Actions in just a few minutes.

## Prerequisites

- Azure subscription
- GitHub account
- Azure CLI installed locally (for initial setup)

## 🚀 Quick Setup (5 minutes)

### Step 1: Set up Azure Authentication

**Windows (PowerShell):**
```powershell
.\scripts\setup-azure-auth.ps1
```

**Linux/macOS (Bash):**
```bash
chmod +x scripts/setup-azure-auth.sh
./scripts/setup-azure-auth.sh
```

This script will:
- Create an Azure Service Principal
- Display the credentials you need for GitHub

### Step 2: Configure GitHub Secrets

In your GitHub repository, go to **Settings** → **Secrets and variables** → **Actions**

Add this secret:
- `AZURE_CREDENTIALS`

### Step 3: Customize Your Infrastructure

1. Copy the example variables file:
   ```bash
   cp terraform/terraform.tfvars.example terraform/terraform.tfvars
   ```

2. Edit `terraform/terraform.tfvars` with your preferred settings:
   ```hcl
   project_name = "myapp"
   environment = "dev"
   location = "East US"
   ```

### Step 4: Initialize Repository (Optional)

Run the setup workflow to create the Terraform state backend:

1. Go to **Actions** tab in your GitHub repository
2. Click **Repository Setup** workflow
3. Click **Run workflow**
4. Check **Initialize Terraform state backend**
5. Click **Run workflow**

### Step 5: Deploy Your Infrastructure

Create a pull request with your changes:

1. Create a new branch:
   ```bash
   git checkout -b feature/initial-setup
   git add .
   git commit -m "Initial Terraform configuration"
   git push origin feature/initial-setup
   ```

2. Create a pull request on GitHub
3. The **Terraform Plan** workflow will run and comment the plan
4. Review the plan and merge the PR
5. The **Terraform Deploy** workflow will run and deploy your infrastructure

## 📋 What Gets Deployed

Your infrastructure will include:

- **Resource Group**: Container for all resources
- **Storage Account**: For file storage and Terraform state

## 🔧 Common Configurations

### Add Custom Tags

In `terraform/terraform.tfvars`:
```hcl
tags = {
  Environment = "production"
  Project     = "my-web-app"
  ManagedBy   = "terraform"
  Owner       = "devops-team"
  CostCenter  = "IT"
}
```

### Deploy to Different Region

In `terraform/terraform.tfvars`:
```hcl
location = "West US 2"
# or
location = "West Europe"
```

## 🛠️ Manual Operations

### Run Terraform Locally

```bash
cd terraform
terraform init \
  -backend-config="resource_group_name=tfstate-rg" \
  -backend-config="storage_account_name=YOUR_STORAGE_ACCOUNT" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=terraform.tfstate"

terraform plan
terraform apply
```

### Destroy Infrastructure

Use the GitHub Actions workflow:

1. Go to **Actions** → **Terraform Deploy**
2. Click **Run workflow**
3. Select **destroy** from the action dropdown
4. Click **Run workflow**

Or manually:
```bash
cd terraform
terraform destroy
```

## 🔍 Monitoring Your Deployment

After deployment:

1. Check the **Actions** tab for deployment status
2. Monitor resources in the Azure Portal
3. Check Terraform outputs for resource details

## ❓ Troubleshooting

### Authentication Issues
- Verify GitHub secrets are correctly set
- Check that the Service Principal has Contributor role
- Ensure the subscription ID is correct

### Terraform State Issues
- Run the Repository Setup workflow to initialize state backend
- Check that the storage account exists and is accessible

### Deployment Failures
- Review the GitHub Actions logs
- Check the Terraform plan for any issues
- Verify Azure quotas and limits

## 🎯 Next Steps

1. **Customize the infrastructure** by modifying `terraform/main.tf`
2. **Add more resources** like databases, Key Vault, or networking
3. **Set up application deployment** by adding build and deploy steps
4. **Configure monitoring** and alerting
5. **Set up multiple environments** (dev, staging, prod)

## 📚 Additional Resources

- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure CLI Reference](https://docs.microsoft.com/en-us/cli/azure/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

Happy deploying! 🚀
