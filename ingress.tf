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
    # tls {
    #   hosts = ["example.com"] # Replace with your domain
    #   secret_name = "my-tls-cert" # Replace with the name of your Secret
    # }
  }
  depends_on = [
    azurerm_kubernetes_cluster.exampleAKScluster,
    kubernetes_service.wordpress,
  ]
}




# resource to create secret key to be used in ingress


# resource "kubernetes_secret" "example" {
#   metadata {
#     name = "my-tls-secret"
#   }

#   data = {
#     "tls.crt" = filebase64("path/to/tls.crt")
#     "tls.key" = filebase64("path/to/tls.key")
#   }

#   type = "kubernetes.io/tls"
# }


# deploy ingress to "listen" to all namespace

# data "helm_repository" "ingress-nginx" {
#   name = "ingress-nginx"
#   url  = "https://kubernetes.github.io/ingress-nginx"
# }

# resource "helm_release" "nginx_ingress" {
#   name       = "nginx-ingress"
#   repository = data.helm_repository.ingress-nginx.metadata[0].name
#   chart      = "ingress-nginx"
#   namespace  = "ingress-nginx"

#   set {
#     name  = "controller.scope.namespace"
#     value = ""
#   }
# }

# you could specify the namespace in the ingress controller to listen to specific namespace

# set {
#   name  = "controller.scope.namespace"
#   value = "namespace1,namespace2"
# }