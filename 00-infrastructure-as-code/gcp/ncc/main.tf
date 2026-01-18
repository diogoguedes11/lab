resource "google_network_connectivity_hub" "hub" {
  name        = "star"
  description = "A sample star hub"
  labels = {
    label-one = "value-one"
  }
  preset_topology = "STAR"
}

# Spoke1
resource "google_compute_network" "vpc_spoke1" {
  name                    = "vpc-spoke1"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "subnet_spoke1" {
  name          = "sb-spoke1"
  network       = google_compute_network.vpc_spoke1.name
  ip_cidr_range = "10.0.0.0/24"
  depends_on    = [google_compute_network.vpc_spoke1]
}

resource "google_network_connectivity_spoke" "spoke1" {
  name     = "spoke1"
  hub      = google_network_connectivity_hub.hub.name
  location = "global"
  linked_vpc_network {
    uri = google_compute_network.vpc_spoke1.self_link
  }

  group = google_network_connectivity_group.ncc_group.id
}

# Spoke 2
resource "google_compute_network" "vpc_spoke2" {
  name                    = "vpc-spoke2"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "subnet_spoke2" {
  name          = "sb-spoke2"
  network       = google_compute_network.vpc_spoke2.name
  ip_cidr_range = "10.0.1.0/24"
  depends_on    = [google_compute_network.vpc_spoke2]
}
# Groups helps manage the spokes and apply policies to them
resource "google_network_connectivity_group" "ncc_group" {
  hub         = google_network_connectivity_hub.hub.name
  name        = "center"
  description = "center hub group"
  auto_accept {
    auto_accept_projects = [
      var.project_id
    ]
  }
}
resource "google_network_connectivity_spoke" "spoke2" {
  name     = "spoke2"
  hub      = google_network_connectivity_hub.hub.name
  location = "global"
  linked_vpc_network {
    uri = google_compute_network.vpc_spoke2.self_link
  }
  group = google_network_connectivity_group.ncc_group.id
}
