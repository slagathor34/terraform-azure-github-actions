# ============================================================================
# VM-TO-SCALE-SET EXAMPLE CONFIGURATION
# ============================================================================
# This file demonstrates how to use the VM-to-Scale-Set modules
# Copy and modify this configuration as needed for your specific use case

# ============================================================================
# EXAMPLE: VM Image Creation Infrastructure
# ============================================================================
# Uncomment and modify the following modules to create VM image infrastructure

# Virtual Network for VM operations
# module "vm_network" {
#   source = "./modules/virtual-network"
#   
#   vnet_name           = "${var.project_name}-vm-vnet"
#   resource_group_name = module.resource_group.name
#   location           = module.resource_group.location
#   address_space      = ["10.1.0.0/16"]
#   vm_subnet_cidr     = "10.1.1.0/24"
#   scale_set_subnet_cidr = "10.1.2.0/24"
#   private_endpoint_subnet_cidr = "10.1.3.0/24"
#   tags               = var.tags
# }

# Compute Gallery for custom images
# module "compute_gallery" {
#   source = "./modules/compute-gallery"
#   
#   gallery_name        = "${var.project_name}Gallery"
#   resource_group_name = module.resource_group.name
#   location           = module.resource_group.location
#   image_name         = "ubuntu-web-server"
#   description        = "Shared image gallery for ${var.project_name}"
#   tags               = var.tags
# }

# Private Endpoints for secure connectivity
# module "private_endpoints" {
#   source = "./modules/private-endpoint"
#   
#   storage_account_name = module.storage_account.name
#   storage_account_id   = module.storage_account.id
#   resource_group_name  = module.resource_group.name
#   location            = module.resource_group.location
#   subnet_id           = module.vm_network.private_endpoint_subnet_id
#   virtual_network_id  = module.vm_network.vnet_id
#   tags                = var.tags
# }

# ============================================================================
# EXAMPLE: Template VM for Image Creation
# ============================================================================
# This VM will be used to create the custom image

# Template Virtual Machine
# module "template_vm" {
#   source = "./modules/virtual-machine"
#   
#   vm_name            = "${var.project_name}-template-vm"
#   resource_group_name = module.resource_group.name
#   location           = module.resource_group.location
#   subnet_id          = module.vm_network.vm_subnet_id
#   ssh_public_key     = var.ssh_public_key
#   vm_size            = "Standard_B2s"
#   key_vault_id       = null  # Optional: module.key_vault.id
#   tags               = var.tags
# }

# ============================================================================
# EXAMPLE: Production Scale Set
# ============================================================================
# This scale set uses the custom image created from the template VM

# Production Virtual Network (separate from template VM network)
# module "prod_network" {
#   source = "./modules/virtual-network"
#   
#   vnet_name           = "${var.project_name}-prod-vnet"
#   resource_group_name = module.resource_group.name
#   location           = module.resource_group.location
#   address_space      = ["10.2.0.0/16"]
#   vm_subnet_cidr     = "10.2.1.0/24"
#   scale_set_subnet_cidr = "10.2.2.0/24"
#   private_endpoint_subnet_cidr = "10.2.3.0/24"
#   tags               = var.tags
# }

# VM Scale Set using custom image
# module "web_scale_set" {
#   source = "./modules/vm-scale-set"
#   
#   scale_set_name         = "${var.project_name}-web-scaleset"
#   resource_group_name    = module.resource_group.name
#   location              = module.resource_group.location
#   custom_image_id       = var.custom_image_id  # From compute gallery
#   subnet_id             = module.prod_network.scale_set_subnet_id
#   gallery_id            = module.compute_gallery.gallery_id
#   ssh_public_key        = var.ssh_public_key
#   initial_instance_count = 2
#   min_instance_count    = 1
#   max_instance_count    = 10
#   vm_sku                = "Standard_B2s"
#   upgrade_mode          = "Manual"
#   tags                  = var.tags
# }

# ============================================================================
# EXAMPLE VARIABLES (add to variables.tf when using these modules)
# ============================================================================

# variable "ssh_public_key" {
#   description = "SSH public key for VM access"
#   type        = string
#   sensitive   = true
# }

# variable "custom_image_id" {
#   description = "ID of the custom image to use for scale set"
#   type        = string
#   default     = null
# }

# ============================================================================
# EXAMPLE OUTPUTS (add to outputs.tf when using these modules)
# ============================================================================

# VM Network Outputs
# output "vm_network_id" {
#   description = "ID of the VM virtual network"
#   value       = module.vm_network.vnet_id
# }

# output "template_vm_public_ip" {
#   description = "Public IP of the template VM"
#   value       = module.template_vm.vm_public_ip
# }

# Compute Gallery Outputs
# output "compute_gallery_name" {
#   description = "Name of the compute gallery"
#   value       = module.compute_gallery.gallery_name
# }

# output "compute_image_name" {
#   description = "Name of the compute image"
#   value       = module.compute_gallery.image_name
# }

# Scale Set Outputs
# output "scale_set_load_balancer_ip" {
#   description = "Public IP of the scale set load balancer"
#   value       = module.web_scale_set.load_balancer_public_ip
# }

# output "scale_set_id" {
#   description = "ID of the VM scale set"
#   value       = module.web_scale_set.scale_set_id
# }
