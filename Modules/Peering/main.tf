
data "azurerm_resource_group" "ResourceGroupSolutionOneFase2" {
  name = var.resource_group_name
}
data "azurerm_virtual_network" "VnetSolutionOneFase" {
  name                = var.vnet_application_gateway
  resource_group_name = var.resource_group_name
}
data "azurerm_public_ip" "IpNatGatewaySolutionOneFase2" {
  name                = var.public_ip_nat_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network_peering" "peering_nat_to_aks" {
  name                         = "${data.azurerm_virtual_network.ResourceGroupSolutionOneFase2.resource_group_name}-nat"
  resource_group_name          = data.azurerm_virtual_network.ResourceGroupSolutionOneFase2.resource_group_name
  virtual_network_name         = var.peering_aks_name
  remote_virtual_network_id    = var.peering_aks_id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "peering_aks_to_nat" {
  name                         = "${data.azurerm_virtual_network.ResourceGroupSolutionOneFase2.resource_group_name}-aks"
  resource_group_name          = data.azurerm_virtual_network.ResourceGroupSolutionOneFase2.resource_group_name
  virtual_network_name         = var.peering_nat_name
  remote_virtual_network_id    = var.peering_nat_id
  allow_virtual_network_access = true
}


resource "azurerm_route_table" "route_table_aks" {
  name                = "route-table-${data.azurerm_virtual_network.ResourceGroupSolutionOneFase2.name}"
  location            = data.azurerm_virtual_network.ResourceGroupSolutionOneFase2.location
  resource_group_name = data.azurerm_virtual_network.ResourceGroupSolutionOneFase2.name

  route {
    name                = "route-to-internet"
    address_prefix      = "0.0.0.0/0"
    next_hop_type       = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_subnet.subnet_nat.private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "route_table_association_aks" {
  subnet_id      = azurerm_subnet.subnet_aks.id
  route_table_id = azurerm_route_table.route_table_aks.id
}
