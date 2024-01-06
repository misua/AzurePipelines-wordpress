
variable "WORDPRESS_DB_PASSWORD" {
  description = "Password for the WordPress database"
  type        = string
  default     = "your_password_here"
}

data "external" "mysql_host" {
  program = ["bash", "-c", "echo -n {\\\"host\\\":\\\"$MYSQL_HOST\\\"} | jq ."]
}

variable "WORDPRESS_DB_HOST" {
  description = "Host for the WordPress database"
  type        = string
  default     = "your_host_here"
}
