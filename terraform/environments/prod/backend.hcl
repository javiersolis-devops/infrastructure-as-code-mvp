# Backend remoto (Azure Storage) para el entorno prod.
# Ajuste los valores marcados con AJUSTAR a su suscripción antes de ejecutar
# terraform init -reconfigure -backend-config=environments/prod/backend.hcl

resource_group_name  = "rg-terraform-state-prod"   # AJUSTAR: grupo de recursos de la cuenta de estado
storage_account_name = "stiacmvpprodstate"         # AJUSTAR: nombre globalmente único (3-24, minúsculas y números)
container_name       = "tfstate"
key                  = "iac-mvp.prod.tfstate"
