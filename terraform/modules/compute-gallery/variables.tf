variable "gallery_name" {
  description = "Name of the shared image gallery"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "description" {
  description = "Description of the shared image gallery"
  type        = string
  default     = "Shared image gallery for custom VM images"
}

variable "image_name" {
  description = "Name of the shared image"
  type        = string
}

variable "os_type" {
  description = "Operating system type"
  type        = string
  default     = "Linux"
  
  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "OS type must be either Linux or Windows."
  }
}

variable "hyper_v_generation" {
  description = "Hyper-V generation"
  type        = string
  default     = "V2"
  
  validation {
    condition     = contains(["V1", "V2"], var.hyper_v_generation)
    error_message = "Hyper-V generation must be either V1 or V2."
  }
}

variable "image_publisher" {
  description = "Image publisher"
  type        = string
  default     = "mycompany"
}

variable "image_offer" {
  description = "Image offer"
  type        = string
  default     = "myapp"
}

variable "image_sku" {
  description = "Image SKU"
  type        = string
  default     = "1.0"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
