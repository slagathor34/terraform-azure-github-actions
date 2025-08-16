variable "resource_group_name" {
  description = "Name of the resource group containing the source VM"
  type        = string
}

variable "location" {
  description = "Azure region for the image resources"
  type        = string
}

variable "source_vm_name" {
  description = "Name of the source VM to create image from"
  type        = string
  default     = null
}

variable "source_vm_id" {
  description = "ID of the source VM to create image from (alternative to source_vm_name)"
  type        = string
  default     = null
}

variable "deallocate_vm" {
  description = "Whether to deallocate the source VM before creating image"
  type        = bool
  default     = true
}

variable "create_managed_image" {
  description = "Whether to create a managed image from the VM"
  type        = bool
  default     = false
}

variable "image_name" {
  description = "Name for the managed image (if creating managed image)"
  type        = string
  default     = null
}

variable "create_gallery_image_version" {
  description = "Whether to create a compute gallery image version"
  type        = bool
  default     = true
}

variable "gallery_name" {
  description = "Name of the compute gallery"
  type        = string
  default     = null
}

variable "gallery_image_definition_name" {
  description = "Name of the image definition in the compute gallery"
  type        = string
  default     = null
}

variable "image_version" {
  description = "Version number for the gallery image (e.g., 1.0.0)"
  type        = string
  default     = "1.0.0"
}

variable "replica_count" {
  description = "Number of replicas for the image version"
  type        = number
  default     = 1
}

variable "storage_account_type" {
  description = "Storage account type for the image replicas"
  type        = string
  default     = "Standard_LRS"
  
  validation {
    condition     = contains(["Standard_LRS", "Standard_ZRS", "Premium_LRS"], var.storage_account_type)
    error_message = "Storage account type must be Standard_LRS, Standard_ZRS, or Premium_LRS."
  }
}

variable "additional_target_regions" {
  description = "Additional target regions for image replication"
  type = list(object({
    name                   = string
    replica_count          = number
    storage_account_type   = string
  }))
  default = []
}

variable "tags" {
  description = "A mapping of tags to assign to the image resources"
  type        = map(string)
  default     = {}
}
