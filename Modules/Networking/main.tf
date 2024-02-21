terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.92.0"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "ResourceGroupSolutionOneFase2" {
  name     = var.resource_group_name
  location = "East US"
}

resource "azurerm_virtual_network" "VnetSolutionOneFase" {
  name                = var.vnet_name
  location            = azurerm_resource_group.ResourceGroupSolutionOneFase2.location
  resource_group_name = azurerm_resource_group.ResourceGroupSolutionOneFase2.name
  address_space       = ["10.1.0.0/16"]
  dns_servers         = ["10.1.0.4", "10.1.0.5"]
}
resource "azurerm_subnet" "SubnetPubSolutionOneFase2" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.ResourceGroupSolutionOneFase2.name
  virtual_network_name = azurerm_virtual_network.VnetSolutionOneFase.name
  address_prefixes     = ["10.1.0.0/24"]
}



