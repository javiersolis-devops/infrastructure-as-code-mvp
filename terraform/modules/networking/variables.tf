variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = string
}

variable "aks_subnet_name" {
  type = string
}

variable "aks_subnet_address_prefix" {
  type = string
}

variable "database_subnet_name" {
  type = string
}

variable "database_subnet_address_prefix" {
  type = string
}
