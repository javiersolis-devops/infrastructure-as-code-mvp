terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Estado remoto en Azure Storage, configurado por entorno con:
  #   terraform init -reconfigure -backend-config=environments/<entorno>/backend.hcl
  backend "azurerm" {}
}
