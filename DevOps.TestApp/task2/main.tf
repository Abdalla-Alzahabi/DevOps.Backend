#  Provider Configuration
provider "azurerm" {
  features {}
}

#  Resource Group
module "aks_resource_group" {
  source  = "./modules/resource_group"
  name    = "aks-rg"
  location = "East US"
}

#  Azure Container Registry (ACR)
module "acr_registry" {
  source              = "./modules/acr_registry"
  resource_group_name = module.aks_resource_group.name
  location            = module.aks_resource_group.location
  acr_name            = "myContainerRegistry"
}

#  AKS Cluster Module
module "aks_cluster" {
  source              = "./modules/aks_cluster"
  name                = "aks-cluster"
  location            = module.aks_resource_group.location
  resource_group_name = module.aks_resource_group.name
  dns_prefix          = "aks-cluster"
  node_count          = 3
  vm_size             = "Standard_DS2_v2"
  acr_id              = module.acr_registry.acr_id
  tags                = { Environment = "Production" }
}