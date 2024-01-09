
variable "WORDPRESS_DB_PASSWORD" {
  description = "Password for the WordPress database"
  type        = string
  default     = "tobolz"
}

data "external" "mysql_host" {
  program = ["bash", "-c", "echo -n {\\\"host\\\":\\\"$MYSQL_HOST\\\"} | jq ."]
}

variable "WORDPRESS_DB_HOST" {
  description = "Host for the WordPress database"
  type        = string
  default = "wordpress"
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