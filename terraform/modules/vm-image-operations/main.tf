# ============================================================================
# VM IMAGE OPERATIONS MODULE
# ============================================================================
# This module provides Terraform resources for VM image operations,
# replacing Azure CLI commands for VM deallocation, generalization, and
# compute gallery image version creation.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Data source to get VM information
data "azurerm_virtual_machine" "template_vm" {
  count               = var.source_vm_name != null ? 1 : 0
  name                = var.source_vm_name
  resource_group_name = var.resource_group_name
}

# Create image from VM (assumes VM is already generalized)
# Note: The VM must be manually deallocated and generalized before running this
# This can be done through Ansible playbooks or Azure CLI in the workflow
resource "azurerm_image" "vm_image" {
  count               = var.create_managed_image ? 1 : 0
  name                = var.image_name
  location            = var.location
  resource_group_name = var.resource_group_name
  
  source_virtual_machine_id = var.source_vm_id != null ? var.source_vm_id : (
    var.source_vm_name != null ? data.azurerm_virtual_machine.template_vm[0].id : null
  )
  
  tags = var.tags
}

# Create compute gallery image version from VM or managed image
resource "azurerm_shared_image_version" "vm_image_version" {
  count               = var.create_gallery_image_version ? 1 : 0
  name                = var.image_version
  gallery_name        = var.gallery_name
  image_name          = var.gallery_image_definition_name
  resource_group_name = var.resource_group_name
  location            = var.location
  
  # Use managed image if created, otherwise use source VM
  managed_image_id = var.create_managed_image ? azurerm_image.vm_image[0].id : (
    var.source_vm_id != null ? var.source_vm_id : (
      var.source_vm_name != null ? data.azurerm_virtual_machine.template_vm[0].id : null
    )
  )
  
  target_region {
    name                   = var.location
    regional_replica_count = var.replica_count
    storage_account_type   = var.storage_account_type
  }
  
  # Additional target regions
  dynamic "target_region" {
    for_each = var.additional_target_regions
    content {
      name                   = target_region.value.name
      regional_replica_count = target_region.value.replica_count
      storage_account_type   = target_region.value.storage_account_type
    }
  }
  
  tags = var.tags
}

# Output the created resources for use in other modules or workflows
locals {
  image_version_id = var.create_gallery_image_version ? azurerm_shared_image_version.vm_image_version[0].id : null
  managed_image_id = var.create_managed_image ? azurerm_image.vm_image[0].id : null
}
