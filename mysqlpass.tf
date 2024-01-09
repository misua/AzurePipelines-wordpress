
resource "kubernetes_secret" "mysql-root-secret" {
  metadata {
    name = "mysql-root-secret"
  }

  data = {
    password = base64encode("tobolz") // replace with your root password
  }
}




# variable "deploy_wordpress" {
#   description = "Control the creation of the WordPress deployment"
#   type        = bool
#   default     = false
# }

# variable "deploy_ingress" {
#   description = "Control the creation of the ingress deployment"
#   type        = bool
#   default     = false
# }