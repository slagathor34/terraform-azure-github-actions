# ============================================================================
# SCALE SET DEPLOYMENT ENVIRONMENT
# ============================================================================
# This environment is used for deploying VM Scale Sets using custom images

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
  environment = "scaleset"
  
  common_tags = {
    Environment = local.environment
    Purpose     = "web-application"
    ManagedBy   = "terraform"
    CreatedBy   = "github-actions"
  }
}

# Variables
variable "scale_set_name" {
  description = "Name of the VM Scale Set"
  type        = string
  default     = "web-scale-set"
}

variable "custom_image_id" {
  description = "ID of the custom image to use"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "initial_instances" {
  description = "Initial number of instances"
  type        = number
  default     = 2
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 10
}

# Data sources for existing resources
data "azurerm_shared_image_gallery" "main" {
  name                = "imageGallery"
  resource_group_name = "image-creation-rg"
}

# Resource Group for Scale Set
resource "azurerm_resource_group" "main" {
  name     = "${local.environment}-rg"
  location = "East US"
  tags     = local.common_tags
}

# Virtual Network for Scale Set
module "virtual_network" {
  source = "../modules/virtual-network"
  
  vnet_name           = "${local.environment}-vnet"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  address_space      = ["10.2.0.0/16"]
  vm_subnet_cidr     = "10.2.1.0/24"
  scale_set_subnet_cidr = "10.2.2.0/24"
  private_endpoint_subnet_cidr = "10.2.3.0/24"
  tags               = local.common_tags
}

# VM Scale Set
module "vm_scale_set" {
  source = "../modules/vm-scale-set"
  
  scale_set_name         = var.scale_set_name
  resource_group_name    = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  custom_image_id       = var.custom_image_id
  subnet_id             = module.virtual_network.scale_set_subnet_id
  gallery_id            = data.azurerm_shared_image_gallery.main.id
  ssh_public_key        = var.ssh_public_key
  initial_instance_count = var.initial_instances
  max_instance_count    = var.max_instances
  tags                  = local.common_tags
}

# Outputs
output "scale_set_id" {
  description = "ID of the VM Scale Set"
  value       = module.vm_scale_set.scale_set_id
}

output "scale_set_name" {
  description = "Name of the VM Scale Set"
  value       = module.vm_scale_set.scale_set_name
}

output "load_balancer_public_ip" {
  description = "Public IP of the load balancer"
  value       = module.vm_scale_set.load_balancer_public_ip
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}
