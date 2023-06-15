resource "azurerm_virtual_network" "vnet" {
    name                = format("vnet_csenergy_%s_%s", local.application, var.azure_region)
    address_space       = ["10.30.100.0/24"]
    location            = var.azure_region
    resource_group_name = azurerm_resource_group.rg_network.name

    tags = {
      module = format("%s", local.application)
      environment = "production"  
    }
}

# create integration subnet, inbound endpoints for app services will be located here
# delegation is not required
resource "azurerm_subnet" "snet_app_services_integration" {
    name                 = format("snet-csenergy-%s-app-services-integration-%s", local.application, var.azure_region)
    resource_group_name  = azurerm_resource_group.rg_network.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.30.100.0/27"]
    # To be conf
    private_endpoint_network_policies_enabled = true
}

# create outbound subnet for vnet integration
resource "azurerm_subnet" "snet_app_services_outbound" {
    name                 = format("snet-csenergy-%s-app-services-outbound-%s", local.application, var.azure_region)
    resource_group_name  = azurerm_resource_group.rg_network.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.30.100.32/27"]
    # To be conf
    private_endpoint_network_policies_enabled = true
    delegation {
       name = "Microsoft.Web"
       service_delegation {
         actions = [
           "Microsoft.Network/virtualNetworks/subnets/action",
         ]
         name = "Microsoft.Web/serverFarms"
       }
  }
}


# create peering
#resource "azurerm_virtual_network_peering" "peer_vnet_csenergy_vpn" {
#  name                         = "peer-vnet-csenergy-vpn"
#  resource_group_name          = azurerm_resource_group.rg_gmf_network.name
#   virtual_network_name         = azurerm_virtual_network.vnet_gmf.name
#   remote_virtual_network_id    = var.vnet_csenergy_vpn_id
#   allow_virtual_network_access = true
# }
