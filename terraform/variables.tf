variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "tfazure"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the resource group (optional - will be generated if not provided)"
  type        = string
  default     = null
}

variable "storage_account_tier" {
  description = "Defines the Tier to use for the storage account"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "The storage_account_tier must be either Standard or Premium."
  }
}

variable "storage_replication_type" {
  description = "Defines the type of replication to use for the storage account"
  type        = string
  default     = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_replication_type)
    error_message = "The storage_replication_type must be one of LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "terraform-azure"
    ManagedBy   = "terraform"
  }
}
