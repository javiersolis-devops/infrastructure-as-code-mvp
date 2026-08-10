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

variable "location" {
  type    = string
  default = "eastus"
}

variable "allowed_locations" {
  type    = list(string)
  default = ["eastus", "eastus2", "westus2"]
}

variable "resource_group_name" {
  type    = string
  default = "iac-mvp-dev-rg"
}

variable "vnet_address_space" {
  type    = string
  default = "10.10.0.0/16"
}

variable "app_service_subnet_address_prefix" {
  type    = string
  default = "10.10.1.0/24"
}

variable "database_subnet_address_prefix" {
  type    = string
  default = "10.10.2.0/24"
}

variable "app_service_os_type" {
  type    = string
  default = "Linux"
}

variable "app_service_sku_name" {
  type    = string
  default = "B1"
}

variable "sql_admin_username" {
  type    = string
  default = "sqladminuser"
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "sql_database_sku_name" {
  type    = string
  default = "S0"
}

variable "sql_database_max_size_gb" {
  type    = number
  default = 10
}

variable "enable_diagnostic_settings" {
  type    = bool
  default = true
}

variable "enforce_https_only" {
  type    = bool
  default = true
}
