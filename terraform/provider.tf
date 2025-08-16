terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  # Backend configuration for remote state
  # This will be configured in GitHub Actions
  backend "azurerm" {
    # These values will be set via environment variables or command line
    # resource_group_name  = "tfstate-rg"
    # storage_account_name = "tfstateXXXXXX"
    # container_name       = "tfstate"
    # key                  = "terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
