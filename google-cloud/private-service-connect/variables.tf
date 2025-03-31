locals {
  region              = var.region
  project_id_producer = var.project_id_producer
  project_id_consumer = var.project_id_consumer
}

variable "project_id_producer" {
  description = "Project id name"
}

variable "region" {
  description = "Google cloud region"
}

variable "project_id_consumer" {
  description = "Project id name"
}
