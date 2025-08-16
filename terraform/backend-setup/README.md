# Terraform Backend Setup

This configuration creates the Azure infrastructure required for Terraform remote state storage.

## 🚨 Important: Handling Existing Resources

If you get an error like:
```
Error: A resource with the ID "/subscriptions/.../resourceGroups/tfstate-rg" already exists
```

This means the resource group (and possibly storage account) already exists in Azure but is not managed by Terraform. You have two options:

### Option 1: Import Existing Resources (Recommended)

Use the provided import scripts to bring existing resources under Terraform management:

**PowerShell:**
```powershell
.\import-existing-resources.ps1 [resource-group-name] [location]
```

**Bash:**
```bash
./import-existing-resources.sh [resource-group-name] [location]
```

**Example:**
```powershell
.\import-existing-resources.ps1 "tfstate-rg" "East US"
```

### Option 2: Use Different Resource Names

Modify the variables to use different resource names:

```bash
terraform apply \
  -var="resource_group_name=tfstate-rg-new" \
  -var="location=East US"
```

## 🚀 Quick Start

### First Time Setup

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **If resources exist, run import script:**
   ```bash
   ./import-existing-resources.sh
   ```

3. **Apply configuration:**
   ```bash
   terraform apply
   ```

### Fresh Setup (No Existing Resources)

```bash
terraform init
terraform plan
terraform apply
```

## 📋 Configuration

### Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| resource_group_name | Resource group name | `tfstate-rg` | No |
| location | Azure region | `East US` | No |
| tags | Resource tags | `{}` | No |

### Example Usage

```bash
terraform apply \
  -var="resource_group_name=my-tfstate-rg" \
  -var="location=West US 2" \
  -var='tags={"Environment"="shared","Project"="infrastructure"}'
```

## 🔧 Generated Resources

- **Resource Group**: `tfstate-rg` (or specified name)
- **Storage Account**: `tfstate{subscription-hash}` (automatically generated)
- **Storage Container**: `tfstate`

## 📤 Outputs

After successful deployment, use the outputs to configure other Terraform projects:

```bash
terraform output -json
```

Example output:
```json
{
  "backend_configuration": {
    "container_name": "tfstate",
    "key": "terraform.tfstate",
    "resource_group_name": "tfstate-rg",
    "storage_account_name": "tfstate1a2b3c4d5e6f7g8h"
  }
}
```

## 🔐 Backend Configuration for Other Projects

Use this configuration in your other Terraform projects:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstate1a2b3c4d5e6f7g8h"  # Use actual name from output
    container_name       = "tfstate"
    key                  = "prod/terraform.tfstate"   # Change per environment
  }
}
```

## 🛠️ Troubleshooting

### Resource Already Exists Error
- **Cause**: Resources exist in Azure but not in Terraform state
- **Solution**: Use the import scripts provided

### Storage Account Name Conflicts
- **Cause**: Storage account names must be globally unique
- **Solution**: The module generates unique names using subscription hash

### Permission Errors
- **Cause**: Insufficient Azure permissions
- **Solution**: Ensure you have Contributor access to the subscription

### Import Script Errors
- **Prerequisites**: 
  - Azure CLI installed and logged in (`az login`)
  - Terraform installed
  - Proper Azure permissions

## 📁 Files

- `main.tf` - Main Terraform configuration
- `variables.tf` - Input variables
- `outputs.tf` - Output values
- `import-existing-resources.ps1` - PowerShell import script
- `import-existing-resources.sh` - Bash import script
- `README.md` - This documentation

## 🔄 State Management

This backend configuration includes:
- ✅ **Blob versioning** for state file history
- ✅ **Soft delete** (7-day retention)
- ✅ **Container soft delete** (7-day retention)
- ✅ **Private access** (no public access)
- ✅ **Secure key management**
