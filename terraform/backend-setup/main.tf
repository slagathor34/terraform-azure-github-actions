# ============================================================================
# TERRAFORM BACKEND SETUP
# ============================================================================
# This configuration creates the Azure infrastructure required for Terraform
# remote state storage. This should be run first, before any other Terraform
# configurations that use the remote backend.

terraform {
  required_version = ">= 1.7"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Generate a unique storage account name based on subscription ID
locals {
  # Create a deterministic but unique storage account name
  subscription_id_hash = substr(sha256(data.azurerm_client_config.current.subscription_id), 0, 16)
  storage_account_name = "tfstate${local.subscription_id_hash}"
}

# Get current Azure configuration
data "azurerm_client_config" "current" {}

# Create the backend infrastructure
module "terraform_backend" {
  source = "../modules/terraform-backend"
  
  resource_group_name    = var.resource_group_name
  location              = var.location
  storage_account_name  = local.storage_account_name
  
  tags = var.tags
}
