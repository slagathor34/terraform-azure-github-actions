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

# SQL Database (uncomment to enable)
# module "sql_database" {
#   source = "./modules/sql-database"
#   
#   server_name         = "${var.project_name}-${var.environment}-sqlserver"
#   database_name       = "${var.project_name}-${var.environment}-sqldb"
#   location            = module.resource_group.location
#   resource_group_name = module.resource_group.name
#   admin_login         = var.sql_admin_login
#   admin_password      = var.sql_admin_password
#   tags                = var.tags
# }

# ============================================================================
# VM-TO-SCALE-SET PIPELINE COMPONENTS (uncomment to enable)
# ============================================================================

# Virtual Network (uncomment to enable VM features)
# module "virtual_network" {
#   source = "./modules/virtual-network"
#   
#   vnet_name           = "${var.project_name}-${var.environment}-vnet"
#   location            = module.resource_group.location
#   resource_group_name = module.resource_group.name
#   address_space       = ["10.0.0.0/16"]
#   vm_subnet_prefix    = "10.0.1.0/24"
#   scaleset_subnet_prefix = "10.0.2.0/24"
#   pe_subnet_prefix    = "10.0.3.0/24"
#   tags                = var.tags
# }

# Compute Gallery (uncomment to enable custom image management)
# module "compute_gallery" {
#   source = "./modules/compute-gallery"
#   
#   gallery_name        = "${var.project_name}${var.environment}gallery"
#   location            = module.resource_group.location
#   resource_group_name = module.resource_group.name
#   image_definition_name = "${var.project_name}-web-image"
#   image_publisher     = var.image_publisher
#   image_offer         = var.image_offer
#   image_sku           = var.image_sku
#   tags                = var.tags
# }

# Template Virtual Machine (uncomment to enable VM image creation)
# module "virtual_machine" {
#   source = "./modules/virtual-machine"
#   
#   vm_name             = "${var.project_name}-${var.environment}-template-vm"
#   location            = module.resource_group.location
#   resource_group_name = module.resource_group.name
#   subnet_id           = module.virtual_network.vm_subnet_id
#   vm_size             = var.vm_size
#   admin_username      = var.vm_admin_username
#   ssh_public_key      = var.ssh_public_key
#   image_publisher     = var.image_publisher
#   image_offer         = var.image_offer
#   image_sku           = var.image_sku
#   image_version       = var.image_version
#   tags                = var.tags
#   
#   depends_on = [module.virtual_network]
# }

# VM Scale Set (uncomment to enable auto-scaling web applications)
# module "vm_scale_set" {
#   source = "./modules/vm-scale-set"
#   
#   vmss_name           = "${var.project_name}-${var.environment}-vmss"
#   location            = module.resource_group.location
#   resource_group_name = module.resource_group.name
#   subnet_id           = module.virtual_network.scaleset_subnet_id
#   vm_sku              = var.vmss_vm_size
#   instances           = var.vmss_initial_instances
#   admin_username      = var.vm_admin_username
#   ssh_public_key      = var.ssh_public_key
#   custom_image_id     = var.custom_image_id
#   min_instances       = var.vmss_min_instances
#   max_instances       = var.vmss_max_instances
#   scale_out_cpu_threshold = var.vmss_scale_out_cpu_threshold
#   scale_in_cpu_threshold  = var.vmss_scale_in_cpu_threshold
#   tags                = var.tags
#   
#   depends_on = [module.virtual_network]
# }

# Private Endpoints (uncomment to enable secure connectivity)
# module "private_endpoint" {
#   source = "./modules/private-endpoint"
#   
#   location            = module.resource_group.location
#   resource_group_name = module.resource_group.name
#   virtual_network_id  = module.virtual_network.vnet_id
#   subnet_id           = module.virtual_network.pe_subnet_id
#   storage_account_id  = module.storage_account.id
#   key_vault_id        = var.enable_key_vault ? module.key_vault.id : null
#   tags                = var.tags
#   
#   depends_on = [module.virtual_network, module.storage_account]
# }
