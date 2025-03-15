# ---------------------------------------------------------------------------------------------------------------------
# Compute project metadata
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_project_metadata_item" "enableos_login" {
  count = local.create-vm ? 1 : 0
  key   = "enable-oslogin"
  value = "TRUE"
}

resource "google_compute_instance" "bastion_host" {
  count        = local.create-vm ? 1 : 0
  name         = "${local.env}-compute-instance"
  machine_type = "e2-micro"
  zone         = local.zone

  boot_disk {
    initialize_params {
      image = local.compute-image
      size  = 10
      type  = "pd-standard"
    }
  }
  network_interface {
    network    = google_compute_network.vpc_network[0].name
    subnetwork = google_compute_subnetwork.subnetwork[0].name

  }
}

