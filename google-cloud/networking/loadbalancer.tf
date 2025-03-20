
# forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  count                 = local.create-mig ? 1 : 0
  project               = local.project
  name                  = "l7-xlb-forwarding-rule"
  provider              = google-beta
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.0.id
}

# http proxy
resource "google_compute_target_http_proxy" "default" {
  count    = local.create-mig ? 1 : 0
  project  = local.project
  name     = "l7-xlb-target-http-proxy"
  provider = google-beta
  url_map  = google_compute_url_map.default.0.id
}

# url map
resource "google_compute_url_map" "default" {
  count           = local.create-mig ? 1 : 0
  project         = local.project
  name            = "l7-xlb-url-map"
  provider        = google-beta
  default_service = google_compute_backend_service.default.0.id
}

# backend service with custom request and response headers
resource "google_compute_backend_service" "default" {
  count                 = local.create-mig ? 1 : 0
  project               = local.project
  name                  = "l7-xlb-backend-service"
  provider              = google
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = 10
  enable_cdn            = false
  health_checks         = [google_compute_health_check.default.0.id]
  backend {
    group           = google_compute_instance_group_manager.default.0.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

# instance template
resource "google_compute_instance_template" "default" {
  count        = local.create-mig ? 1 : 0
  project      = local.project
  name         = "l7-xlb-mig-template"
  provider     = google
  machine_type = "e2-small"
  tags         = ["allow-health-check"]

  network_interface {
    network            = google_compute_network.vpc_network.0.name
    subnetwork         = google_compute_subnetwork.subnetwork.0.name
    subnetwork_project = local.project
    access_config {
      # add external ip to fetch packages
    }
  }
  disk {
    source_image = "debian-cloud/debian-12"
    auto_delete  = true
    boot         = true
  }

  # install nginx and serve a simple web page
  metadata = {
    startup-script = <<-EOF1
      #! /bin/bash
      set -euo pipefail

      apt-get update
      sudo apt install -y apache2
      EOF
    EOF1
  }
  lifecycle {
    create_before_destroy = true
  }
}

# health check
resource "google_compute_health_check" "default" {
  count    = local.create-mig ? 1 : 0
  project  = local.project
  name     = "l7-xlb-hc"
  provider = google
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

# MIG
resource "google_compute_instance_group_manager" "default" {
  count    = local.create-mig ? 1 : 0
  project  = local.project
  name     = "l7-xlb-mig1"
  provider = google
  zone     = local.zone
  named_port {
    name = "http"
    port = 8080
  }
  version {
    instance_template = google_compute_instance_template.default.0.id
    name              = "primary"
  }
  base_instance_name = "vm"
  target_size        = 2
}

# allow access from health check ranges
resource "google_compute_firewall" "default" {
  count         = local.create-mig ? 1 : 0
  project       = local.project
  name          = "l7-xlb-fwrule"
  provider      = google
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.0.name
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["allow-health-check"]
}
