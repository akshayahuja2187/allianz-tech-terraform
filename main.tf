provider "azurerm" {
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
  tenant_id = var.tenant_id
}

resource "azurerm_resource_group" "jenkins" {
  name = "jenkins-rg"
  location = var.location
}

resource "azurerm_virtual_network" "jenkins" {
  name = "jenkins-vnet"
  resource_group_name = azurerm_resource_group.jenkins.name
  location = var.location
  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "jenkins" {
  name = "jenkins-subnet"
  resource_group_name = azurerm_resource_group.jenkins.name
  virtual_network_name = azurerm_virtual_network.jenkins.name
  address_prefix = "10.0.0.0/24"
}

resource "azurerm_network_interface" "jenkins" {
  name = "jenkins-nic"
  resource_group_name = azurerm_resource_group.jenkins.name
  virtual_network_name = azurerm_virtual_network.jenkins.name
  subnet_name = azurerm_subnet.jenkins.name
  ip_configuration {
    name = "jenkins-ip-config"
    public_ip_address_id = azurerm_public_ip.jenkins.id
  }
}

resource "azurerm_public_ip" "jenkins" {
  name = "jenkins-public-ip"
  resource_group_name = azurerm_resource_group.jenkins.name
  location = var.location
  sku = "Standard"
}

resource "azurerm_virtual_machine" "jenkins" {
  name = "jenkins"
  resource_group_name = azurerm_resource_group.jenkins.name
  location = var.location
  size = "Standard_B1ls"
  network_interface_ids = [azurerm_network_interface.jenkins.id]
  os_disk {
    name = "jenkins-os-disk"
    caching = "ReadWrite"
    os_type = "Linux"
    disk_size_gb = 30
  }
  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }
}

resource "azurerm_jenkins_server" "jenkins" {
  name = "jenkins"
  resource_group_name = azurerm_resource_group.jenkins.name
  virtual_machine_id = azurerm_virtual_machine.jenkins.id
  admin_username = "admin"
  admin_password = var.jenkins_password
}