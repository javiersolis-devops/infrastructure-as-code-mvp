variable "project" {
  type = string
}

variable "owner" {
  type = string
}

variable "cost_center" {
  type    = string
  default = "shared"
}

locals {
  common_tags = {
    project      = var.project
    owner        = var.owner
    environment  = var.environment
    cost_center  = var.cost_center
    managed_by   = "terraform"
    architecture = "monolith"
  }
}

output "common_tags" {
  value = local.common_tags
}
