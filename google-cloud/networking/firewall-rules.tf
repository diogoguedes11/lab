resource "google_compute_firewall" "allow_ssh_fwrule" {
  count   = local.create-network ? 1 : 0
  name    = "allow-ssh-fwrule"
  network = google_compute_network.vpc_network[0].name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = [google_compute_subnetwork.subnetwork[0].ip_cidr_range]
}

# Allow SSH from Web Console
resource "google_compute_firewall" "allow_ssh_ciap_fwrule" {
  count   = local.create-network ? 1 : 0
  name    = "allow-ssh-ciap-fwrule"
  network = google_compute_network.vpc_network[0].name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}

# Allow icmp in the same network 
resource "google_compute_firewall" "allow_icmp_fwrule" {
  count   = local.create-network ? 1 : 0
  name    = "allow-icmp-fwrule"
  network = google_compute_network.vpc_network[0].name
  allow {
    protocol = "icmp"
  }
  source_ranges = [google_compute_subnetwork.subnetwork[0].ip_cidr_range]
}
