
resource "google_compute_instance" "default" {
  name         = "test-vm"
  machine_type = "e2-micro"
  zone         = "${var.region}-a" 


  boot_disk {
    initialize_params {
      image ="ubuntu-os-cloud/ubuntu-2004-lts"
    }

  }

  network_interface {
    network = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnetwork.name 

#     access_config {
#       // Ephemeral public IP
#     }
  }

#   service_account {
#     # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
#     email  = google_service_account.default.email
#     scopes = ["cloud-platform"]
#   }
}
