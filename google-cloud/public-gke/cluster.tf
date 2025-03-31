
resource "google_container_cluster" "public_gke_cluster" {
  name     = "test-cluster"
  location = var.region

  initial_node_count = 1

  node_config {
    machine_type = "e2-micro"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  network                  = google_compute_network.vpc_network.name
  subnetwork               = google_compute_subnetwork.subnetwork.name
  remove_default_node_pool = false
  deletion_protection      = false
}
