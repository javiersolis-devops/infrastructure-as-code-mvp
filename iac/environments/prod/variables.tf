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
  default = "eastus2"
}

variable "allowed_locations" {
  type    = list(string)
  default = ["eastus", "eastus2", "westus2"]
}

variable "resource_group_name" {
  type    = string
  default = "iac-mvp-prod-rg"
}

variable "vnet_address_space" {
  type    = string
  default = "10.20.0.0/16"
}

variable "app_service_subnet_address_prefix" {
  type    = string
  default = "10.20.1.0/24"
}

variable "database_subnet_address_prefix" {
  type    = string
  default = "10.20.2.0/24"
}

variable "app_service_os_type" {
  type    = string
  default = "Linux"
}

variable "app_service_sku_name" {
  type    = string
  default = "P1v3"
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
  default = "S1"
}

variable "sql_database_max_size_gb" {
  type    = number
  default = 50
}

variable "enable_diagnostic_settings" {
  type    = bool
  default = true
}

variable "enforce_https_only" {
  type    = bool
  default = true
}
