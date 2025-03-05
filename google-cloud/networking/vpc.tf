provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false

}
resource "google_compute_subnetwork" "subnetwork" {
  name                     = "${var.region}-subnet"
  ip_cidr_range            = "10.0.0.0/24"
  region                   = var.region
  network                  = google_compute_network.vpc_network.name
  private_ip_google_access = true
}

resource "google_compute_firewall" "allow_ssh_fwrule" {
  name    = "allow-ssh-fwrule"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = [google_compute_subnetwork.subnetwork.ip_cidr_range]
}

# Allow SSH from Web Console
resource "google_compute_firewall" "allow_ssh_ciap_fwrule" {
  name    = "allow-ssh-ciap-fwrule"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}

# Allow icmp in the same network 
resource "google_compute_firewall" "allow_icmp_fwrule" {
  name    = "allow-icmp-fwrule"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "icmp"
  }
  source_ranges = [google_compute_subnetwork.subnetwork.ip_cidr_range]
}
