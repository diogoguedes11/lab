# ---------------------------------------------------------------------------------------------------------------------
# Create network VPC
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_network" "vpc_network" {
  name                    = "${local.project}-vpc-network"
  description             = "VPC network"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# ---------------------------------------------------------------------------------------------------------------------
# Create private subnetwork
# ---------------------------------------------------------------------------------------------------------------------
resource "google_compute_subnetwork" "subnetwork" {
  name                     = "${local.project}-subnet"
  ip_cidr_range            = "10.0.0.0/24"
  region                   = local.region
  network                  = google_compute_network.vpc_network.name
  private_ip_google_access = true
}
