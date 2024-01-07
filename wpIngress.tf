resource "kubernetes_manifest" "wordpress_ingress" {
  manifest = {
    apiVersion = "networking.k8s.io/v1"
    kind = "Ingress"
    metadata = {
      name = "wordpress-ingress"
    }
    spec = {
      rules = [{
        host = "wordpress.example.com"
        http = {
          paths = [{
            pathType = "Prefix"
            path = "/"
            backend = {
              service = {
                name = "wordpress"
                port = {
                  number = 80
                }
              }
            }
          }]
        }
      }]
    }
  }

  depends_on = [
    kubernetes_deployment.wordpress
  ]
}

resource "kubernetes_service_v1" "wordpress" {
  metadata {
    name = "wordpress"
  }
  spec {
    selector = {
      app = "wordpress"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }

  depends_on = [
    kubernetes_deployment.wordpress
  ]
}