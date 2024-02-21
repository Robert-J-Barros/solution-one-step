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


data "azurerm_resource_group" "ResourceGroupSolutionOneFase2" {
  name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "AKSSolutionOneFase2" {
  location            = data.azurerm_resource_group.ResourceGroupSolutionOneFase2.location
  resource_group_name = data.azurerm_resource_group.ResourceGroupSolutionOneFase2.name
  node_resource_group = "${data.azurerm_resource_group.ResourceGroupSolutionOneFase2.name}-aks"
  name                = "${data.azurerm_resource_group.ResourceGroupSolutionOneFase2.name}-name"
  dns_prefix          = "aks-solution-one-dns"

  default_node_pool {
    name           = "default"
    node_count     = "2"
    vm_size        = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }

}


