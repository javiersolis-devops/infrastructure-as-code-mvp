provider "azurerm" {
  features {}
}

# --------------------------------------------------------------------------
# Convenciones de nombres y etiquetas
# --------------------------------------------------------------------------

locals {
  base_name = "${var.name_prefix}-${var.environment}"

  vnet_name          = "${local.base_name}-vnet"
  aks_subnet_name    = "${local.base_name}-snet-aks"
  db_subnet_name     = "${local.base_name}-snet-db"
  aks_cluster_name   = "${local.base_name}-aks"
  dns_prefix         = lower(local.base_name)
  sql_server_name    = "${local.base_name}-sql"
  sql_database_name  = "${local.base_name}-db"
  sql_vnet_rule_name = "${local.base_name}-sql-vnet-rule"
  law_name           = "${var.name_prefix}-${var.environment}-law"
  ai_name            = "${var.name_prefix}-${var.environment}-ai"

  common_tags = {
    project      = var.project
    owner        = var.owner
    environment  = var.environment
    cost_center  = var.cost_center
    managed_by   = "terraform"
    architecture = "monolith"
  }
}

# --------------------------------------------------------------------------
# Módulos
# --------------------------------------------------------------------------

module "networking" {
  source = "./modules/networking"

  resource_group_name            = var.resource_group_name
  location                       = var.location
  tags                           = local.common_tags
  vnet_name                      = local.vnet_name
  vnet_address_space             = var.vnet_address_space
  aks_subnet_name                = local.aks_subnet_name
  aks_subnet_address_prefix      = var.aks_subnet_address_prefix
  database_subnet_name           = local.db_subnet_name
  database_subnet_address_prefix = var.database_subnet_address_prefix
}

module "kubernetes" {
  source = "./modules/kubernetes"

  resource_group_name        = module.networking.resource_group_name
  resource_group_location    = module.networking.resource_group_location
  tags                       = local.common_tags
  cluster_name               = local.aks_cluster_name
  dns_prefix                 = local.dns_prefix
  kubernetes_version         = var.kubernetes_version
  system_node_count          = var.system_node_count
  system_node_vm_size        = var.system_node_vm_size
  sku_tier                   = var.aks_sku_tier
  system_subnet_id           = module.networking.aks_subnet_id
  log_analytics_workspace_id = module.observability.log_analytics_workspace_id
  enable_diagnostic_settings = var.enable_diagnostic_settings
}

module "database" {
  source = "./modules/database"

  resource_group_name      = module.networking.resource_group_name
  resource_group_location  = module.networking.resource_group_location
  tags                     = local.common_tags
  sql_server_name          = local.sql_server_name
  sql_database_name        = local.sql_database_name
  sql_vnet_rule_name       = local.sql_vnet_rule_name
  sql_database_sku_name    = var.sql_database_sku_name
  sql_database_max_size_gb = var.sql_database_max_size_gb
  database_subnet_id       = module.networking.database_subnet_id
  sql_admin_username       = var.sql_admin_username
  sql_admin_password       = var.sql_admin_password
}

module "observability" {
  source = "./modules/observability"

  resource_group_name          = module.networking.resource_group_name
  resource_group_location      = module.networking.resource_group_location
  tags                         = local.common_tags
  log_analytics_workspace_name = local.law_name
  app_insights_name            = local.ai_name
}
