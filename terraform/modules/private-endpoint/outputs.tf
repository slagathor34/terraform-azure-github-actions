output "storage_private_endpoint_id" {
  description = "ID of the storage account private endpoint"
  value       = azurerm_private_endpoint.storage.id
}

output "storage_private_endpoint_ip" {
  description = "Private IP address of the storage account private endpoint"
  value       = azurerm_private_endpoint.storage.private_service_connection[0].private_ip_address
}

output "keyvault_private_endpoint_id" {
  description = "ID of the Key Vault private endpoint"
  value       = var.key_vault_id != null ? azurerm_private_endpoint.keyvault[0].id : null
}

output "storage_dns_zone_id" {
  description = "ID of the storage private DNS zone"
  value       = var.create_dns_zone ? azurerm_private_dns_zone.storage[0].id : null
}

output "keyvault_dns_zone_id" {
  description = "ID of the Key Vault private DNS zone"
  value       = var.key_vault_id != null && var.create_dns_zone ? azurerm_private_dns_zone.keyvault[0].id : null
}
