variable "resource_group_name" {
  description = "Name of the resource group for the scale set deployment"
  type        = string
}

variable "location" {
  description = "Azure region for the scale set resources"
  type        = string
  default     = "East US"
}

variable "create_resource_group" {
  description = "Whether to create a new resource group"
  type        = bool
  default     = false
}

variable "use_custom_image" {
  description = "Whether to use a custom image from compute gallery"
  type        = bool
  default     = true
}

variable "custom_image_version" {
  description = "Version of the custom image to use (e.g., 1.0.0)"
  type        = string
  default     = "1.0.0"
}

variable "gallery_name" {
  description = "Name of the compute gallery containing the custom image"
  type        = string
  default     = "imageGallery"
}

variable "gallery_image_definition_name" {
  description = "Name of the image definition in the compute gallery"
  type        = string
  default     = "ubuntu-web-server"
}

variable "gallery_resource_group_name" {
  description = "Name of the resource group containing the compute gallery"
  type        = string
  default     = "image-creation-rg"
}

variable "use_existing_vnet" {
  description = "Whether to use an existing virtual network"
  type        = bool
  default     = true
}

variable "existing_vnet_name" {
  description = "Name of the existing virtual network"
  type        = string
  default     = null
}

variable "existing_vnet_resource_group" {
  description = "Resource group containing the existing virtual network"
  type        = string
  default     = null
}

variable "scaleset_subnet_name" {
  description = "Name of the subnet for the scale set"
  type        = string
  default     = "scaleset-subnet"
}

variable "subnet_id" {
  description = "ID of the subnet to deploy scale set to (if not using existing vnet)"
  type        = string
  default     = null
}

variable "vmss_name" {
  description = "Name of the VM Scale Set"
  type        = string
}

variable "vm_sku" {
  description = "Size of the VM instances in the scale set"
  type        = string
  default     = "Standard_B2s"
}

variable "initial_instances" {
  description = "Initial number of VM instances"
  type        = number
  default     = 2
}

variable "min_instances" {
  description = "Minimum number of VM instances"
  type        = number
  default     = 1
}

variable "max_instances" {
  description = "Maximum number of VM instances"
  type        = number
  default     = 10
}

variable "scale_out_cpu_threshold" {
  description = "CPU threshold for scaling out"
  type        = number
  default     = 75
}

variable "scale_in_cpu_threshold" {
  description = "CPU threshold for scaling in"
  type        = number
  default     = 25
}

variable "admin_username" {
  description = "Admin username for the VM instances"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for the VM instances"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default = {
    Environment = "scaleset-deploy"
    ManagedBy   = "terraform"
  }
}
