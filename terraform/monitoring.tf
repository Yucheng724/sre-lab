variable "grafana_admin_password" {
  type      = string
  sensitive = true
}

resource "helm_release" "kps" {
  name             = "kps"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true
  timeout          = 900

  values = concat(
    [file("${path.module}/values/kps.yaml")],
    fileexists("${path.module}/values/alertmanager.secret.yaml")
    ? [file("${path.module}/values/alertmanager.secret.yaml")]
    : []
  )

  set_sensitive {
    name  = "grafana.adminPassword"
    value = var.grafana_admin_password
  }
}
