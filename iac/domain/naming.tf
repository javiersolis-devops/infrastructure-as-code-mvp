variable "name_prefix" {
  type = string
}

variable "environment" {
  type = string
}

locals {
  base_name              = "${var.name_prefix}-${var.environment}"
  vnet_name              = "${local.base_name}-vnet"
  app_subnet_name        = "${local.base_name}-snet-app"
  db_subnet_name         = "${local.base_name}-snet-db"
  app_service_name       = "${local.base_name}-app"
  app_service_plan_name  = "${local.base_name}-asp"
  storage_account_name   = lower(replace("${var.name_prefix}${var.environment}sa", "-", ""))
  storage_container_name = "${local.base_name}-container"
  sql_server_name        = "${local.base_name}-sql"
  sql_database_name      = "${local.base_name}-db"
  sql_vnet_rule_name     = "${local.base_name}-sql-vnet-rule"
}

output "naming" {
  value = {
    vnet_name              = local.vnet_name
    app_subnet_name        = local.app_subnet_name
    db_subnet_name         = local.db_subnet_name
    app_service_name       = local.app_service_name
    app_service_plan_name  = local.app_service_plan_name
    storage_account_name   = local.storage_account_name
    storage_container_name = local.storage_container_name
    sql_server_name        = local.sql_server_name
    sql_database_name      = local.sql_database_name
    sql_vnet_rule_name     = local.sql_vnet_rule_name
  }
}
