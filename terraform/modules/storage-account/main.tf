resource "random_string" "suffix" {
  count   = var.name_suffix == null ? 1 : 0
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_storage_account" "this" {
  name                     = var.name_suffix != null ? "${var.name}${var.name_suffix}" : "${var.name}${random_string.suffix[0].result}"
  resource_group_name      = var.resource_group_name
  location                = var.location
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  
  # Security settings
  enable_https_traffic_only      = var.enable_https_traffic_only
  min_tls_version               = var.min_tls_version
  allow_nested_items_to_be_public = var.allow_public_access

  # Network access
  dynamic "network_rules" {
    for_each = var.network_rules != null ? [var.network_rules] : []
    content {
      default_action             = network_rules.value.default_action
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids
      bypass                     = network_rules.value.bypass
    }
  }

  tags = var.tags
}
