output "kubeconfig_path" {
  value = kind_cluster.lab.kubeconfig_path
}

output "app_url" {
  value = "http://localhost:8080"
}