resource "azurerm_service_plan" "main" {
  name                = var.compute.app_service_plan_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = var.compute.app_service_os_type
  sku_name            = var.compute.app_service_sku_name
  tags                = var.tags
}

resource "azurerm_linux_web_app" "main" {
  count               = var.compute.app_service_os_type == "Linux" ? 1 : 0
  name                = var.compute.app_service_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = var.enforce_https_only
  tags                = var.tags

  site_config {
    always_on = true
  }
}

resource "azurerm_windows_web_app" "main" {
  count               = var.compute.app_service_os_type == "Windows" ? 1 : 0
  name                = var.compute.app_service_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = var.enforce_https_only
  tags                = var.tags

  site_config {
    always_on = true
  }
}

resource "azurerm_storage_account" "main" {
  name                     = var.compute.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  tags                     = var.tags
}

resource "azurerm_storage_container" "main" {
  name                  = var.compute.storage_container_name
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

resource "azurerm_mssql_server" "main" {
  name                         = var.compute.sql_server_name
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"
  tags                         = var.tags
}

resource "azurerm_mssql_database" "main" {
  name        = var.compute.sql_database_name
  server_id   = azurerm_mssql_server.main.id
  sku_name    = var.compute.sql_database_sku_name
  max_size_gb = var.compute.sql_database_max_size_gb
}

resource "azurerm_mssql_virtual_network_rule" "main" {
  name      = var.compute.sql_vnet_rule_name
  server_id = azurerm_mssql_server.main.id
  subnet_id = azurerm_subnet.database.id
}
