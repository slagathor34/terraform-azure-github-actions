output "resource_group_name" {
  description = "The name of the resource group"
  value       = module.resource_group.name
}

output "resource_group_location" {
  description = "The location of the resource group"
  value       = module.resource_group.location
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = module.storage_account.name
}

output "storage_account_primary_blob_endpoint" {
  description = "The endpoint URL for blob storage"
  value       = module.storage_account.primary_blob_endpoint
}esource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "storage_account_name" {
  description = "Name of the created storage account"
  value       = azurerm_storage_account.main.name
}
