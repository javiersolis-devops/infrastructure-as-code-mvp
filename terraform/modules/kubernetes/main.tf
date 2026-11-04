# Módulo kubernetes: clúster administrado de Azure Kubernetes Service (AKS).
# Usa la subred de AKS expuesta por el módulo networking y, opcionalmente,
# envía logs a Log Analytics (oms_agent).

# Con identidad asignada por el sistema, AKS otorga automáticamente los
# permisos de red necesarios sobre la subred indicada.

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  sku_tier            = var.sku_tier
  tags                = var.tags

  default_node_pool {
    name           = "system"
    node_count     = var.system_node_count
    vm_size        = var.system_node_vm_size
    vnet_subnet_id = var.system_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }

  dynamic "oms_agent" {
    for_each = var.log_analytics_workspace_id != null ? [var.log_analytics_workspace_id] : []
    content {
      log_analytics_workspace_id = oms_agent.value
    }
  }
}

# Diagnósticos del clúster hacia Log Analytics (requiere workspace configurado).
resource "azurerm_monitor_diagnostic_setting" "cluster" {
  count = var.enable_diagnostic_settings && var.log_analytics_workspace_id != null ? 1 : 0

  name                       = "diag-${var.cluster_name}"
  target_resource_id         = azurerm_kubernetes_cluster.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "kube-audit-admin"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
