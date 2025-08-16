variable "resource_group_name" {
  description = "Name of the resource group containing the source VM"
  type        = string
}

variable "location" {
  description = "Azure region for the image resources"
  type        = string
  default     = "East US"
}

variable "source_vm_name" {
  description = "Name of the source VM to create image from"
  type        = string
}

variable "deallocate_vm" {
  description = "Whether to deallocate the source VM before creating image"
  type        = bool
  default     = true
}

variable "create_gallery_image_version" {
  description = "Whether to create a compute gallery image version"
  type        = bool
  default     = true
}

variable "gallery_name" {
  description = "Name of the compute gallery"
  type        = string
}

variable "gallery_image_definition_name" {
  description = "Name of the image definition in the compute gallery"
  type        = string
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
  default = {
    Environment = "image-creation"
    ManagedBy   = "terraform"
  }
}
