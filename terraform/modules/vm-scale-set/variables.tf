variable "scale_set_name" {
  description = "Name of the VM Scale Set"
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

variable "vm_sku" {
  description = "SKU for the VM Scale Set instances"
  type        = string
  default     = "Standard_B2s"
}

variable "initial_instance_count" {
  description = "Initial number of VM instances"
  type        = number
  default     = 2
}

variable "min_instance_count" {
  description = "Minimum number of VM instances"
  type        = number
  default     = 1
}

variable "max_instance_count" {
  description = "Maximum number of VM instances"
  type        = number
  default     = 10
}

variable "admin_username" {
  description = "Admin username for the VMs"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "custom_image_id" {
  description = "ID of the custom image to use"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where VMs will be placed"
  type        = string
}

variable "gallery_id" {
  description = "ID of the compute gallery"
  type        = string
}

variable "os_disk_type" {
  description = "Type of OS disk"
  type        = string
  default     = "Premium_LRS"
}

variable "upgrade_mode" {
  description = "Upgrade mode for the scale set"
  type        = string
  default     = "Manual"
  
  validation {
    condition     = contains(["Automatic", "Manual", "Rolling"], var.upgrade_mode)
    error_message = "Upgrade mode must be Automatic, Manual, or Rolling."
  }
}

variable "health_probe_path" {
  description = "Path for the health probe"
  type        = string
  default     = "/"
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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
