resource "kubernetes_deployment" "mysql" {
  wait_for_rollout = true
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
            name  = "MYSQL_USER"
            value = "tobolz"
          }
          # env {
          #   name = "MYSQL_ROOT_PASSWORD"
          #   value_from {
          #     secret_key_ref {
          #       name = "mysql-root-secret" // use secret for root password
          #       key  = "password"
          #     }
          #   }
          # }

          env {
            name  = "MYSQL_PASSWORD"
            value = "tobolz"
          }

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "tobolz"
          }


          env {
            name  = "MYSQL_DATABASE"
            value = "wordpress"
          }

          port {
            container_port = 3306
          }
        }
      }
    }
  }

  depends_on = [
    azurerm_kubernetes_cluster.exampleAKScluster,
  ]
}
