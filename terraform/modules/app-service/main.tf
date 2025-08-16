resource "azurerm_service_plan" "this" {
  name                = "${var.name}-plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_windows_web_app" "this" {
  count               = var.os_type == "Windows" ? 1 : 0
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id

  site_config {
    always_on = var.always_on
    
    dynamic "application_stack" {
      for_each = var.application_stack != null ? [var.application_stack] : []
      content {
        current_stack  = application_stack.value.current_stack
        dotnet_version = application_stack.value.dotnet_version
        node_version   = application_stack.value.node_version
        php_version    = application_stack.value.php_version
        python_version = application_stack.value.python_version
      }
    }
  }

  app_settings = var.app_settings
  tags         = var.tags
}

resource "azurerm_linux_web_app" "this" {
  count               = var.os_type == "Linux" ? 1 : 0
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id

  site_config {
    always_on = var.always_on
    
    dynamic "application_stack" {
      for_each = var.application_stack != null ? [var.application_stack] : []
      content {
        docker_image     = application_stack.value.docker_image
        docker_image_tag = application_stack.value.docker_image_tag
        dotnet_version   = application_stack.value.dotnet_version
        node_version     = application_stack.value.node_version
        php_version      = application_stack.value.php_version
        python_version   = application_stack.value.python_version
      }
    }
  }

  app_settings = var.app_settings
  tags         = var.tags
}
