resource "kind_cluster" "lab" {
  name            = "sre-lab"
  wait_for_ready  = true
  kubeconfig_path = pathexpand("~/.kube/sre-lab")

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      # 把叢集的 NodePort 30080 映射到本機 8080
      extra_port_mappings {
        container_port = 30080
        host_port      = 8080
      }
    }

    node {
      role = "worker"
    }
  }
}

provider "kubernetes" {
  host                   = kind_cluster.lab.endpoint
  client_certificate     = kind_cluster.lab.client_certificate
  client_key             = kind_cluster.lab.client_key
  cluster_ca_certificate = kind_cluster.lab.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = kind_cluster.lab.endpoint
    client_certificate     = kind_cluster.lab.client_certificate
    client_key             = kind_cluster.lab.client_key
    cluster_ca_certificate = kind_cluster.lab.cluster_ca_certificate
  }
}
