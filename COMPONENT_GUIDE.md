# Adding New Azure Components

This guide explains how to add new Azure components to your Terraform infrastructure.

## 🏗️ Repository Structure

```
terraform/
├── main.tf                     # Main orchestration file
├── variables.tf                # Global variables
├── outputs.tf                  # Global outputs
├── provider.tf                 # Provider configuration
├── modules/                    # Reusable component modules
│   ├── resource-group/         # Resource group module
│   ├── storage-account/        # Storage account module
│   ├── app-service/           # App service module (ready to use)
│   ├── sql-database/          # SQL database module (template)
│   └── key-vault/             # Key vault module (template)
├── environments/              # Environment-specific configurations
│   ├── dev/
│   ├── staging/
│   └── prod/
```

## ✅ Available Components (Ready to Enable)

### 1. App Service
Uncomment in `main.tf`:
```hcl
module "app_service" {
  source = "./modules/app-service"
  
  name                = "${var.project_name}-${var.environment}-app"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  os_type             = "Linux"
  sku_name            = "B1"
  tags                = var.tags
}
```

## 🚀 How to Add New Components

### Step 1: Create Module Directory
```bash
mkdir terraform/modules/[component-name]
```

### Step 2: Create Module Files
- `main.tf` - Resource definitions
- `variables.tf` - Input variables
- `outputs.tf` - Output values

### Step 3: Add to Main Configuration
In `terraform/main.tf`:
```hcl
module "component_name" {
  source = "./modules/component-name"
  
  # Pass required variables
  name                = "${var.project_name}-${var.environment}-component"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}
```

### Step 4: Add Outputs (if needed)
In `terraform/outputs.tf`:
```hcl
output "component_name" {
  description = "Component information"
  value       = module.component_name.name
}
```

## 📋 Common Azure Components Templates

### SQL Database Module Template
```hcl
# terraform/modules/sql-database/main.tf
resource "azurerm_mssql_server" "this" {
  name                         = var.server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  tags                         = var.tags
}

resource "azurerm_mssql_database" "this" {
  name      = var.database_name
  server_id = azurerm_mssql_server.this.id
  tags      = var.tags
}
```

### Key Vault Module Template
```hcl
# terraform/modules/key-vault/main.tf
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  tags                = var.tags

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
    ]
  }
}
```

## 🔧 Environment-Specific Deployments

### Deploy to Different Environments
```bash
# Development
terraform init
terraform plan -var-file="environments/dev/terraform.tfvars"
terraform apply -var-file="environments/dev/terraform.tfvars"

# Production
terraform init
terraform plan -var-file="environments/prod/terraform.tfvars"
terraform apply -var-file="environments/prod/terraform.tfvars"
```

## 💡 Best Practices

1. **Module Design**: Keep modules focused on single resources or tightly coupled resource groups
2. **Validation**: Add variable validation where appropriate
3. **Tagging**: Ensure all resources inherit tags from the root module
4. **Naming**: Use consistent naming conventions across all components
5. **Outputs**: Expose useful information from modules for other modules to consume
6. **Documentation**: Update this guide when adding new components

## 🎯 Quick Start for Common Components

### Add App Service (Web App):
1. Uncomment the app service module in `main.tf`
2. Run `terraform plan` to see changes
3. Run `terraform apply` to deploy

### Add SQL Database:
1. Create the SQL database module using the template above
2. Add module call to `main.tf`
3. Add required variables to `variables.tf`
4. Deploy with `terraform apply`

### Add Key Vault:
1. Create the Key Vault module using the template above
2. Add module call to `main.tf`
3. Configure access policies as needed
4. Deploy with `terraform apply`
