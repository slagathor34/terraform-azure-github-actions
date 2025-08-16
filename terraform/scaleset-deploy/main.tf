# ============================================================================
# VM SCALE SET DEPLOYMENT CONFIGURATION
# ============================================================================
# This configuration deploys VM Scale Sets using custom images from the
# compute gallery, replacing Azure CLI commands with Terraform data sources.

terraform {
  required_version = ">= 1.7"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  
  # Backend configuration will be provided during init
  backend "azurerm" {}
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Data source to get custom image information
data "azurerm_shared_image_version" "custom_image" {
  count               = var.use_custom_image ? 1 : 0
  name                = var.custom_image_version
  image_name          = var.gallery_image_definition_name
  gallery_name        = var.gallery_name
  resource_group_name = var.gallery_resource_group_name
}

# Data source to get existing virtual network (if using existing)
data "azurerm_virtual_network" "existing" {
  count               = var.use_existing_vnet ? 1 : 0
  name                = var.existing_vnet_name
  resource_group_name = var.existing_vnet_resource_group
}

data "azurerm_subnet" "scaleset_subnet" {
  count                = var.use_existing_vnet ? 1 : 0
  name                 = var.scaleset_subnet_name
  virtual_network_name = data.azurerm_virtual_network.existing[0].name
  resource_group_name  = var.existing_vnet_resource_group
}

# Create resource group for scale set deployment
resource "azurerm_resource_group" "scaleset" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Use existing resource group if not creating new one
data "azurerm_resource_group" "existing" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

locals {
  resource_group_name = var.create_resource_group ? azurerm_resource_group.scaleset[0].name : data.azurerm_resource_group.existing[0].name
  resource_group_location = var.create_resource_group ? azurerm_resource_group.scaleset[0].location : data.azurerm_resource_group.existing[0].location
  custom_image_id = var.use_custom_image ? data.azurerm_shared_image_version.custom_image[0].id : null
}

# Deploy VM Scale Set using the module
module "vm_scale_set" {
  source = "../modules/vm-scale-set"
  
  vmss_name           = var.vmss_name
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  subnet_id           = var.use_existing_vnet ? data.azurerm_subnet.scaleset_subnet[0].id : var.subnet_id
  vm_sku              = var.vm_sku
  instances           = var.initial_instances
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  custom_image_id     = local.custom_image_id
  min_instances       = var.min_instances
  max_instances       = var.max_instances
  scale_out_cpu_threshold = var.scale_out_cpu_threshold
  scale_in_cpu_threshold  = var.scale_in_cpu_threshold
  
  tags = var.tags
}
