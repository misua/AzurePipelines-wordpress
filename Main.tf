// Resource group creation
resource "azurerm_resource_group" "Arrakis" {
  name     = "my-Arrakis-rg"
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
    name                = "default"
    node_count          = 3
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 5
    vm_size             = "Standard_B2s"
    zones = [ "1", "2", "3" ]

    #zones = ["1", "2", "3"] #added for testing 1 node in each zone
  }

  // Service principal configuration for AKS cluster
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

resource "kubernetes_horizontal_pod_autoscaler_v2" "example" {
  provider = kubernetes.aks #boysit
  metadata {
    name = "test"
  }

  spec {
    min_replicas = 5
    max_replicas = 10

    scale_target_ref {
      api_version = "apps/v2"
      kind        = "Deployment"
      name        = "MyApp"
    }

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 50
        }
      }
    }

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 50
        }
      }
    }

    behavior {
      scale_down {
        stabilization_window_seconds = 300
        select_policy                = "Min"
        policy {
          period_seconds = 120
          type           = "Pods"
          value          = 1
        }

        policy {
          period_seconds = 310
          type           = "Percent"
          value          = 100
        }
      }
      scale_up {
        stabilization_window_seconds = 600
        select_policy                = "Max"
        policy {
          period_seconds = 180
          type           = "Percent"
          value          = 100
        }
        policy {
          period_seconds = 600
          type           = "Pods"
          value          = 5
        }
      }
    }
  }
  depends_on = [azurerm_kubernetes_cluster.exampleAKScluster]
}

# to create namespace

# provider "kubernetes" {
#   config_path = "kubeconfig" # Path to the kubeconfig file
# }

# resource "kubernetes_namespace" "namespace1" {
#   metadata {
#     name = "namespace1"
#   }
# }

# resource "kubernetes_namespace" "namespace2" {
#   metadata {
#     name = "namespace2"
#   }
# }