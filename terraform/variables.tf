variable "postgres_user" {
  description = "PostgreSQL username"
  type        = string
  default     = "postgres"
}

variable "postgres_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
}

variable "postgres_db" {
  description = "PostgreSQL database name"
  type        = string
  default     = "stclab"
}
variable "postgres_url" {
  type    = string
  default = "postgre://postgres:32518458@postgresql.application.svc.cluster.local:5432/stclab"
}
