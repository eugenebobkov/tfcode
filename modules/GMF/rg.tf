resource "azurerm_resource_group" "rg_gmf_network" {
  location = var.azure_region
  name     = format("rg-csenergy-gmf-network-%s", var.azure_region)
}

resource "azurerm_resource_group" "rg_gmf_app_services" {
  location = var.azure_region
  name     = format("rg-csenergy-gmf-app-services-%s", var.azure_region)
}
