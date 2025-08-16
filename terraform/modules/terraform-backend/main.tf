# ============================================================================
# TERRAFORM BACKEND INFRASTRUCTURE
# ============================================================================
# This module creates the Azure resources needed for Terraform remote state
# storage, eliminating the need for Azure CLI commands in CI/CD pipelines.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Resource Group for Terraform State
resource "azurerm_resource_group" "tfstate" {
  name     = var.resource_group_name
  location = var.location
  
  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Purpose   = "tfstate"
  })
}

# Storage Account for Terraform State
resource "azurerm_storage_account" "tfstate" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # Security settings
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true
  
  # Network access rules
  public_network_access_enabled = true
  
  # Blob properties for versioning and soft delete
  blob_properties {
    versioning_enabled = true
    
    delete_retention_policy {
      days = 7
    }
    
    container_delete_retention_policy {
      days = 7
    }
  }
  
  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Purpose   = "tfstate"
  })
}

# Storage Container for Terraform State
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
