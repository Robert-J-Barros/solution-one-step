variable "resource_group_name" {
  description = "Name of the resource group."
  default     = "ResourceGroupSolutionOneFase2"
}

variable "public_ip_nat_name" {
  description = "Name of Ip association NAT"
  default     = ""
}


#### APPLICATION GATEWAY

variable "vnet_application_gateway" {
  description = "Name of the resource group."
  default     = ""
}

variable "peering_nat_name" {
  description = "Name of the resource group."
  default     = ""
}
variable "peering_aks_id" {
  description = "Name of the resource group."
  default     = ""
}

### AKS

variable "peering_aks_name" {
  description = "Name of the resource group."
  default     = ""
}

variable "peering_nat_id" {
  description = "Name of the resource group."
  default     = ""
}


