resource "kubernetes_deployment" "wordpress" {
  wait_for_rollout = true
  metadata {
    name = "wordpress"
     namespace = "my-namespace"  # Add this line for namespaced deployment
  }
  timeouts {
    create = "30m"
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
            value = "mysqlservice"
          }
          env {
            name  = "WORDPRESS_DB_USER"
            value = "root"
          }

          # env {
          #   name = "WORDPRESS_DB_PASSWORD"
          #   value_from {
          #     secret_key_ref {
          #       name = "mysql-root-secret" // use secret for root password
          #       key  = "password"
          #     }
          #   }
          # }
          env {
            name  = "WORDPRESS_DB_PASSWORD"
            value = "tobolz"
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
            claim_name = "pvc"
          }

        }
      }
    }
  }

  depends_on = [
    azurerm_kubernetes_cluster.exampleAKScluster,
    kubernetes_persistent_volume_claim_v1.pvc,
  ]
}