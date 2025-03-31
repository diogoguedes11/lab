resource "google_compute_firewall" "allow_ssh_fwrule" {
  name    = "allow-ssh-fwrule"
  project = local.project_id_consumer
  network = google_compute_network.vpc_network[0].name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = [google_compute_subnetwork.subnetwork[0].ip_cidr_range]
}

# ------------------------------------------------------
# Allow SSH from Web Console
# --------------------------------------------------------
resource "google_compute_firewall" "allow_ssh_ciap_fwrule" {
  name    = "allow-ssh-ciap-fwrule"
  project = local.project_id_consumer
  network = google_compute_network.vpc_network[0].name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}

# -----------------------------------------------------
# Allow icmp in the same network 
# ------------------------------------------------------
resource "google_compute_firewall" "allow_icmp_fwrule" {
  name    = "allow-icmp-fwrule"
  project = local.project_id_consumer
  network = google_compute_network.vpc_network[0].name
  allow {
    protocol = "icmp"
  }
  source_ranges = [google_compute_subnetwork.subnetwork[0].ip_cidr_range]
}
