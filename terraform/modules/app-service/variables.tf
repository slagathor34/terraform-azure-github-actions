variable "name" {
  description = "Name of the app service"
  type        = string
}

variable "location" {
  description = "Azure region for the app service"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "os_type" {
  description = "Operating system type (Windows or Linux)"
  type        = string
  default     = "Windows"
  validation {
    condition     = contains(["Windows", "Linux"], var.os_type)
    error_message = "OS type must be either 'Windows' or 'Linux'."
  }
}

variable "sku_name" {
  description = "SKU name for the app service plan"
  type        = string
  default     = "B1"
}

variable "always_on" {
  description = "Should the app service always be on"
  type        = bool
  default     = false
}

variable "application_stack" {
  description = "Application stack configuration"
  type = object({
    current_stack    = optional(string)
    dotnet_version   = optional(string)
    node_version     = optional(string)
    php_version      = optional(string)
    python_version   = optional(string)
    docker_image     = optional(string)
    docker_image_tag = optional(string)
  })
  default = null
}

variable "app_settings" {
  description = "App settings for the app service"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
