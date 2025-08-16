output "app_service_plan_id" {
  description = "ID of the app service plan"
  value       = azurerm_service_plan.this.id
}

output "app_service_plan_name" {
  description = "Name of the app service plan"
  value       = azurerm_service_plan.this.name
}

output "windows_web_app_id" {
  description = "ID of the Windows web app"
  value       = var.os_type == "Windows" ? azurerm_windows_web_app.this[0].id : null
}

output "windows_web_app_name" {
  description = "Name of the Windows web app"
  value       = var.os_type == "Windows" ? azurerm_windows_web_app.this[0].name : null
}

output "windows_web_app_default_hostname" {
  description = "Default hostname of the Windows web app"
  value       = var.os_type == "Windows" ? azurerm_windows_web_app.this[0].default_hostname : null
}

output "linux_web_app_id" {
  description = "ID of the Linux web app"
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.this[0].id : null
}

output "linux_web_app_name" {
  description = "Name of the Linux web app"
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.this[0].name : null
}

output "linux_web_app_default_hostname" {
  description = "Default hostname of the Linux web app"
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.this[0].default_hostname : null
}
