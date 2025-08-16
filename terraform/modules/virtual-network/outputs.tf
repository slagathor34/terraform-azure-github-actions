output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "vm_subnet_id" {
  description = "ID of the VM subnet"
  value       = azurerm_subnet.vm_subnet.id
}

output "scale_set_subnet_id" {
  description = "ID of the Scale Set subnet"
  value       = azurerm_subnet.scale_set_subnet.id
}

output "private_endpoint_subnet_id" {
  description = "ID of the Private Endpoint subnet"
  value       = azurerm_subnet.private_endpoint_subnet.id
}

output "vm_nsg_id" {
  description = "ID of the VM Network Security Group"
  value       = azurerm_network_security_group.vm_nsg.id
}

output "scale_set_nsg_id" {
  description = "ID of the Scale Set Network Security Group"
  value       = azurerm_network_security_group.scale_set_nsg.id
}
