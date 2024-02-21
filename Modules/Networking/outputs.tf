output "resource_group_id" {
  value = azurerm_resource_group.ResourceGroupSolutionOneFase2.id
}

output "virtual_network_id" {
  value = azurerm_virtual_network.VnetSolutionOneFase.id
}

output "subnet_id" {
  value = azurerm_subnet.SubnetPubSolutionOneFase2.id
}
