# solution-one-step
https://solution-one.fairness.com.br/
# Projeto Terraform

Este é um projeto Terraform para criar e gerenciar infraestrutura na nuvem. Ele utiliza o provedor de nuvem Azure e inclui módulos para configurar uma rede virtual (VNet), um cluster AKS (Azure Kubernetes Service) e um Application Gateway. A infraestrutura foi baceada na seguinte documentação [Microsoft](https://learn.microsoft.com/pt-br/azure/application-gateway/tutorial-ingress-controller-add-on-existing?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Faks%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Fbread%2Ftoc.json#code-try-1)

## Pré-requisitos

- [Terraform](https://www.terraform.io/downloads.html) instalado (versão >= 3.92.0)
- Conta Azure com permissões para criar recursos

## Configuração

1. Clone this repository:

   ```bash
   git clone https://github.com/seu-usuario/projeto-terraform.git
   ```
2. Access the module:

   ```bash
   cd Modules
   ```
3. Start te module:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
### NAT
Apos a inicialização dos modulos para que o Nat funcione será necessario criar um Peering entre as duas Vnet e atachar as route table em suas devidas subnet :
```bash
nodeResourceGroup=$(az aks show -n ResourceGroupSolutionOneFase2-name -g ResourceGroupSolutionOneFase2 -o tsv --query "nodeResourceGroup")
aksVnetName=$(az network vnet list -g $nodeResourceGroup -o tsv --query "[0].name")

aksVnetId=$(az network vnet show -n $aksVnetName -g $nodeResourceGroup -o tsv --query "id")
az network vnet peering create -n AppGWtoAKSVnetPeering -g ResourceGroupSolutionOneFase2 --vnet-name VnetSolutionOneFase --remote-vnet $aksVnetId --allow-vnet-access

aksVnetId=$(az network vnet show -n $aksVnetName -g $nodeResourceGroup -o tsv --query "id")
appGWVnetId=$(az network vnet show -n VnetSolutionOneFase -g ResourceGroupSolutionOneFase2 -o tsv --query "id")
az network vnet peering create -n AKStoAppGWVnetPeering -g $nodeResourceGroup --vnet-name $aksVnetName --remote-vnet $appGWVnetId --allow-vnet-access
```
```bash
az network vnet subnet update --name aks-subnet --resource-group my-resource-group --vnet-name my-vnet --route-table route-table-aks
```

### Enable Application Gateway to AKS

![enable](https://github.com/Robert-J-Barros/solution-one-step/assets/105607298/4d791ee7-b6b4-474b-b02b-d0b8fde831c7)
