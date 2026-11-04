output "resource_group_name" {
  value = module.networking.resource_group_name
}

output "virtual_network_name" {
  value = module.networking.vnet_name
}

output "kubernetes_cluster_name" {
  value = module.kubernetes.cluster_name
}

output "kubernetes_cluster_fqdn" {
  value = module.kubernetes.cluster_fqdn
}

output "kubernetes_node_resource_group" {
  value = module.kubernetes.node_resource_group
}

output "sql_server_name" {
  value = module.database.sql_server_name
}

output "sql_server_fqdn" {
  value = module.database.sql_server_fqdn
}

output "sql_database_name" {
  value = module.database.sql_database_name
}

output "log_analytics_workspace_name" {
  value = module.observability.log_analytics_workspace_name
}

output "app_insights_name" {
  value = module.observability.app_insights_name
}
