terraform {
  backend "azurerm" {
    resource_group_name  = "Arrakis"
    storage_account_name = "spice"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.0.1"
    }
  }
}

provider "azurerm" {

  subscription_id = "f33092cf-589asdfasdf03-d8b593463157" #these are fakes
  tenant_id       = "f24ee086-08b3asdfasda6-73c78de1asdfbf" #these are fakes
  client_id       = "ff329ea1-c93asdfasdfdf932831f" #these are fakes
  client_secret   = "FLo8Q~xJD1wERqnwhdkfRflsdfsdfasNx36aIJ"  #these are fakes


  features {}
}

data "azurerm_kubernetes_cluster" "example" {
  name                = azurerm_kubernetes_cluster.exampleAKScluster.name
  resource_group_name = azurerm_resource_group.Arrakis.name
}

provider "kubernetes" {
  alias = "aks"
  host                   = data.azurerm_kubernetes_cluster.example.kube_config[0].host
  username               = data.azurerm_kubernetes_cluster.example.kube_config[0].username
  password               = data.azurerm_kubernetes_cluster.example.kube_config[0].password
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.example.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.example.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.example.kube_config[0].cluster_ca_certificate)
}

# resource "kubernetes_namespace" "arrakisNS" {
#   metadata {
#     name = "arrakis-namespace"
#   }

#   provider = kubernetes.aks

#   depends_on = [
#     azurerm_kubernetes_cluster.exampleAKScluster
#   ]
# }
