resource "azurerm_virtual_network" "vnet_gmf" {
    name                = format("vnet_csenergy_gmf_%s", var.azure_region)
    address_space       = ["10.30.100.0/24"]
    location            = var.azure_region
    resource_group_name = rg_gmf_network.name

    tags = {
      module = "GMF"
      environment = "production"  
    }
}

# Create subnet
resource "azurerm_subnet" "snet_gmf_app_services" {
    name                 = "LabSubnet"
    resource_group_name = "Enter Resource Group Name"
    virtual_network_name = azurerm_virtual_network.TFNet.name
    address_prefixes       = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "tfsubnet2" {
    name                 = "LabSubnet2"
    resource_group_name = "Enter Resource Group Name"
    virtual_network_name = azurerm_virtual_network.TFNet.name
    address_prefixes       = ["10.0.2.0/24"]
}
