resource "kubernetes_service" "mysql" {
    metadata {
        name = "mysql-service"
    }

    spec {
        selector = {
            app = "mysql"
        }

        port {
            protocol = "TCP"
            port     = 3306
            target_port = 3306
        }
    }
}

resource "kubernetes_service" "wordpress" {
    metadata {
        name = "wordpress-service"
    }

    spec {
        selector = {
            app = "wordpress"
        }

        port {
            protocol    = "TCP"
            port        = 80
            target_port = 80
        }
    }
     depends_on = [
    azurerm_kubernetes_cluster.exampleAKScluster,
    kubernetes_deployment.mysql,
    kubernetes_deployment.wordpress,
    kubernetes_storage_class_v1.example,
    kubernetes_persistent_volume_claim_v1.example,
    kubernetes_persistent_volume_v1.example,
    
  ]
}
