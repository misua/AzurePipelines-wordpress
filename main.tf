// Resource group creation
resource "azurerm_resource_group" "Arrakis" {
  name     = "my-resource-group"
  location = "eastus"
}

// Azure Kubernetes Service (AKS) cluster creation
resource "azurerm_kubernetes_cluster" "exampleAKScluster" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.Arrakis.location
  resource_group_name = azurerm_resource_group.Arrakis.name
  dns_prefix          = "myakscluster"

  // Default node pool configuration
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  // Service principal configuration for AKS cluster
  # service_principal {

  #     client_id     = var.client_id
  #     client_secret = var.secrets
  # }
  identity {
    type = "SystemAssigned"
  }
  // Tags for the AKS cluster
  tags = {
    environment = "dev"
  }
}

resource "local_file" "kubeconfig" {
    filename = "kubeconfig"
    content  = azurerm_kubernetes_cluster.exampleAKScluster.kube_config_raw
}

// Horizontal Pod Autoscaler (HPA) creation for pods scaling
resource "kubernetes_horizontal_pod_autoscaler" "Sardaukar" {
  metadata {
    name      = "my-hpa"
    namespace = azurerm_kubernetes_cluster.exampleAKScluster.name
  }

  spec {
    // Scale target reference for the HPA
    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = "my-deployment"
    }

    // Minimum and maximum replicas for scaling
    min_replicas = 1
    max_replicas = 5

    // Metric configuration for scaling
    metric {
      type = "Resource"
      resource {
        name                       = "cpu"
        target {
          type               = "Utilization"
          average_utilization = 50
          
        }
      }
    }
  }
}


# // Cluster Autoscaler creation for nodes scaling
# resource "kubernetes_cluster_autoscaler" "Harkonnen" {
#   metadata {
#     name      = "my-cluster-autoscaler"
#     namespace = azurerm_kubernetes_cluster.exampleAKScluster.kubernetes_cluster_name
#   }

#   spec {
#     // Scale down utilization threshold
#     scale_down_utilization_threshold = 0.5

#     // Scale down settings
#     scale_down_non_empty_requests_enabled = false
#     scale_down_delay_after_add            = "5m"
#     scale_down_delay_after_delete         = "10m"
#     scale_down_delay_after_failure        = "3m"
#   }
# }
