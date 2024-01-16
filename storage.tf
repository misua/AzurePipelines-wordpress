resource "kubernetes_storage_class" "storage-class" {
  provider = kubernetes.aks
  metadata {
    name = "storageclass"
  }
  storage_provisioner = "disk.csi.azure.com"
  reclaim_policy      = "Delete"
  parameters = {
    skuName = "Standard_LRS"
    kind    = "Managed"
  }
}

# Create a Persistent Volume Claim

resource "kubernetes_persistent_volume_claim_v1" "pvc" {
  metadata {
    name = "pvc"
    # namespace = "example-namespace" # to create a pvc in a specific namespace
  }
  timeouts {
    create = "30m"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "2Gi"
      }
    }
    storage_class_name = kubernetes_storage_class.storage-class.metadata[0].name
  }
  depends_on = [
    azurerm_kubernetes_cluster.exampleAKScluster,
    kubernetes_storage_class.storage-class,
  ]
}