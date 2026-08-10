variable "compute_contract" {
  type = object({
    app_service_name       = string
    app_service_plan_name  = string
    app_service_os_type    = string
    app_service_sku_name   = string
    storage_account_name   = string
    storage_container_name = string
    sql_server_name        = string
    sql_database_name      = string
    sql_vnet_rule_name     = string
    sql_database_sku_name  = string
    sql_database_max_size_gb = number
  })
}

output "compute_contract" {
  value = var.compute_contract
}
