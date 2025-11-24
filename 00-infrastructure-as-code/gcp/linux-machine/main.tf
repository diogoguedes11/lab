
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.7.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region = "europe-west1"
}


# Customm Service account for the linux VM
resource "google_service_account" "this" {
  account_id   = "linuxvm-sa"
  display_name = "Custom SA for VM Instance"
}


resource "google_compute_instance" "this" {
  name         = "linux-instance"
  machine_type = "e2-standard-2"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = "sudo apt-get update; sudo apt-get upgrade"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.this.email
    scopes = ["cloud-platform"]
  }
}