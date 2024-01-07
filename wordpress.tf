resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wordpress"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "wordpress"
      }
    }

    template {
      metadata {
        labels = {
          app = "wordpress"
        }
      }

      spec {
        container {
          name  = "wordpress"
          image = "wordpress:latest"

          env {
            name  = "WORDPRESS_DB_HOST"
            value = data.external.mysql_host.result.host
          }

          env {
            name  = "WORDPRESS_DB_PASSWORD"
            value = var.WORDPRESS_DB_PASSWORD
          }

          port {
            container_port = 80
          }

          volume_mount {
            name       = "wordpress-persistent-storage"
            mount_path = "/var/www/html"
          }
        }

        volume {
          name = "wordpress-persistent-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.example.metadata[0].name
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
