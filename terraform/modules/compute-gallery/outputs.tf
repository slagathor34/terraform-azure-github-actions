output "gallery_id" {
  description = "ID of the shared image gallery"
  value       = azurerm_shared_image_gallery.main.id
}

output "gallery_name" {
  description = "Name of the shared image gallery"
  value       = azurerm_shared_image_gallery.main.name
}

output "image_id" {
  description = "ID of the shared image"
  value       = azurerm_shared_image.main.id
}

output "image_name" {
  description = "Name of the shared image"
  value       = azurerm_shared_image.main.name
}
