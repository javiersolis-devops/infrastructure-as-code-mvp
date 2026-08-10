output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.main.name
}

output "app_service_name" {
  value = var.compute.app_service_os_type == "Linux" ? azurerm_linux_web_app.main[0].name : azurerm_windows_web_app.main[0].name
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "sql_server_name" {
  value = azurerm_mssql_server.main.name
}

output "sql_database_name" {
  value = azurerm_mssql_database.main.name
}
