variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vm_subnet_cidr" {
  description = "CIDR block for VM subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "scale_set_subnet_cidr" {
  description = "CIDR block for Scale Set subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_endpoint_subnet_cidr" {
  description = "CIDR block for Private Endpoint subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "admin_source_ip" {
  description = "Source IP address for admin access"
  type        = string
  default     = "*"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
