variable "vm_name" {
  description = "Name of the virtual machine"
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

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where the VM will be placed"
  type        = string
}

variable "os_disk_type" {
  description = "Type of OS disk"
  type        = string
  default     = "Premium_LRS"
}

variable "source_image_publisher" {
  description = "Publisher of the source image"
  type        = string
  default     = "Canonical"
}

variable "source_image_offer" {
  description = "Offer of the source image"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "source_image_sku" {
  description = "SKU of the source image"
  type        = string
  default     = "22_04-lts-gen2"
}

variable "source_image_version" {
  description = "Version of the source image"
  type        = string
  default     = "latest"
}

variable "key_vault_id" {
  description = "ID of the Key Vault to store secrets (optional)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
