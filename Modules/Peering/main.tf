terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.92.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "myResourceGroup"
    storage_account_name = "solutiononetfstate"
    container_name       = "network-tfstate"
    key                  = "prod.terraform.tfstate"
}
}

provider "azurerm" {
  features {}
}

data "azurerm_subnet" "aks_subnet" {
  name                 = var.subnet_aks_name
  virtual_network_name = var.vnet_peering_aks_nat_name
  resource_group_name  = var.aks_resource_group_name
}
data "azurerm_virtual_network" "AKSVnet" {
  name                = var.vnet_peering_aks_nat_name
  resource_group_name = var.aks_resource_group_name
}

data "azurerm_virtual_network" "NATVnet" {
  name                = var.vnet_peering_nat_aks_name
  resource_group_name = var.nat_resource_group_name
}


resource "azurerm_virtual_network_peering" "PeeringNatToKksSolutionOne" {
  name                         = var.peering_nat_to_aks
  resource_group_name          = var.nat_resource_group_name
  virtual_network_name         = var.vnet_peering_nat_aks_name
  remote_virtual_network_id    = data.azurerm_virtual_network.AKSVnet.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "peering_aks_to_nat" {
  name                         = var.peering_aks_to_nat
  resource_group_name          = var.aks_resource_group_name
  virtual_network_name         = var.vnet_peering_aks_nat_name
  remote_virtual_network_id    = data.azurerm_virtual_network.NATVnet.id
  allow_virtual_network_access = true
}


resource "azurerm_route_table" "route_table_aks" {
  name                = var.route_table
  location            = var.route_table_region
  resource_group_name = var.aks_resource_group_name

  route {
    name                = "routetointernet"
    address_prefix      = "0.0.0.0/0"
    next_hop_type       = "VirtualAppliance"
    next_hop_in_ip_address = "172.31.0.0/24"
  }
}

resource "azurerm_subnet_route_table_association" "route_table_association_aks" {
  subnet_id      = data.azurerm_subnet.aks_subnet.id
  route_table_id = azurerm_route_table.route_table_aks.id
}

