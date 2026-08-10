module "domain" {
  source                     = "../../domain"
  name_prefix                = var.name_prefix
  environment                = "dev"
  project                    = var.project
  owner                      = var.owner
  cost_center                = var.cost_center
  location                   = var.location
  allowed_locations          = var.allowed_locations
  enable_diagnostic_settings = var.enable_diagnostic_settings
  enforce_https_only         = var.enforce_https_only
}

module "platform_network" {
  source = "../../platform/network"

  network_contract = {
    vnet_name                         = module.domain.naming.vnet_name
    app_subnet_name                   = module.domain.naming.app_subnet_name
    db_subnet_name                    = module.domain.naming.db_subnet_name
    vnet_address_space                = var.vnet_address_space
    app_service_subnet_address_prefix = var.app_service_subnet_address_prefix
    database_subnet_address_prefix    = var.database_subnet_address_prefix
  }
}

module "platform_compute" {
  source = "../../platform/compute"

  compute_contract = {
    app_service_name         = module.domain.naming.app_service_name
    app_service_plan_name    = module.domain.naming.app_service_plan_name
    app_service_os_type      = var.app_service_os_type
    app_service_sku_name     = var.app_service_sku_name
    storage_account_name     = module.domain.naming.storage_account_name
    storage_container_name   = module.domain.naming.storage_container_name
    sql_server_name          = module.domain.naming.sql_server_name
    sql_database_name        = module.domain.naming.sql_database_name
    sql_vnet_rule_name       = module.domain.naming.sql_vnet_rule_name
    sql_database_sku_name    = var.sql_database_sku_name
    sql_database_max_size_gb = var.sql_database_max_size_gb
  }
}

module "platform_observability" {
  source = "../../platform/observability"

  observability_contract = {
    log_analytics_workspace_name = "${var.name_prefix}-dev-law"
    app_insights_name            = "${var.name_prefix}-dev-ai"
    enable_diagnostic_settings   = module.domain.policies.enable_diagnostic_settings
  }
}

module "azure" {
  source = "../../adapters/azure"

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = module.domain.common_tags
  network             = module.platform_network.network_contract
  compute             = module.platform_compute.compute_contract
  observability       = module.platform_observability.observability_contract
  sql_admin_username  = var.sql_admin_username
  sql_admin_password  = var.sql_admin_password
  enforce_https_only  = module.domain.policies.enforce_https_only
}
