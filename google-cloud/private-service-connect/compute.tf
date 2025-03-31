resource "google_compute_instance" "producer_instance" {
  name         = "producer-instance"
  machine_type = "e2-micro"
  zone         = "${local.region}-a"
  project      = local.project_id_producer
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10
      type  = "pd-standard"
    }
  }
  network_interface {
    network    = google_compute_network.vpc_producer.name
    subnetwork = google_compute_subnetwork.subnetwork_producer.self_link

  }
  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt -y install kubectl
    sudo apt -y install google-cloud-sdk-gke-gcloud-auth-plugin
    EOT
}
resource "google_compute_instance" "consumer_instance" {
  name         = "consumer-instance"
  machine_type = "e2-micro"
  zone         = "${local.region}-a"
  project      = local.project_id_producer
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10
      type  = "pd-standard"
    }
  }
  network_interface {
    network    = google_compute_network.vpc_consumer.name
    subnetwork = google_compute_subnetwork.subnetwork_consumer.self_link

  }
}
resource "google_compute_instance_group" "producer_instance_group" {
  name      = "producer-instance-group"
  project   = local.project_id_producer
  zone      = "${local.region}-a"
  instances = [google_compute_instance.producer_instance.self_link]
}
