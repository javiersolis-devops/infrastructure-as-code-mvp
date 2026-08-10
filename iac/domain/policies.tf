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

variable "enable_diagnostic_settings" {
  type    = bool
  default = true
}

variable "enforce_https_only" {
  type    = bool
  default = true
}

output "policies" {
  value = {
    allowed_locations          = var.allowed_locations
    enable_diagnostic_settings = var.enable_diagnostic_settings
    enforce_https_only         = var.enforce_https_only
  }
}
