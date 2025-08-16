output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "storage_account_name" {
  description = "Name of the created storage account"
  value       = azurerm_storage_account.main.name
}

output "app_service_name" {
  description = "Name of the created app service"
  value       = azurerm_linux_web_app.main.name
}

output "app_service_url" {
  description = "URL of the created app service"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "app_service_plan_name" {
  description = "Name of the created app service plan"
  value       = azurerm_service_plan.main.name
}

output "application_insights_name" {
  description = "Name of the created Application Insights"
  value       = azurerm_application_insights.main.name
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key for Application Insights"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Connection string for Application Insights"
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}
