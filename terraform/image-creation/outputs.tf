output "gallery_image_version_id" {
  description = "ID of the created gallery image version"
  value       = module.vm_image_operations.gallery_image_version_id
}

output "gallery_image_version_name" {
  description = "Name/version of the created gallery image version"
  value       = module.vm_image_operations.gallery_image_version_name
}

output "source_vm_id" {
  description = "ID of the source VM used for image creation"
  value       = module.vm_image_operations.source_vm_id
}

output "image_creation_summary" {
  description = "Summary of the image creation process"
  value       = module.vm_image_operations.image_creation_summary
}
