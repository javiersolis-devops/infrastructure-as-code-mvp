variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "network" {
  type = object({
    vnet_name                         = string
    app_subnet_name                   = string
    db_subnet_name                    = string
    vnet_address_space                = string
    app_service_subnet_address_prefix = string
    database_subnet_address_prefix    = string
  })
}

variable "compute" {
  type = object({
    app_service_name         = string
    app_service_plan_name    = string
    app_service_os_type      = string
    app_service_sku_name     = string
    storage_account_name     = string
    storage_container_name   = string
    sql_server_name          = string
    sql_database_name        = string
    sql_vnet_rule_name       = string
    sql_database_sku_name    = string
    sql_database_max_size_gb = number
  })
}

variable "observability" {
  type = object({
    log_analytics_workspace_name = string
    app_insights_name            = string
    enable_diagnostic_settings   = bool
  })
}

variable "sql_admin_username" {
  type = string
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "enforce_https_only" {
  type = bool
}
