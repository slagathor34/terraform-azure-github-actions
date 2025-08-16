resource "azurerm_shared_image_gallery" "main" {
  name                = var.gallery_name
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = var.description

  tags = var.tags
}

resource "azurerm_shared_image" "main" {
  name                = var.image_name
  gallery_name        = azurerm_shared_image_gallery.main.name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type
  hyper_v_generation  = var.hyper_v_generation

  identifier {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
  }

  tags = var.tags
}
