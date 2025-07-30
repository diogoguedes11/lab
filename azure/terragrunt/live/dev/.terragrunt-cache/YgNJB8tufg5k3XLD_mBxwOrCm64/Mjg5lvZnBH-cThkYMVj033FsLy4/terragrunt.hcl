terraform {
  source = "../modules/cluster.tf"
}

inputs = {
  location            = "westeurope"
  resource_group_name = "my-rg"
  prefix              = "dev"
}