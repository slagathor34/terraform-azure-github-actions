variable "name" {
  description = "Base name of the storage account (will be suffixed)"
  type        = string
}

variable "name_suffix" {
  description = "Optional suffix for storage account name. If not provided, random suffix will be generated"
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where the storage account will be created"
  type        = string
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "The account_tier must be either Standard or Premium."
  }
}

variable "replication_type" {
  description = "Defines the type of replication to use for this storage account"
  type        = string
  default     = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.replication_type)
    error_message = "The replication_type must be one of LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "enable_https_traffic_only" {
  description = "Boolean flag which forces HTTPS traffic only"
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account"
  type        = string
  default     = "TLS1_2"
}

variable "allow_public_access" {
  description = "Allow or disallow nested items within this Account to opt into being public"
  type        = bool
  default     = false
}

variable "network_rules" {
  description = "Network rules for the storage account"
  type = object({
    default_action             = string
    ip_rules                   = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
    bypass                     = optional(list(string))
  })
  default = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
