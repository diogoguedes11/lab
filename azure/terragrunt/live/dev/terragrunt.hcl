terraform {
  source = "../modules/aks-cluster"
}

inputs = {
  location            = "westeurope"
  resource_group_name = "my-rg"
  prefix              = "dev"
}

# remote_state {
#   backend = "azurerm"
#   config = {
#     resource_group_name  = "my-rg"
#     storage_account_name = "mytfstate"
#     container_name       = "tfstate"
#     key                  = "dev.terraform.tfstate"
#   }
# }