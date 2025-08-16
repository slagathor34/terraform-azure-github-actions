output "managed_image_id" {
  description = "ID of the created managed image (if created)"
  value       = local.managed_image_id
}

output "gallery_image_version_id" {
  description = "ID of the created gallery image version (if created)"
  value       = local.image_version_id
}

output "gallery_image_version_name" {
  description = "Name/version of the created gallery image version"
  value       = var.create_gallery_image_version ? var.image_version : null
}

output "source_vm_id" {
  description = "ID of the source VM used for image creation"
  value       = var.source_vm_id != null ? var.source_vm_id : (
    var.source_vm_name != null && length(data.azurerm_virtual_machine.template_vm) > 0 ? 
    data.azurerm_virtual_machine.template_vm[0].id : null
  )
}

output "image_creation_summary" {
  description = "Summary of the image creation process"
  value = {
    source_vm_name           = var.source_vm_name
    source_vm_id            = var.source_vm_id
    managed_image_created   = var.create_managed_image
    managed_image_id        = local.managed_image_id
    gallery_version_created = var.create_gallery_image_version
    gallery_version_id      = local.image_version_id
    gallery_version_name    = var.image_version
    replica_count          = var.replica_count
    target_regions         = length(var.additional_target_regions) + 1
  }
}
