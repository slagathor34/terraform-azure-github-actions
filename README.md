# Terraform Azure Infrastructure with GitHub Actions

This repository contains Terraform configurations for deploying infrastructure to Microsoft Azure, with automated deployment using GitHub Actions.

## Architecture

This setup includes:
- **Resource Group**: Container for all Azure resources
- **Storage Account**: For Terraform state management and general storage needs

## Prerequisites

Before using this repository, ensure you have:

1. An Azure subscription
2. A GitHub repository with the following secret configured:
   - `AZURE_CREDENTIALS`: JSON string with Azure Service Principal credentials

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       ├── terraform-plan.yml    # PR validation workflow
│       └── terraform-deploy.yml  # Main deployment workflow
├── terraform/
│   ├── main.tf                   # Main Terraform configuration
│   ├── variables.tf              # Variable definitions
│   ├── outputs.tf                # Output definitions
│   ├── terraform.tfvars.example  # Example variables file
│   └── provider.tf               # Provider configurations
├── scripts/
│   └── setup-azure-auth.sh       # Script to create Azure Service Principal
└── README.md
```

## Setup Instructions

### 1. Fork/Clone this Repository

```bash
git clone <your-repo-url>
cd terraform-azure-github-actions
```

### 2. Create Azure Service Principal

Run the setup script or manually create a service principal:

```bash
# Using Azure CLI
az ad sp create-for-rbac --name "terraform-github-actions" --role="Contributor" --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"
```

This will output JSON with the required credentials for GitHub secrets.

### 3. Configure GitHub Secrets

In your GitHub repository, go to Settings > Secrets and variables > Actions, and add:

- `AZURE_CREDENTIALS`: The complete JSON output from the service principal creation

### 4. Customize Variables

Copy `terraform/terraform.tfvars.example` to `terraform/terraform.tfvars` and update the values:

```hcl
project_name = "myproject"
environment = "dev"
location = "East US"
```

### 5. Initialize and Deploy

The GitHub Actions workflow will automatically:
- Run `terraform plan` on pull requests
- Run `terraform apply` on pushes to main branch

## Manual Deployment

To deploy manually:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## Workflows

### Terraform Plan (terraform-plan.yml)
- Triggers on pull requests to main branch
- Runs terraform plan and comments the plan on the PR
- Validates Terraform configuration

### Terraform Deploy (terraform-deploy.yml)
- Triggers on pushes to main branch
- Runs terraform apply to deploy infrastructure
- Uses remote state management

## Contributing

1. Create a feature branch
2. Make your changes
3. Create a pull request
4. Review the terraform plan in the PR comments
5. Merge to main to deploy

## Security Notes

- Never commit secrets or sensitive data
- Use GitHub secrets for all credentials
- Review terraform plans carefully before merging
- Consider using branch protection rules

## Troubleshooting

### Common Issues

1. **Authentication Errors**: Verify GitHub secrets are correctly set
2. **State Lock Issues**: Check if another deployment is running
3. **Permission Errors**: Ensure service principal has correct permissions

### Getting Help

- Check the Actions tab for detailed logs
- Review terraform plan outputs
- Consult Azure documentation for resource-specific issues
