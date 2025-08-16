# Random password for VM admin
resource "random_password" "vm_password" {
  length  = 16
  special = true
}

# User-assigned managed identity for the VM
resource "azurerm_user_assigned_identity" "vm_identity" {
  name                = "${var.vm_name}-identity"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
}

# Public IP for the VM (for initial setup)
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "${var.vm_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

# Network interface for the VM
resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }

  tags = var.tags
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username

  # Disable password authentication and use SSH keys
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }

  source_image_reference {
    publisher = var.source_image_publisher
    offer     = var.source_image_offer
    sku       = var.source_image_sku
    version   = var.source_image_version
  }

  # Assign the user-assigned managed identity
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.vm_identity.id]
  }

  tags = var.tags
}

# Store the admin password in Key Vault if provided
resource "azurerm_key_vault_secret" "vm_password" {
  count        = var.key_vault_id != null ? 1 : 0
  name         = "${var.vm_name}-admin-password"
  value        = random_password.vm_password.result
  key_vault_id = var.key_vault_id

  tags = var.tags
}

# Custom script extension to install dependencies for Ansible
resource "azurerm_virtual_machine_extension" "custom_script" {
  name                 = "${var.vm_name}-setup"
  virtual_machine_id   = azurerm_linux_virtual_machine.main.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = jsonencode({
    commandToExecute = <<-EOT
      #!/bin/bash
      apt-get update
      apt-get install -y python3 python3-pip
      pip3 install ansible
      # Create ansible user for automation
      useradd -m -s /bin/bash ansible
      echo 'ansible ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ansible
      # Setup SSH key for ansible user
      mkdir -p /home/ansible/.ssh
      chmod 700 /home/ansible/.ssh
      chown ansible:ansible /home/ansible/.ssh
    EOT
  })

  tags = var.tags
}
