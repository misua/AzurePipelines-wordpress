

resource "kubernetes_storage_class_v1" "example" {
  metadata {
    name = "example-storage-class"
  }
  storage_provisioner = "kubernetes.io/azure-disk"
  reclaim_policy      = "Retain" # Added missing attribute
  parameters = {
    type = "pd-standard"
  }
  #mount_options = ["file_mode=0700", "dir_mode=0777", "mfsymlinks", "uid=1000", "gid=1000", "nobrl", "cache=none"]
  depends_on = [
    azurerm_kubernetes_cluster.exampleAKScluster,
  ]
}

resource "kubernetes_persistent_volume_claim_v1" "example" {
  metadata {
    name = "example-claim-name"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    storage_class_name = kubernetes_storage_class_v1.example.metadata.0.name
  }
  depends_on = [
    azurerm_kubernetes_cluster.exampleAKScluster,
  ]
}



resource "kubernetes_persistent_volume_v1" "example" {
  metadata {
    name = "example-volume-name"
  }
  spec {
    capacity = {
      storage = "2Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      gce_persistent_disk {
        pd_name = "test-123"
      }
    }
    storage_class_name = kubernetes_storage_class_v1.example.metadata.0.name
  }

  depends_on = [
    azurerm_kubernetes_cluster.exampleAKScluster,
  ]
}

