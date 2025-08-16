output "vm_id" {
  description = "ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.id
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.name
}

output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.vm_public_ip.ip_address
}

output "vm_private_ip" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.vm_nic.private_ip_address
}

output "vm_identity_principal_id" {
  description = "Principal ID of the VM's managed identity"
  value       = azurerm_user_assigned_identity.vm_identity.principal_id
}

output "vm_identity_id" {
  description = "ID of the VM's managed identity"
  value       = azurerm_user_assigned_identity.vm_identity.id
}

output "admin_password" {
  description = "Generated admin password for the VM"
  value       = random_password.vm_password.result
  sensitive   = true
}
