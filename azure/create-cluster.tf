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

output "kube_config" {
  value = azurerm_kubernetes_cluster.this.kube_config_raw

  sensitive = true
}
