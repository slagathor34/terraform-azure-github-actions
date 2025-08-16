# ============================================================================
# VM IMAGE CREATION ENVIRONMENT
# ============================================================================
# This environment is used specifically for creating VM images
# It includes only the resources needed for the image creation process

# Configure Terraform and providers
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

# Local variables
locals {
  environment = "image-creation"
  
  common_tags = {
    Environment = local.environment
    Purpose     = "vm-image-template"
    ManagedBy   = "terraform"
    CreatedBy   = "github-actions"
  }
}

# Variables
variable "vm_name" {
  description = "Name of the template VM"
  type        = string
  default     = "template-vm"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "image_version" {
  description = "Version of the image to create"
  type        = string
  default     = "1.0.0"
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${local.environment}-rg"
  location = "East US"
  tags     = local.common_tags
}

# Virtual Network
module "virtual_network" {
  source = "../modules/virtual-network"
  
  vnet_name           = "${local.environment}-vnet"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  address_space      = ["10.0.0.0/16"]
  tags               = local.common_tags
}

# Compute Gallery
module "compute_gallery" {
  source = "../modules/compute-gallery"
  
  gallery_name        = "imageGallery"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  image_name         = "ubuntu-web-server"
  description        = "Gallery for custom VM images"
  tags               = local.common_tags
}

# Storage Account for diagnostics
resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_storage_account" "diagnostics" {
  name                     = "imgcreatesa${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                = azurerm_resource_group.main.location
  account_tier            = "Standard"
  account_replication_type = "LRS"
  
  tags = local.common_tags
}

# Private Endpoint
module "private_endpoint" {
  source = "../modules/private-endpoint"
  
  storage_account_name = azurerm_storage_account.diagnostics.name
  storage_account_id   = azurerm_storage_account.diagnostics.id
  resource_group_name  = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = module.virtual_network.private_endpoint_subnet_id
  virtual_network_id  = module.virtual_network.vnet_id
  tags                = local.common_tags
}

# Virtual Machine for image creation
module "virtual_machine" {
  source = "../modules/virtual-machine"
  
  vm_name            = var.vm_name
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  subnet_id          = module.virtual_network.vm_subnet_id
  ssh_public_key     = var.ssh_public_key
  tags               = local.common_tags
}

# Outputs
output "vm_public_ip" {
  description = "Public IP of the template VM"
  value       = module.virtual_machine.vm_public_ip
}

output "vm_private_ip" {
  description = "Private IP of the template VM"
  value       = module.virtual_machine.vm_private_ip
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "gallery_name" {
  description = "Name of the compute gallery"
  value       = module.compute_gallery.gallery_name
}

output "image_name" {
  description = "Name of the image definition"
  value       = module.compute_gallery.image_name
}
