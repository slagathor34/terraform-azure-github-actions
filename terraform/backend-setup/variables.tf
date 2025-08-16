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

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default = {
    Environment = "shared"
    ManagedBy   = "terraform"
    Purpose     = "terraform-state"
  }
}
