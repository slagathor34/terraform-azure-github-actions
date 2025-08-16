# ============================================================================
# VM IMAGE CREATION CONFIGURATION
# ============================================================================
# This configuration creates VM images from template VMs using pure Terraform,
# replacing Azure CLI commands in the CI/CD pipeline.

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
    virtual_machine {
      delete_os_disk_on_deletion     = true
      graceful_shutdown              = true
      skip_shutdown_and_force_delete = false
    }
  }
}

# VM Image Operations Module
module "vm_image_operations" {
  source = "../modules/vm-image-operations"
  
  resource_group_name             = var.resource_group_name
  location                       = var.location
  source_vm_name                 = var.source_vm_name
  deallocate_vm                  = var.deallocate_vm
  create_gallery_image_version   = var.create_gallery_image_version
  gallery_name                   = var.gallery_name
  gallery_image_definition_name  = var.gallery_image_definition_name
  image_version                  = var.image_version
  replica_count                  = var.replica_count
  storage_account_type           = var.storage_account_type
  additional_target_regions      = var.additional_target_regions
  
  tags = var.tags
}
