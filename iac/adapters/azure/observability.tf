resource "azurerm_log_analytics_workspace" "main" {
  name                = var.observability.log_analytics_workspace_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_application_insights" "main" {
  name                = var.observability.app_insights_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.main.id
  tags                = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "app_service" {
  count                      = var.observability.enable_diagnostic_settings ? 1 : 0
  name                       = "diag-${var.compute.app_service_name}"
  target_resource_id         = var.compute.app_service_os_type == "Linux" ? azurerm_linux_web_app.main[0].id : azurerm_windows_web_app.main[0].id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
