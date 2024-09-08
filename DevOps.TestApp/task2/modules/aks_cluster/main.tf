# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "production-enviroment-node-pool"
    node_count = var.node_count
    vm_size    = var.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true
  }

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "Standard"
  }
  tags = var.tags
}

# Allow AKS to pull from ACR
resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope                = var.acr_id
}

# Role-based Access Control (RBAC) for Admins
resource "azurerm_role_assignment" "aks_admin" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = "USER_OR_GROUP_OBJECT_ID"  # Replace with AAD (Azure Active Directory) Object ID 
}

 



# Key Vault

# resource "azurerm_key_vault" "kv" {
#  name                = "kv-vault"
#  location            = var.location
#  resource_group_name = var.resource_group_name
#  tenant_id           = "TENANT_ID"
#  sku_name            = "standard"
# }

# resource "azurerm_key_vault_secret" "client_secret" {
#  name         = "aks-client-secret"
#  value        = "SECRET_VALUE"
#  key_vault_id = azurerm_key_vault.kv.id
# }

# data "azurerm_key_vault_secret" "client_secret" {
#  name         = "aks-client-secret"
#  key_vault_id = azurerm_key_vault.kv.id
# }
