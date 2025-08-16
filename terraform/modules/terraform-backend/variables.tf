variable "resource_group_name" {
  description = "Name of the resource group for Terraform state resources"
  type        = string
  default     = "tfstate-rg"
}

variable "location" {
  description = "Azure region for Terraform state resources"
  type        = string
  default     = "East US"
}

variable "storage_account_name" {
  description = "Name of the storage account for Terraform state (must be globally unique, 3-24 chars, lowercase alphanumeric)"
  type        = string
  
  validation {
    condition     = length(var.storage_account_name) >= 3 && length(var.storage_account_name) <= 24
    error_message = "Storage account name must be between 3 and 24 characters."
  }
  
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.storage_account_name))
    error_message = "Storage account name can only contain lowercase letters and numbers."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
