provider "azurerm" {
  subscription_id = "f33092cf-589f-4378-8f03-d8b593463157"
  tenant_id       = "f24ee086-08b3-4f71-bba6-73c78de16bbf"
  client_id       = "ff329ea1-c934-4ef8-9fee-4f7df932831f"
  client_secret   = "FLo8Q~xJD1wERqnwhdkfRflOP0jdQ7rAKNx36aIJ"
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


