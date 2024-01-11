resource "kubernetes_service" "mysql" {
  metadata {
    name = "mysqlservice"
  }

  spec {
    selector = {
      app = "mysql"
    }

    port {
      protocol    = "TCP"
      port        = 3306
      target_port = 3306
    }
  }
  depends_on = [
    azurerm_kubernetes_cluster.exampleAKScluster,
    kubernetes_deployment.mysql,
    kubernetes_deployment.wordpress,

  ]
}

resource "kubernetes_service" "wordpress" {
  metadata {
    name = "wordpress"
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
    kubernetes_deployment.wordpress,
    kubernetes_deployment.mysql,

  ]
}
