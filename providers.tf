provider "azurerm" {
  subscription_id = "f33092cf-589asdfasdf03-d8b593463157"
  tenant_id       = "f24ee086-08b3asdfasda6-73c78de1asdfbf"
  client_id       = "ff329ea1-c93asdfasdfdf932831f"
  client_secret   = "FLo8Q~xJD1wERqnwhdkfRflsdfsdfasNx36aIJ"

  features {}
}

data "azurerm_kubernetes_cluster" "example" {
  name                = azurerm_kubernetes_cluster.exampleAKScluster.name
  resource_group_name = azurerm_resource_group.Arrakis.name
}


provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.example.kube_config[0].host
  username               = data.azurerm_kubernetes_cluster.example.kube_config[0].username
  password               = data.azurerm_kubernetes_cluster.example.kube_config[0].password
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.example.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.example.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.example.kube_config[0].cluster_ca_certificate)

}