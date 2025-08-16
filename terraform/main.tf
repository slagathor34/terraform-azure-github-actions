# ============================================================================
# TERRAFORM AZURE INFRASTRUCTURE
# ============================================================================
# This file orchestrates the deployment of Azure resources using modules
# for better organization, reusability, and maintainability.

# Resource Group
module "resource_group" {
  source = "./modules/resource-group"
  
  name     = var.resource_group_name != null ? var.resource_group_name : "${var.project_name}-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}

# Storage Account
module "storage_account" {
  source = "./modules/storage-account"
  
  name                = "${var.project_name}${var.environment}st"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  account_tier        = var.storage_account_tier
  replication_type    = var.storage_replication_type
  tags                = var.tags
}

# ============================================================================
# OPTIONAL COMPONENTS (uncomment to enable)
# ============================================================================

# App Service (uncomment to enable)
# module "app_service" {
#   source = "./modules/app-service"
#   
#   name                = "${var.project_name}-${var.environment}-app"
#   location            = module.resource_group.location
#   resource_group_name = module.resource_group.name
#   os_type             = "Linux"
#   sku_name            = "B1"
#   tags                = var.tags
# }

# Key Vault (uncomment to enable)
# module "key_vault" {
#   source = "./modules/key-vault"
#   
#   name                = "${var.project_name}-${var.environment}-kv"
#   location            = module.resource_group.location
#   resource_group_name = module.resource_group.name
#   tags                = var.tags
# }
