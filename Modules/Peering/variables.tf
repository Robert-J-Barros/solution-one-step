##PEERING NAT VNET TO AKS VNET

variable "peering_nat_to_aks" {
  description = "Name of the peering"
  default     = "PeeringNatToKksSolutionOne"
}

variable "nat_resource_group_name" {
  description = "Name of the resource group."
  default     = "ResourceGroupSolutionOneFase2"
}

variable "vnet_peering_nat_aks_name" {
  description = "Name of vnet."
  default     = "VnetSolutionOneFase"
}

variable "vnet_peering_aks_nat_id" {
  description = "Id of vnet AKS."
  default     = "/subscriptions/5dedbf86-9743-4904-b918-8b1ed28a138e/resourceGroups/ResourceGroupSolutionOneFase2-aks/providers/Microsoft.Network/virtualNetworks/aks-vnet-25883643/subnets/aks-subnet"
}


#######

##PEERING AKS VNET TO NAT VNET
variable "peering_aks_to_nat" {
  description = "Name of the peering"
  default     = "PeeringAKSToNATSolutionOne"
}
variable "aks_resource_group_name" {
  description = "Name of the resource group."
  default     = "ResourceGroupSolutionOneFase2-aks"
}
variable "vnet_peering_aks_nat_name" {
  description = "Name of vnet."
  default     = "aks-vnet-25883643"
}
variable "vnet_peering_nat_aks_id" {
  description = "Id of vnet NAT."
  default     = "/subscriptions/5dedbf86-9743-4904-b918-8b1ed28a138e/resourceGroups/ResourceGroupSolutionOneFase2/providers/Microsoft.Network/virtualNetworks/VnetSolutionOneFase/subnets/SubnetPubSolutionOneFase2"
}

############

##ROUTE TABLE
variable "route_table" {
  description = "Name of route table."
  default     = "routetablenat"
}

variable "route_table_region" {
  description = "Route table region"
  default     = "East US"
}

variable "subnet_aks_name" {
  description = "name subnet aks"
  default     = "aks-subnet"
}
