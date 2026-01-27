
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.7.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = "europe-west1"
}
# Node01 
resource "google_compute_network" "vpc_node01" {
  name                    = "vpc-node01"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "subnet_node01" {
  name          = "sb-node01"
  network       = google_compute_network.vpc_node01.name
  region        = var.region
  ip_cidr_range = "10.0.0.0/24"
  depends_on    = [google_compute_network.vpc_node01]
}

# Node02
resource "google_compute_network" "vpc_node02" {
  name                    = "vpc-node02"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "subnet_node02" {
  name          = "sb-node02"
  network       = google_compute_network.vpc_node02.name
  region        = var.region
  ip_cidr_range = "10.0.1.0/24"
  depends_on    = [google_compute_network.vpc_node02]
}
# ========= VMS AND FIREWALLS FOR TESTING ==========

# resource "google_compute_instance" "linux_vm_node01" {
#   name         = "linux-vm-node01"
#   machine_type = "e2-micro"
#   tags         = ["use-nva"]

#   metadata_startup_script = <<-EOT
#     sudo apt-get update -y
#     sudo apt-get install nginx
#     sudo systemctl start nginx
#     sudo systemctl enable nginx
#   EOT 
#   network_interface {
#     # access_config {}
#     network    = google_compute_network.vpc_node01.name
#     subnetwork = google_compute_subnetwork.subnet_node01.name
#   }
#   zone = "${var.region}-a"
#   boot_disk {
#     initialize_params {
#       image = "ubuntu-os-cloud/ubuntu-2204-lts"
#       labels = {
#         node = "node01"
#       }
#     }
#   }

#   depends_on = [google_compute_subnetwork.subnet_node01]
# }

# resource "google_compute_firewall" "allow_ssh_iap_node01" {
#   name    = "allow-ssh-via-iap"
#   network = google_compute_network.vpc_node01.self_link

#   allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }

#   source_ranges = ["35.235.240.0/20"]
# }

# resource "google_compute_firewall" "allow_icmp_node01" {
#   name    = "allow-icmp-node01"
#   network = google_compute_network.vpc_node01.self_link

#   allow {
#     protocol = "icmp"
#   }

#   source_ranges = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
# }

# resource "google_compute_firewall" "allow_internal_node01" {
#   name    = "allow-internal-node01"
#   network = google_compute_network.vpc_node01.self_link

#   allow {
#     protocol = "tcp"
#     ports    = ["0-65535"]
#   }

#   allow {
#     protocol = "udp"
#     ports    = ["0-65535"]
#   }
#   source_ranges = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
# }

resource "google_compute_firewall" "allow_ssh_iap_node02" {
  name    = "allow-ssh-via-iap-node02"
  network = google_compute_network.vpc_node02.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_firewall" "allow_icmp_node02" {
  name    = "allow-icmp-node02"
  network = google_compute_network.vpc_node02.self_link

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

# resource "google_compute_firewall" "allow_internal_node02" {
#   name    = "allow-internal-node02"
#   network = google_compute_network.vpc_node02.self_link

#   allow {
#     protocol = "tcp"
#     ports    = ["0-65535"]
#   }

#   allow {
#     protocol = "udp"
#     ports    = ["0-65535"]
#   }

#   source_ranges = ["0.0.0.0/0"]
# }

resource "google_compute_instance" "linux_vm_node02" {
  name         = "linux-vm-node02"
  machine_type = "e2-micro"
  network_interface {
    # access_config {}
    network    = google_compute_network.vpc_node02.name
    subnetwork = google_compute_subnetwork.subnet_node02.name
  }
  zone = "${var.region}-a"
  boot_disk {

    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      labels = {
        node = "node02"
      }
    }
  }
  depends_on = [google_compute_subnetwork.subnet_node02]
}
# Cloud armor

resource "google_compute_region_security_policy" "armor_internal" {
  name     = "armor-policy-internal"
  provider = google-beta
  region   = var.region
  project  = var.project_id
  type     = "CLOUD_ARMOR"

}

resource "google_compute_region_security_policy_rule" "deny_node01" {
  provider        = google-beta
  project         = var.project_id
  region          = var.region
  security_policy = google_compute_region_security_policy.armor_internal.name
  priority        = 1000
  match {
    versioned_expr = "SRC_IPS_V1"
    config {
      src_ip_ranges = ["10.0.0.0/24"] # Range da subnet-node01
    }
  }
  action = "deny"
}

# LOAD BALANCER

resource "google_compute_forwarding_rule" "google_compute_forwarding_rule" {
  name                  = "l4-ilb-forwarding-rule"
  region                = var.region
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "80"
  allow_global_access   = true
  network               = google_compute_network.vpc_node02.id
  subnetwork            = google_compute_subnetwork.subnet_node02.id

  target = google_compute_region_target_http_proxy.default.id
}
resource "google_compute_region_url_map" "default" {
  name            = "l7-ilb-url-map"
  region          = var.region
  default_service = google_compute_region_backend_service.default.id
}
resource "google_compute_subnetwork" "proxy_only_subnet" {
  name          = "proxy-only-subnet"
  ip_cidr_range = "10.129.0.0/23"
  network       = google_compute_network.vpc_node02.id
  region        = var.region
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}

resource "google_compute_region_target_http_proxy" "default" {
  name    = "l7-ilb-target-proxy"
  region  = var.region
  url_map = google_compute_region_url_map.default.id
}
resource "google_compute_region_backend_service" "default" {
  name                  = "l4-ilb-backend-subnet"
  provider              = google-beta
  project               = var.project_id
  region                = var.region
  protocol              = "HTTP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  security_policy       = google_compute_region_security_policy.armor_internal.self_link
  port_name             = "http"
  backend {
    group           = google_compute_region_instance_group_manager.mig.instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 0.8
    capacity_scaler = 1.0
  }

  health_checks = [google_compute_region_health_check.default.id]
}

resource "google_compute_instance_template" "instance_template" {
  name         = "l4-ilb-mig-template"
  machine_type = "e2-small"
  tags         = ["allow-ssh", "allow-health-check", "allow-http"]

  network_interface {
    network    = google_compute_network.vpc_node02.id
    subnetwork = google_compute_subnetwork.subnet_node02.id
    # access_config {
    #   # add external ip to fetch packages
    # }
  }
  disk {
    source_image = "ubuntu-os-cloud/ubuntu-2204-lts"
    auto_delete  = true
    boot         = true
  }

  # install nginx and serve a simple web page
  metadata = {
    startup-script = <<-EOF1
      #! /bin/bash
      set -euo pipefail

      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      apt-get install -y nginx-light jq

      cat <<EOF > /var/www/html/index.html
      <pre>
      NGINX is working like a charm :)
      </pre>
      EOF
    EOF1
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_firewall" "fw_http" {

  name    = "fw-allow-http"
  network = google_compute_network.vpc_node02.id
  allow {
    ports    = ["80"]
    protocol = "TCP"
  }
  source_ranges = ["10.0.1.0/24"]
  target_tags   = ["allow-http"]
}

resource "google_compute_region_health_check" "default" {
  name   = "l4-ilb-hc"
  region = var.region
  http_health_check {
    port = "80"
  }
}

resource "google_compute_region_instance_group_manager" "mig" {
  name   = "l4-ilb-mig1"
  region = var.region
  version {
    instance_template = google_compute_instance_template.instance_template.id
    name              = "primary"
  }
  named_port {
    name = "http"
    port = 80
  }
  base_instance_name = "vm"
  target_size        = 1
}

# allow all access from health check ranges
resource "google_compute_firewall" "fw_hc" {
  name          = "l4-ilb-fw-allow-hc"
  direction     = "INGRESS"
  network       = google_compute_network.vpc_node02.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "35.235.240.0/20"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["allow-health-check"]
}

# Cloud nat
resource "google_compute_router" "router" {
  name    = "nat-router"
  network = google_compute_network.vpc_node02.id
  region  = var.region
}
module "cloud_nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 5.0"
  project_id = var.project_id
  region     = var.region
  router     = google_compute_router.router.name
}
