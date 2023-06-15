# Create the Linux App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = format("asp-csenergy-%s", local.application)
  location            = azurerm_resource_group.rg_app_services.location
  resource_group_name = azurerm_resource_group.rg_app_services.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp_middleware" {
  name                  = format("webapp-%s-middleware", local.application)
  location              = azurerm_resource_group.rg_app_services.location
  resource_group_name   = azurerm_resource_group.rg_app_services.name
  service_plan_id       = azurerm_service_plan.asp.id
  https_only            = true
  virtual_network_subnet_id = azurerm_subnet.snet_app_services.id
  site_config { 
    minimum_tls_version = "1.2"
    application_stack {
      java_server = "JAVA"
      java_version = "17"
    }
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection" {
  app_service_id  = azurerm_windows_web_app.webapp_middleware.id
  subnet_id       = azurerm_subnet.snet_app_services.id
}

#  Deploy code from a public GitHub repo
#resource "azurerm_app_service_source_control" "sourcecontrol" {
#  app_id             = azurerm_linux_web_app.webapp.id
#  repo_url           = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
#  branch             = "master"
#  use_manual_integration = true
#  use_mercurial      = false
#}
