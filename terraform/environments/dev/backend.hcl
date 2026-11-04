# Backend remoto (Azure Storage) para el entorno dev.
# Ajuste los valores marcados con AJUSTAR a su suscripción antes de ejecutar
# terraform init -reconfigure -backend-config=environments/dev/backend.hcl

resource_group_name  = "rg-terraform-state-dev"    # AJUSTAR: grupo de recursos de la cuenta de estado
storage_account_name = "stiacmvpdevstate"          # AJUSTAR: nombre globalmente único (3-24, minúsculas y números)
container_name       = "tfstate"
key                  = "iac-mvp.dev.tfstate"
