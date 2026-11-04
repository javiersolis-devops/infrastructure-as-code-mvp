# Identificación del entorno: debe coincidir con el tfvars aplicado
# (dev, staging o prod) y con la clave de estado del backend.
variable "environment" {
  type = string
}

variable "name_prefix" {
  type    = string
  default = "iacmvp"
}

variable "project" {
  type    = string
  default = "iac-mvp"
}

variable "owner" {
  type    = string
  default = "platform-team"
}

variable "cost_center" {
  type    = string
  default = "engineering"
}

# Política de ubicación
variable "location" {
  type = string

  validation {
    condition     = contains(var.allowed_locations, var.location)
    error_message = "La ubicación seleccionada no está permitida por la política de despliegue."
  }
}

variable "allowed_locations" {
  type    = list(string)
  default = ["eastus", "eastus2", "westus2"]
}

variable "resource_group_name" {
  type = string
}

# Red
variable "vnet_address_space" {
  type = string
}

variable "aks_subnet_address_prefix" {
  type = string
}

variable "database_subnet_address_prefix" {
  type = string
}

# Kubernetes (AKS)
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

variable "aks_sku_tier" {
  type    = string
  default = "Free"
}

# Base de datos
variable "sql_admin_username" {
  type    = string
  default = "sqladminuser"
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "sql_database_sku_name" {
  type = string
}

variable "sql_database_max_size_gb" {
  type = number
}

# Políticas transversales
variable "enable_diagnostic_settings" {
  type    = bool
  default = true
}
