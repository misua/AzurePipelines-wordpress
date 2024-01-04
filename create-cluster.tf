// Provider block for Azure Resource Manager
provider "azurerm" {
    features {}
}

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
        node_count = 3
        vm_size    = "Standard_DS2_v2"
    }

    // Service principal configuration for AKS cluster
    service_principal {
        client_id     = "GENERATED_FAKE_CLIENT_ID"
        client_secret = "GENERATED_FAKE_CLIENT_SECRET"
    }

    // Tags for the AKS cluster
    tags = {
        environment = "dev"
    }
}

// Horizontal Pod Autoscaler (HPA) creation for pods scaling
resource "kubernetes_horizontal_pod_autoscaler" "Sardaukar" {
    metadata {
        name      = "my-hpa"
        namespace = azurerm_kubernetes_cluster.exampleAKScluster.kubernetes_cluster_name
    }

    spec {
        // Scale target reference for the HPA
        scale_target_ref {
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
                name = "cpu"
                target_average_utilization = 50
            }
        }
    }
}

// Cluster Autoscaler creation for nodes scaling
resource "kubernetes_cluster_autoscaler" "Harkonnen" {
    metadata {
        name      = "my-cluster-autoscaler"
        namespace = azurerm_kubernetes_cluster.exampleAKScluster.kubernetes_cluster_name
    }

    spec {
        // Scale down utilization threshold
        scale_down_utilization_threshold = 0.5

        // Scale down settings
        scale_down_non_empty_requests_enabled = false
        scale_down_delay_after_add = "5m"
        scale_down_delay_after_delete = "10m"
        scale_down_delay_after_failure = "3m"
    }
}
