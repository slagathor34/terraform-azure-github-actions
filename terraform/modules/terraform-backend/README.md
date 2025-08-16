# Terraform Backend Module

This module creates the Azure infrastructure required for Terraform remote state storage, eliminating the need for Azure CLI commands in CI/CD pipelines.

## Resources Created

- **Resource Group**: Dedicated resource group for Terraform state resources
- **Storage Account**: Secure storage account for Terraform state files
- **Storage Container**: Private container for state file storage
- **Blob Service Properties**: Versioning and soft delete enabled for state files

## Usage

```hcl
module "terraform_backend" {
  source = "./modules/terraform-backend"
  
  resource_group_name    = "tfstate-rg"
  location              = "East US"
  storage_account_name  = "tfstateuniquename123"
  
  tags = {
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}
```

## Features

✅ **Pure Terraform**: No Azure CLI commands required  
✅ **Security**: Private container with restricted access  
✅ **Versioning**: State file versioning enabled  
✅ **Soft Delete**: 7-day retention for deleted state files  
✅ **Validation**: Storage account name validation  

## Backend Configuration

After creating the backend resources, configure your Terraform backend:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateuniquename123"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource_group_name | Name of the resource group | `string` | `"tfstate-rg"` | no |
| location | Azure region | `string` | `"East US"` | no |
| storage_account_name | Storage account name (globally unique) | `string` | n/a | yes |
| tags | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| resource_group_name | Resource group name |
| storage_account_name | Storage account name |
| storage_account_primary_key | Storage account access key (sensitive) |
| terraform_backend_config | Complete backend configuration object |
