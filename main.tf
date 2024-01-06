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
    name                = "default"
    node_count          = 1
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 5
    vm_size             = "Standard_B2s"
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
  metadata {
    name = "test"
  }

  spec {
    min_replicas = 50
    max_replicas = 100

    scale_target_ref {
      api_version = "apps/v2"
      kind        = "Deployment"
      name        = "MyApp"
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
}