output "backend_configuration" {
  description = "Backend configuration for use in other Terraform configurations"
  value = module.terraform_backend.terraform_backend_config
}

output "resource_group_name" {
  description = "Name of the created resource group"
  value = module.terraform_backend.resource_group_name
}

output "storage_account_name" {
  description = "Name of the created storage account"
  value = module.terraform_backend.storage_account_name
}

output "setup_instructions" {
  description = "Instructions for using the created backend"
  value = <<-EOT
    
    Backend created successfully!
    
    To use this backend in your Terraform configurations, add the following to your terraform block:
    
    terraform {
      backend "azurerm" {
        resource_group_name  = "${module.terraform_backend.resource_group_name}"
        storage_account_name = "${module.terraform_backend.storage_account_name}"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"  # Change this for different environments
      }
    }
    
    For different environments or projects, use different key names:
    - dev environment: key = "dev/terraform.tfstate"
    - prod environment: key = "prod/terraform.tfstate" 
    - image-creation: key = "image-creation/terraform.tfstate"
    - scaleset-deploy: key = "scaleset-deploy/terraform.tfstate"
    
  EOT
}
