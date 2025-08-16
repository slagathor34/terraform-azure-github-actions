output "scale_set_id" {
  description = "ID of the created VM Scale Set"
  value       = module.vm_scale_set.scale_set_id
}

output "scale_set_name" {
  description = "Name of the created VM Scale Set"
  value       = module.vm_scale_set.scale_set_name
}

output "load_balancer_id" {
  description = "ID of the load balancer"
  value       = module.vm_scale_set.load_balancer_id
}

output "load_balancer_frontend_ip" {
  description = "Frontend IP address of the load balancer"
  value       = module.vm_scale_set.load_balancer_frontend_ip
}

output "custom_image_id" {
  description = "ID of the custom image used (if any)"
  value       = local.custom_image_id
}

output "custom_image_version" {
  description = "Version of the custom image used"
  value       = var.use_custom_image ? var.custom_image_version : "Not using custom image"
}

output "deployment_summary" {
  description = "Summary of the scale set deployment"
  value = {
    resource_group_name   = local.resource_group_name
    location             = local.resource_group_location
    scale_set_name       = module.vm_scale_set.scale_set_name
    vm_sku               = var.vm_sku
    initial_instances    = var.initial_instances
    min_instances        = var.min_instances
    max_instances        = var.max_instances
    custom_image_used    = var.use_custom_image
    custom_image_id      = local.custom_image_id
    custom_image_version = var.custom_image_version
  }
}
