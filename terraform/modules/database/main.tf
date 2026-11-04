# Módulo database: servidor Azure SQL, base de datos y regla de acceso por VNet.

resource "azurerm_mssql_server" "main" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.resource_group_location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"
  tags                         = var.tags
}

resource "azurerm_mssql_database" "main" {
  name        = var.sql_database_name
  server_id   = azurerm_mssql_server.main.id
  sku_name    = var.sql_database_sku_name
  max_size_gb = var.sql_database_max_size_gb
}

resource "azurerm_mssql_virtual_network_rule" "main" {
  name      = var.sql_vnet_rule_name
  server_id = azurerm_mssql_server.main.id
  subnet_id = var.database_subnet_id
}
