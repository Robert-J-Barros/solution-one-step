output "resource_group_id" {
  value = data.azurerm_resource_group.ResourceGroupSolutionOneFase2.id
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.AKSSolutionOneFase2.name
}

output "cluster_location" {
  value = azurerm_kubernetes_cluster.AKSSolutionOneFase2.location
}

output "node_resource_group" {
  value = azurerm_kubernetes_cluster.AKSSolutionOneFase2.node_resource_group
}

