resource "kubernetes_persistent_volume_claim_v1" "example" {
  metadata {
    name = "exampleclaimname"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume_v1.example.metadata.0.name}"
  }
}

resource "kubernetes_persistent_volume_v1" "example" {
  metadata {
    name = "examplevolumename"
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
  }
}


resource "kubernetes_deployment" "mysql" {
  metadata {
    name = "mysql"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = "mysql:latest"

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "password"
          }

          port {
            container_port = 3306
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_persistent_volume_claim_v1.example,
    kubernetes_persistent_volume_v1.example
  ]
}