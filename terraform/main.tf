provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = "application"
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_secret" "postgres_secret" {
  metadata {
    name      = "postgres-secret"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  data = {
    POSTGRES_PASSWORD = var.postgres_password
    POSTGRES_USER     = var.postgres_user
    POSTGRES_DB       = var.postgres_db
    DATABASE_URL      = var.postgres_url
  }
}
