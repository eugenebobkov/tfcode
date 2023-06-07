resource "azurerm_resource_group" "gmf_rg_network" {
  location = var.azure_region
  name     = "fg-gmf-network-australiasoutheast"
}

resource "azurerm_resource_group" "gmf_rg_app_services" {
  location = var.azure_region
  name     = "fg-gmf-app-services-australiasoutheast"
}
