resource "azurerm_resource_group" "jenkins" {
  name     = "jenkins-rg"
  location = var.location
}

resource "azurerm_virtual_network" "jenkins" {
  name                = "jenkins-vnet"
  resource_group_name = azurerm_resource_group.jenkins.name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "jenkins" {
  name                 = "jenkins-subnet"
  resource_group_name  = azurerm_resource_group.jenkins.name
  virtual_network_name = azurerm_virtual_network.jenkins.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "jenkins" {
  name                = "jenkins-nic"
  resource_group_name = azurerm_resource_group.jenkins.name
  location            = var.location
  ip_configuration {
    name                          = "jenkins-ip-config"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jenkins.id
    subnet_id                     = azurerm_subnet.jenkins.id
  }
}

resource "azurerm_public_ip" "jenkins" {
  name                = "jenkins-public-ip"
  resource_group_name = azurerm_resource_group.jenkins.name
  location            = var.location
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_virtual_machine" "jenkins" {
  name                  = "jenkins"
  resource_group_name   = azurerm_resource_group.jenkins.name
  location              = var.location
  vm_size               = "Standard_B1ls"
  network_interface_ids = [azurerm_network_interface.jenkins.id]
  storage_os_disk {
    name          = "jenkins-os-disk"
    caching       = "ReadWrite"
    os_type       = "Linux"
    disk_size_gb  = 30
    create_option = "FromImage"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  os_profile {
    computer_name  = "my-jenkins-vm"
    admin_username = "akjenkinsadmin"
    admin_password = "akjenkinsadmin"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

