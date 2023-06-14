resource "azurerm_virtual_network" "vnet_gmf" {
    name                = format("vnet_csenergy_gmf_%s", var.azure_region)
    address_space       = ["10.30.100.0/24"]
    location            = var.azure_region
    resource_group_name = azurerm_resource_group.rg_gmf_network.name

    tags = {
      module = "GMF"
      environment = "production"  
    }
}

# create subnet
resource "azurerm_subnet" "snet_gmf_app_services" {
    name                 = format("snet-csenergy-gmf-app-services-%s", var.azure_region)
    resource_group_name  = azurerm_resource_group.rg_gmf_network.name
    virtual_network_name = azurerm_virtual_network.vnet_gmf.name
    address_prefixes     = ["10.30.100.0/27"]
}


