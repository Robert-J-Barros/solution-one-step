variable "resource_group_name" {
  description = "Name of the resource group."
  default     = "ResourceGroupSolutionOneFase2"
}
variable "vnet_name" {
  description = "Name of the vnet."
  default     = "VnetSolutionOneFase"
}
variable "subnet_name" {
  description = "Name of the subnet."
  default     = "SubnetPubSolutionOneFase2"
}
variable "subnet_name_appgtw" {
  description = "Name of the subnet."
  default     = "SubnetPub2SolutionOneFase2"
}

variable "public_ip" {
  description = "Name of the public_ip."
  default     = "PublicIpSolutionOneFase2"
}
variable "nat_ip" {
  description = "Name of the public_ip."
  default     = "IpNatGatewaySolutionOneFase2"
}
variable "nat_name" {
  description = "Name of the public_ip."
  default     = "NatGatewaySolutionOneFase2"
}

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
