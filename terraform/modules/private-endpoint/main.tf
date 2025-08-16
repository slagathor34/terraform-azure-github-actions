# Private DNS Zone for the storage account
resource "azurerm_private_dns_zone" "storage" {
  count               = var.create_dns_zone ? 1 : 0
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Link the private DNS zone to the virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "storage" {
  count                 = var.create_dns_zone ? 1 : 0
  name                  = "${var.storage_account_name}-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.storage[0].name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = false

  tags = var.tags
}

# Private endpoint for the storage account
resource "azurerm_private_endpoint" "storage" {
  name                = "${var.storage_account_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.storage_account_name}-psc"
    private_connection_resource_id = var.storage_account_id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  dynamic "private_dns_zone_group" {
    for_each = var.create_dns_zone ? [1] : []
    content {
      name                 = "storage-dns-zone-group"
      private_dns_zone_ids = [azurerm_private_dns_zone.storage[0].id]
    }
  }

  tags = var.tags
}

# Private DNS Zone for Key Vault (if provided)
resource "azurerm_private_dns_zone" "keyvault" {
  count               = var.key_vault_id != null && var.create_dns_zone ? 1 : 0
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Link the Key Vault private DNS zone to the virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  count                 = var.key_vault_id != null && var.create_dns_zone ? 1 : 0
  name                  = "keyvault-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault[0].name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = false

  tags = var.tags
}

# Private endpoint for Key Vault (if provided)
resource "azurerm_private_endpoint" "keyvault" {
  count               = var.key_vault_id != null ? 1 : 0
  name                = "keyvault-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "keyvault-psc"
    private_connection_resource_id = var.key_vault_id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  dynamic "private_dns_zone_group" {
    for_each = var.key_vault_id != null && var.create_dns_zone ? [1] : []
    content {
      name                 = "keyvault-dns-zone-group"
      private_dns_zone_ids = [azurerm_private_dns_zone.keyvault[0].id]
    }
  }

  tags = var.tags
}
