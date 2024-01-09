provider "azurerm" {

  features {}
}

data "azurerm_kubernetes_cluster" "example" {
  name                = azurerm_kubernetes_cluster.exampleAKScluster.name
  resource_group_name = azurerm_resource_group.Arrakis.name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.example.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.example.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.example.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.example.kube_config.0.cluster_ca_certificate)
}


