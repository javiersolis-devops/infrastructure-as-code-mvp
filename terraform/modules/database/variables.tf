variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "sql_server_name" {
  type = string
}

variable "sql_database_name" {
  type = string
}

variable "sql_vnet_rule_name" {
  type = string
}

variable "sql_database_sku_name" {
  type = string
}

variable "sql_database_max_size_gb" {
  type = number
}

variable "database_subnet_id" {
  type = string
}

variable "sql_admin_username" {
  type = string
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}
