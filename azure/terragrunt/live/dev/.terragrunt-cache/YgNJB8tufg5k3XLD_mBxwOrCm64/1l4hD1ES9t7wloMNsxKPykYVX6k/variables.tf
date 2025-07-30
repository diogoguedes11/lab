variable "prefix" {
  default = "tst"
}
variable "subscription_id" {
  description = "The subscription id"
}

variable "resource_group_name" {
  description = "The name of the resource group"
}

variable "location" {
  description = "The Azure region where resources will be created"
  default     = "westeurope"
}
