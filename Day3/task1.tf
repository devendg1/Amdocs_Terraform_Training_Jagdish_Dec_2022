# Terraform block

terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.33.0"
    }
  }
}

# Provider block

provider "azurerm" {
    features {}
      subscription_id = "d7caf72f-c744-4da6-a75b-9bcf64f005fb"
}

# Resource block

resource "azurerm_resource_group" "buildCluster" {
        name = "prm_fqc"
        location = "Central India"
      tags = {
        "Team" = "Infra"
        "Owner" = "Devendra"
      }
}

resource "azurerm_linux_virtual_machine" "buildCluster" {
    name                            = "batch-vm-01"
    resource_group_name             = azurerm_resource_group.buildCluster.name
    location                        = azurerm_resource_group.buildCluster.location
    size                            = "Standard_F2"
    admin_username                  = "cloud"
    admin_password                  = "Password1234!"
    disable_password_authentication = false

network_interface_ids = [
    azurerm_network_interface.buildCluster.id,
  ]
    os_disk {
    caching                         = "ReadWrite"
    storage_account_type            = "Standard_LRS"
  }

  source_image_reference {
    publisher                       = "OpenLogic"
    offer                           = "CentOS"
    sku                             = "7.5"
    version                         = "latest"
  }
}

resource "azurerm_virtual_network" "buildCluster" {
  name                = "batch-vnet-01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.buildCluster.location
  resource_group_name = azurerm_resource_group.buildCluster.name
}

resource "azurerm_subnet" "buildCluster" {
  name                 = "batch-subnet-01"
  resource_group_name  = azurerm_resource_group.buildCluster.name
  virtual_network_name = azurerm_virtual_network.buildCluster.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "buildCluster" {
  name                = "batch-nic-01"
  location            = azurerm_resource_group.buildCluster.location
  resource_group_name = azurerm_resource_group.buildCluster.name

  ip_configuration {
    name                          = "batch-nic-01"
    subnet_id                     = azurerm_subnet.buildCluster.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id 	  = azurerm_public_ip.buildCluster.id 
  }
}

resource "azurerm_public_ip" "buildCluster" {
  name                = "batch-ip-public"
  resource_group_name = azurerm_resource_group.buildCluster.name
  location            = azurerm_resource_group.buildCluster.location
  allocation_method   = "Static"

  tags = {
    "server_name" = "batch-vm-01"
  }
}
