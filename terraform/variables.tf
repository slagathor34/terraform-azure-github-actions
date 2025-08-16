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
  description = "Name of the resource group"
  type        = string
  default     = null
}

variable "app_service_sku" {
  description = "The SKU for the App Service Plan"
  type        = string
  default     = "F1"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "terraform-azure"
    ManagedBy   = "terraform"
  }
}
