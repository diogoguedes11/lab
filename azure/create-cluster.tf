resource "azurerm_kubernetes_cluster" "this" {
  name                = "tst-cluster"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.prefix

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }
  network_profile {
    network_plugin     = "azure"
    network_data_plane = "cilium"
  }

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_key_vault" "this" {
  name                     = "tst-keyvaultdeleteme"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Purge"
    ]
  }
  access_policy { # Managed identity
    tenant_id               = data.azurerm_client_config.current.tenant_id
    object_id               = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
    secret_permissions      = ["Get", "List"]
    key_permissions         = ["Get", "List"]
    certificate_permissions = ["Get", "List"]
  }


}



data "azurerm_client_config" "current" {}
