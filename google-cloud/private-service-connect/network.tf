
resource "google_compute_network" "vpc_producer" {
  name    = "vpc-producer"
  project = local.project_id_producer
}

resource "google_compute_network" "vpc_consumer" {
  name    = "vpc-consumer"
  project = local.project_id_consumer
}


resource "google_compute_subnetwork" "subnetwork_producer" {
  name          = "subnet-producer"
  ip_cidr_range = "10.0.0.0/24"
  region        = local.region
  network       = google_compute_network.vpc_producer.name
  project       = local.project_id_producer

}


resource "google_compute_subnetwork" "subnetwork_consumer" {
  name          = "subnet-consumer"
  ip_cidr_range = "172.0.0.0/24"
  region        = local.region
  network       = google_compute_network.vpc_consumer.name
  project       = local.project_id_consumer
}
