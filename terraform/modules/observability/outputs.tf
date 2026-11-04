output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.main.name
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
}

output "app_insights_name" {
  value = azurerm_application_insights.main.name
}
