# Create the Linux App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = format("asp-csenergy-%s", local.application)
  location            = azurerm_resource_group.rg_app_services.location
  resource_group_name = azurerm_resource_group.rg_app_services.name
  os_type             = "Linux"
  #sku_name            = "B1"
  # deployment slots supported only on standard and premium service plans
  sku_name            = "S1"
}

# middleware app
resource "azurerm_linux_web_app" "webapp_middleware" {
  name                  = format("webapp-%s-middleware", local.application)
  location              = azurerm_resource_group.rg_app_services.location
  resource_group_name   = azurerm_resource_group.rg_app_services.name
  service_plan_id       = azurerm_service_plan.asp.id
  https_only            = true
  virtual_network_subnet_id = azurerm_subnet.snet_app_services_outbound.id
  site_config { 
    minimum_tls_version = "1.2"
    application_stack {
      java_server = "JAVA"
      java_version = "17"
    }
  }
}

# private endpoint for middleware app service
resource "azurerm_private_endpoint" "middleware_private_endpoint" {
  name                = format("private-link-%s-middleware", local.application)
  location            = azurerm_resource_group.rg_app_services.location
  resource_group_name = azurerm_resource_group.rg_app_services.name
  subnet_id           = azurerm_subnet.snet_app_services_integration.id

#  private_dns_zone_group {
#    name = "privatednszonegroup"
#    private_dns_zone_ids = [azurerm_private_dns_zone.dnsprivatezone.id]
#  }

  private_service_connection {
    name = format("plink-%s-middleware", local.application)
    private_connection_resource_id = azurerm_linux_web_app.webapp_middleware.id
    subresource_names = ["sites"]
    is_manual_connection = false
  }
}

# private endpoint for middleware app service, dev staging slot
resource "azurerm_private_endpoint" "middleware_dev_slot_private_endpoint" {
  name                = format("private-link-%s-middleware-dev", local.application)
  location            = azurerm_resource_group.rg_app_services.location
  resource_group_name = azurerm_resource_group.rg_app_services.name
  subnet_id           = azurerm_subnet.snet_app_services_integration.id

#  private_dns_zone_group {
#    name = "privatednszonegroup"
#    private_dns_zone_ids = [azurerm_private_dns_zone.dnsprivatezone.id]
#  }

  private_service_connection {
    name = format("plink-%s-middleware-dev-slot", local.application)
    private_connection_resource_id = azurerm_linux_web_app.webapp_middleware.id
    subresource_names = ["sites-dev"]
    is_manual_connection = false
  }
}

resource "azurerm_linux_web_app_slot" "slot_middleware_dev" {
  name           = "dev"
  app_service_id = azurerm_linux_web_app.webapp_middleware.id
  virtual_network_subnet_id = azurerm_subnet.snet_app_services_outbound.id
  site_config {}
}

# webtier app
resource "azurerm_linux_web_app" "webapp_webtier" {
  name                  = format("webapp-%s-webtier", local.application)
  location              = azurerm_resource_group.rg_app_services.location
  resource_group_name   = azurerm_resource_group.rg_app_services.name
  service_plan_id       = azurerm_service_plan.asp.id
  https_only            = true
  virtual_network_subnet_id = azurerm_subnet.snet_app_services_outbound.id
  site_config { 
    minimum_tls_version = "1.2"
    application_stack {
      node_version = "18-lts"
    }
  }
}

resource "azurerm_linux_web_app_slot" "slot_webtier_dev" {
  name           = "dev"
  app_service_id = azurerm_linux_web_app.webapp_webtier.id
  virtual_network_subnet_id = azurerm_subnet.snet_app_services_outbound.id
  site_config {}
}
                                                       
# private endpoint for webtier app service
resource "azurerm_private_endpoint" "webtier_private_endpoint" {
  name                = format("private-link-%s-webtier", local.application)
  location            = azurerm_resource_group.rg_app_services.location
  resource_group_name = azurerm_resource_group.rg_app_services.name
  subnet_id           = azurerm_subnet.snet_app_services_integration.id

#  private_dns_zone_group {
#    name = "privatednszonegroup"
#    private_dns_zone_ids = [azurerm_private_dns_zone.dnsprivatezone.id]
#  }

  private_service_connection {
    name = format("plink-%s-webtier", local.application)
    private_connection_resource_id = azurerm_linux_web_app.webapp_webtier.id
    subresource_names = ["sites"]
    is_manual_connection = false
  }
}

# private endpoint for webtier app service, development slot
resource "azurerm_private_endpoint" "webtier_dev_slot_private_endpoint" {
  name                = format("private-link-%s-webtier-dev", local.application)
  location            = azurerm_resource_group.rg_app_services.location
  resource_group_name = azurerm_resource_group.rg_app_services.name
  subnet_id           = azurerm_subnet.snet_app_services_integration.id

#  private_dns_zone_group {
#    name = "privatednszonegroup"
#    private_dns_zone_ids = [azurerm_private_dns_zone.dnsprivatezone.id]
#  }

  private_service_connection {
    name = format("plink-%s-webtier-dev-slot", local.application)
    private_connection_resource_id = azurerm_linux_web_app.webapp_webtier.id
    subresource_names = ["sites-dev"]
    is_manual_connection = false
  }
}

#  Deploy code from a public GitHub repo
#resource "azurerm_app_service_source_control" "sourcecontrol" {
#  app_id             = azurerm_linux_web_app.webapp.id
#  repo_url           = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
#  branch             = "master"
#  use_manual_integration = true
#  use_mercurial      = false
#}
