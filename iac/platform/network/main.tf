variable "network_contract" {
  type = object({
    vnet_name                         = string
    app_subnet_name                   = string
    db_subnet_name                    = string
    vnet_address_space                = string
    app_service_subnet_address_prefix = string
    database_subnet_address_prefix    = string
  })
}

output "network_contract" {
  value = var.network_contract
}
