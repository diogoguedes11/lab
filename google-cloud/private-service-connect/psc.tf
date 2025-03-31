resource "google_compute_service_attachment" "psc_ilb_service_attachment" {
  name                  = "my-psc-ilb"
  project               = local.project_id_producer
  region                = local.region
  enable_proxy_protocol = true
  connection_preference = "ACCEPT_AUTOMATIC"
  nat_subnets           = [google_compute_subnetwork.psc_ilb_nat.id]
  target_service        = google_compute_forwarding_rule.psc_ilb_target_service.id
}

resource "google_compute_address" "psc_ilb_consumer_address" {
  name         = "psc-ilb-consumer-address"
  region       = local.region
  project      = local.project_id_consumer
  subnetwork   = google_compute_subnetwork.subnetwork_consumer.self_link
  address_type = "INTERNAL"
}

resource "google_compute_forwarding_rule" "psc_ilb_consumer" {
  name                  = "psc-ilb-consumer-forwarding-rule"
  region                = local.region
  project               = local.project_id_consumer
  target                = google_compute_service_attachment.psc_ilb_service_attachment.id
  load_balancing_scheme = "" # need to override EXTERNAL default when target is a service attachment
  network               = google_compute_network.vpc_consumer.name
  ip_address            = google_compute_address.psc_ilb_consumer_address.id
}

resource "google_compute_forwarding_rule" "psc_ilb_target_service" {
  name                  = "producer-forwarding-rule"
  region                = local.region
  project               = local.project_id_producer
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.producer_service_backend.id
  all_ports             = true
  network               = google_compute_network.vpc_producer.name
  subnetwork            = google_compute_subnetwork.subnetwork_producer.name
}

resource "google_compute_region_backend_service" "producer_service_backend" {
  name          = "producer-service"
  region        = local.region
  project       = local.project_id_producer
  health_checks = [google_compute_health_check.producer_service_health_check.id]
}

resource "google_compute_health_check" "producer_service_health_check" {
  name               = "producer-service-health-check"
  project            = local.project_id_producer
  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_subnetwork" "psc_ilb_nat" {
  name          = "psc-ilb-nat"
  region        = local.region
  project       = local.project_id_producer
  network       = google_compute_network.vpc_producer.name
  purpose       = "PRIVATE_SERVICE_CONNECT"
  ip_cidr_range = "10.1.0.0/16"
}
