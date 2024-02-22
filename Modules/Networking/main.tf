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



resource "azurerm_resource_group" "ResourceGroupSolutionOneFase2" {
  name     = var.resource_group_name
  location = "East US"
}

resource "azurerm_virtual_network" "VnetSolutionOneFase" {
  name                = var.vnet_name
  location            = azurerm_resource_group.ResourceGroupSolutionOneFase2.location
  resource_group_name = azurerm_resource_group.ResourceGroupSolutionOneFase2.name
  address_space       = ["172.31.0.0/16"]
  dns_servers         = ["172.31.0.4", "172.31.0.5"]
}
resource "azurerm_subnet" "SubnetPubSolutionOneFase2" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.ResourceGroupSolutionOneFase2.name
  virtual_network_name = azurerm_virtual_network.VnetSolutionOneFase.name
  address_prefixes     = ["172.31.0.0/24"]
}
resource "azurerm_subnet" "SubnetPubAppGtwSolutionOneFase2" {
  name                 = var.subnet_name_appgtw
  resource_group_name  = azurerm_resource_group.ResourceGroupSolutionOneFase2.name
  virtual_network_name = azurerm_virtual_network.VnetSolutionOneFase.name
  address_prefixes     = ["172.31.1.0/24"]
}

resource "azurerm_public_ip" "IpNatGatewaySolutionOneFase2" {
  name                = var.nat_ip
  location            = azurerm_resource_group.ResourceGroupSolutionOneFase2.location
  resource_group_name = azurerm_resource_group.ResourceGroupSolutionOneFase2.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "NatGatewaySolutionOneFase2" {
  name                = var.nat_name
  location            = azurerm_resource_group.ResourceGroupSolutionOneFase2.location
  resource_group_name = azurerm_resource_group.ResourceGroupSolutionOneFase2.name
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "AssociationNatIp" {
  nat_gateway_id       = azurerm_nat_gateway.NatGatewaySolutionOneFase2.id
  public_ip_address_id = azurerm_public_ip.IpNatGatewaySolutionOneFase2.id
}

resource "azurerm_subnet_nat_gateway_association" "AssociationSubnetNat" {
  subnet_id           = azurerm_subnet.SubnetPubSolutionOneFase2.id
  nat_gateway_id      = azurerm_nat_gateway.NatGatewaySolutionOneFase2.id
}

resource "azurerm_route_table" "NatRouteTableSolutionOne" {
  name                = "natroutetable"
  resource_group_name = azurerm_resource_group.ResourceGroupSolutionOneFase2.name
  location            = azurerm_resource_group.ResourceGroupSolutionOneFase2.location

  route {
    name                   = "natroute"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "40.71.211.21"
  }
}

# Tabela de rota para a VNet do NAT
resource "azurerm_route_table" "VnetToNATRouteSolutionOne" {
  name                = "vnetroutetable"
  resource_group_name = azurerm_resource_group.ResourceGroupSolutionOneFase2.name
  location            = azurerm_resource_group.ResourceGroupSolutionOneFase2.location

  route {
    name           = "internetroute"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualNetworkGateway"
  }
}

resource "azurerm_subnet_route_table_association" "AssiciationNatRouteTableSolutionOne" {
  subnet_id      = azurerm_subnet.SubnetPubSolutionOneFase2.id
  route_table_id = azurerm_route_table.NatRouteTableSolutionOne.id
}
