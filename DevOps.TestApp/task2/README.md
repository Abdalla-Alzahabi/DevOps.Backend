# Task 2: Infrastructure as Code (IaC) with Terraform

# Azure Kubernetes Service (AKS) with Terraform

automationg deployment of an AKS cluster using Terraform. by following best practices for IaC, modularity, and security, including the use of ACR and RBAC for managing access.

## Project Structure

The Terraform project is structured using modules for improved maintainability and reusability.

terraform/
├── main.tf 
├── variables.tf 
├── outputs.tf 
├── modules/
│ ├── resource_group/ 
│ ├── aks_cluster/ 
│ └── acr_registry/ 





## Modules Overview

### Resource Group Module

This module creates an Azure Resource Group, where all resources like AKS and ACR will be provisioned.

**Inputs:**

- name: The name of the resource group.
- location: Azure region where the resource group will be created.

**Outputs:**

- name: Name of the created resource group.
- location: Location of the resource group.

### AKS Cluster Module

This module provisions an AKS cluster with a default node pool and configures RBAC for secure access management.

**Features:**

- Uses System-Assigned Managed Identity for the AKS cluster.
- Grants access to pull images from Azure Container Registry ACR using the AcrPull role.
- Configures Role-Based Access Control (RBAC) for AKS admin and user access.

**Inputs:**

- name: Name of the AKS cluster.
- location: Azure region.
- resource_group_name: Name of the resource group.
- dns_prefix: DNS prefix for the AKS cluster.
- node_count: Number of nodes in the default pool (default = 3).
- vm_size: VM size for the AKS nodes (default = Standard_DS2_v2).
- acr_id: The Azure Container Registry (ACR) ID for Docker image storage.
- tags: Key-value pairs of tags to apply to the resources.

**Outputs:**

- kube_config: The Kubernetes configuration to access the AKS cluster.

### Azure Container Registry (ACR) Module

This module provisions an Azure Container Registry (ACR), which stores Docker images that will be deployed on the AKS cluster.

**Inputs:**

- resource_group_name: Name of the resource group.
- location: Azure region.
- acr_name: Name of the Azure Container Registry.

**Outputs:**

- acr_id: The ID of the ACR for use in other modules.


-----------------------------------------------------------




# Getting Started

## Step 1: Clone the Repository

### Pre-requisites

- Terraform: Ensure Terraform is installedd
- Azure CLI: Install the Azure CLI for authentication.

```bash
git clone https://abdallazahabi@dev.azure.com/abdallazahabi/abdalla-zahabi/_git/DevOps.Backend/
cd task2
```

### Step 2: Set Up Azure Authentication

Ensure you have authenticated with Azure CLI:

```bash
az login
```

Add the following environment variables:

```bash
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
```

### Step 3: Initialize Terraform

Initialize Terraform to download the necessary provider and modules:
```bash
terraform init
```


### Step 4: Plan the Deployment
Run the terraform plan command to see what resources will be created:
```bash
terraform plan
```

### Step 5: Apply the Configuration
Apply the Terraform configuration to create the AKS cluster and supporting resources:

```bash
terraform apply
```

Confirm the action by typing yes.


### Step 6: Access the AKS Cluster
After the deployment is complete, you can access your Kubernetes cluster by saving the outputted kube_config and using it with kubectl.

Export the kube_config:

```bash
export KUBECONFIG=path_to_kubeconfig
```

Verify access:

```bash
kubectl get nodes
```


### Step 7: Deploy Applications to AKS
Build your Docker image and push it to ACR:

```bash
docker build -t ContainerRegistry.azurecr.io/Devops.backend:v1 .
az acr login --name ContainerRegistry
docker push ContainerRegistry.azurecr.io/Devops.backend:v1
```

Create a Kubernetes deployment with the pushed image:



```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: Devops.backend-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: Devops.backend
  template:
    metadata:
      labels:
        app: Devops.backend
    spec:
      containers:
      - name: Devops.backendpp
        image: ContainerRegistry.azurecr.io/Devops.backend:v1
        ports:
        - containerPort: 8080
        
---
apiVersion: v1
kind: Service
metadata:
  name: Devops.backend
spec:
  type: LoadBalancer
  ports:
  - port: 8080
  selector:
    app: Devops.backend
```

Apply the deployment to AKS:

```bash
kubectl apply -f deployment.yaml
```



## Security and Access Management

### Role-Based Access Control (RBAC)

The AKS cluster uses RBAC for managing permissions and access control:

- Cluster Admin: Grants full access to manage the AKS cluster.
- AcrPull: Allows AKS to pull images from the Azure Container Registry (ACR) without storing sensitive credentials.

### Azure Key Vault for Secrets
- Use Azure Key Vault to store sensitive information like client secrets instead of hardcoding them in your Terraform files.

example: client ID, Client Secret

```hcl
# Key Vault

resource "azurerm_key_vault" "kv" {
  name                = "kv-vault"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = "TENANT_ID"
  sku_name            = "standard"
}

resource "azurerm_key_vault_secret" "client_secret" {
  name         = "aks-client-secret"
  value        = "SECRET_VALUE"
  key_vault_id = azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "client_secret" {
  name         = "aks-client-secret"
  key_vault_id = azurerm_key_vault.kv.id
}
```

