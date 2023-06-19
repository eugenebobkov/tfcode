resource "azurerm_resource_group" "rg_network" {
  location = var.azure_region
  name     = format("rg-%s-network-%s", local.application, var.azure_region)
}

resource "azurerm_resource_group" "rg_app_services" {
  location = var.azure_region
  name     = format("rg-%s-app-services-%s", local.application, var.azure_region)
}
