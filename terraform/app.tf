resource "kubernetes_namespace_v1" "app" {
  metadata {
    name = "sre-lab"
  }
}

resource "kubernetes_deployment_v1" "app" {
  metadata {
    name      = "sre-lab"
    namespace = kubernetes_namespace_v1.app.metadata[0].name
    labels    = { app = "sre-lab" }
  }

  spec {
    replicas = var.replicas
    selector {
      match_labels = { app = "sre-lab" }
    }

    template {
      metadata {
        labels = { app = "sre-lab" }
      }
      spec {
        container {
          name  = "app"
          image = var.image
          port {
            name           = "http"
            container_port = 8000
          }
          resources {
            requests = { cpu = "50m", memory = "64Mi" }
            limits   = { cpu = "250m", memory = "256Mi" }
          }
          readiness_probe {
            http_get {
              path = "/health"
              port = "http"
            }
            period_seconds = 5
          }
          liveness_probe {
            http_get {
              path = "/health"
              port = "http"
            }
            initial_delay_seconds = 10
            period_seconds        = 10
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "app" {
  metadata {
    name      = "sre-lab"
    namespace = kubernetes_namespace_v1.app.metadata[0].name
    labels    = { app = "sre-lab" } # Stage 5 的 ServiceMonitor 靠這個 label 找到它
  }
  spec {
    type     = "NodePort"
    selector = { app = "sre-lab" }
    port {
      name        = "http" # Stage 5 的 ServiceMonitor 靠這個名稱抓 /metrics
      port        = 80
      target_port = "http"
      node_port   = 30080
    }
  }
}