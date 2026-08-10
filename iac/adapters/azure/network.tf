resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "main" {
  name                = var.network.vnet_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.network.vnet_address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "app_service" {
  name                 = var.network.app_subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.network.app_service_subnet_address_prefix]
}

resource "azurerm_subnet" "database" {
  name                 = var.network.db_subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.network.database_subnet_address_prefix]
  service_endpoints    = ["Microsoft.Sql"]
}
