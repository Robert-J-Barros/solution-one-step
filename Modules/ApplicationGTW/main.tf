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
    container_name       = "appgt-tfstate"
    key                  = "prod.terraform.tfstate"
}
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "ResourceGroupSolutionOneFase2" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "VnetSolutionOneFase" {
    name = var.vnet_name
    resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "SubnetPubAppGtwSolutionOneFase2" {
    name = var.subnet_name
    resource_group_name = var.resource_group_name
    virtual_network_name = data.azurerm_virtual_network.VnetSolutionOneFase.name
}
resource "azurerm_public_ip" "PublicIpGtwApplication" {
  name                         = "PubliGtw"
  location                     = data.azurerm_resource_group.ResourceGroupSolutionOneFase2.location
  resource_group_name          = data.azurerm_resource_group.ResourceGroupSolutionOneFase2.name
  allocation_method            = "Static"
  sku                          = "Standard"

}

resource "azurerm_application_gateway" "network" {
  name                = "ApplicationGatewaySolutionOne2"
  resource_group_name = "ResourceGroupSolutionOneFase2"
  location            = "eastus"

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayFrontendIP"
    subnet_id = data.azurerm_subnet.SubnetPubAppGtwSolutionOneFase2.id
    }

  frontend_ip_configuration {
    name                 = "appGatewayFrontendIP"
    private_ip_address   = "Dynamic"
    public_ip_address_id = azurerm_public_ip.PublicIpGtwApplication.id
  }

  frontend_port {
    name = "appGatewayFrontendPort"
    port = 80
  }

  backend_address_pool {
    name = "appGatewayBackendPool"
  }

  backend_http_settings {
    name                  = "appGatewayBackendHttpSettings"
    port                  = 80
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
    request_timeout       = 30
  }

  http_listener {
    name                           = "appGatewayHttpListener"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    frontend_port_name             = "appGatewayFrontendPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "appGatewayHttpListener"
    backend_address_pool_name  = "appGatewayBackendPool"
    backend_http_settings_name = "appGatewayBackendHttpSettings"
    priority		       = 100
  }
}

