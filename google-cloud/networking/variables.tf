variable "project_id" {
  description = "The ID of the project in which the resources will be created."
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC network."
  type        = string 
}

variable "region" {
     description = "The region in which the resources will be created."
     type        = string
}