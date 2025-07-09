resource "kubernetes_namespace" "observability" {
  metadata {
    name = "observability"
  }
}
# ---------------------------------------------------------------------------------------------------------------------
# Deploy Grafana using Helm
# ---------------------------------------------------------------------------------------------------------------------
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  values     = file("${path.module}/manifests/grafana-values.yaml")
  namespace  = "observability"
}


