resource "kubernetes_service" "wpLB" {
  provider = kubernetes.aks #boysit
  metadata {
    name = "wploadbalancer"
  }
  spec {
    selector = {
      app = "wordpress"
    }

    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}


resource "kubernetes_ingress_v1" "example" {
  # wait_for_load_balancer = true
  metadata {
    name = "example"
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        path {
          path = "/*"
          backend {
            service {
              name = kubernetes_service.wordpress.metadata.0.name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
  depends_on = [
    azurerm_kubernetes_cluster.exampleAKScluster,
    kubernetes_service.wordpress,
  ]
}

# Display load balancer hostname (typically present in AWS)
# output "load_balancer_hostname" {
#   value = kubernetes_ingress_v1.example.status.0.load_balancer.0.ingress.0.hostname
# }

# Display load balancer IP (typically present in GCP, or using Nginx ingress controller)
# output "load_balancer_ip" {
#   value = kubernetes_ingress_v1.example.status.0.load_balancer.0.ingress.0.ip
# }