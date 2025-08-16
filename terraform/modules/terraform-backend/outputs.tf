output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.tfstate.name
}

output "resource_group_id" {
  description = "ID of the created resource group"
  value       = azurerm_resource_group.tfstate.id
}

output "storage_account_name" {
  description = "Name of the created storage account"
  value       = azurerm_storage_account.tfstate.name
}

output "storage_account_id" {
  description = "ID of the created storage account"
  value       = azurerm_storage_account.tfstate.id
}

output "storage_account_primary_key" {
  description = "Primary access key for the storage account"
  value       = azurerm_storage_account.tfstate.primary_access_key
  sensitive   = true
}

output "storage_container_name" {
  description = "Name of the created storage container"
  value       = azurerm_storage_container.tfstate.name
}

output "terraform_backend_config" {
  description = "Backend configuration for Terraform"
  value = {
    resource_group_name  = azurerm_resource_group.tfstate.name
    storage_account_name = azurerm_storage_account.tfstate.name
    container_name       = azurerm_storage_container.tfstate.name
    key                  = "terraform.tfstate"
  }
}
