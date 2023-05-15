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
  subnet_id           = azurerm_subnet.jenkins.id
  ip_configuration {
    name                          = "jenkins-ip-config"
    public_ip_address_id          = azurerm_public_ip.jenkins.id
    private_ip_address_allocation = "Dynamic"
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
  size                  = "Standard_B1ls"
  network_interface_ids = [azurerm_network_interface.jenkins.id]
  os_disk {
    name         = "jenkins-os-disk"
    caching      = "ReadWrite"
    os_type      = "Linux"
    disk_size_gb = 30
  }
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  custom_script_source_content = <<EOF
#!/bin/bash

# Install Jenkins
sudo apt-get update
sudo apt-get install -y jenkins

# Start Jenkins
sudo service jenkins start

# Open Jenkins in a web browser
echo "http://$(hostname):8080" >> /etc/motd
EOF
}