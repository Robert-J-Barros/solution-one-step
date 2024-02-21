terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.92.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "ResourceGroupSolutionOneFase2"
    storage_account_name = "solutiononerometestatetf"
    container_name       = "tfstate"
    key                  = "sl-terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}