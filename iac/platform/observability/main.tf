variable "observability_contract" {
  type = object({
    log_analytics_workspace_name = string
    app_insights_name            = string
    enable_diagnostic_settings   = bool
  })
}

output "observability_contract" {
  value = var.observability_contract
}
