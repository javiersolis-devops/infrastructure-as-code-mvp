variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "cluster_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

# Nulo usa la versión por defecto soportada por AKS en la región.
variable "kubernetes_version" {
  type    = string
  default = null
}

variable "system_node_count" {
  type = number
}

variable "system_node_vm_size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "sku_tier" {
  type    = string
  default = "Free"

  validation {
    condition     = contains(["Free", "Standard"], var.sku_tier)
    error_message = "sku_tier debe ser 'Free' o 'Standard'."
  }
}

variable "system_subnet_id" {
  type = string
}

# Identificador del área de trabajo de Log Analytics; nulo desactiva el agente OMS.
variable "log_analytics_workspace_id" {
  type    = string
  default = null
}

variable "enable_diagnostic_settings" {
  type    = bool
  default = true
}
