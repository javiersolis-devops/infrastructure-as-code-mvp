# ADR 0002: Migración a estructura modular clásica de Terraform

## Contexto
El MVP original (ADR 0001) organizaba el código en un estilo hexagonal: `iac/domain` (reglas y convenciones), `iac/adapters/azure` (recursos), `iac/platform` (contratos pasabanté) e `iac/environments/<entorno>` (raíces completas duplicadas por entorno). Eso implicaba mantener configuraciones repetidas por entorno y una capa de contratos que solo reenviaba tipos.

Se requiere adoptar la estructura canónica de Terraform con raíz única, módulos reutilizables, variables por entorno y backend remoto por entorno, conservando Azure como proveedor (`azurerm`).

## Decisión
Reorganizar el proyecto en `terraform/` con el siguiente layout:

- `terraform/modules/vnet`: grupo de recursos, red virtual y subredes (equivalente Azure del clásico "vpc").
- `terraform/modules/appservice`: plan de App Service, web app y cuenta de almacenamiento.
- `terraform/modules/database`: servidor Azure SQL, base de datos y regla de VNet.
- `terraform/modules/observability`: Log Analytics, Application Insights y diagnósticos.
- `terraform/main.tf`: bloque `terraform` (versiones, provider y `backend "azurerm" {}`), convenciones de nombres y etiquetas (antes `iac/domain/naming.tf` y `tags.tf`), y composición de módulos.
- `terraform/variables.tf`: variables de entrada con validaciones (antes `iac/domain/policies.tf`).
- `terraform/outputs.tf`: salidas del despliegue.
- `terraform/vars/{dev,staging,prod}.tfvars`: valores por entorno; excluidos del repositorio por `.gitignore` por contener secretos.
- `terraform/backend/{dev,staging,prod}.tfbackend`: estado remoto en Azure Storage por entorno, aplicado con `terraform init -backend-config`.

Se elimina el árbol `iac/`: su contenido queda preservado en el historial de git y su funcionalidad se mapea completa a la nueva estructura. Los módulos pasabanté de `iac/platform` desaparecen: los tipos de contrato ahora viven en las variables de cada módulo. Se añade el entorno `staging`, que no existía.

## Consecuencias
- Una sola raíz: los cambios se hacen una vez y se aplican por entorno con `-var-file` y `-backend-config`.
- Menos duplicación: desaparecen las raíces gemelas por entorno y la capa de contratos reenviadores.
- Los módulos dejan de conocer el entorno; solo reciben variables.
- Los nombres y etiquetas se centralizan en `main.tf`; cambiar una convención es un cambio único.
- Los valores de `backend/*.tfbackend` deben ajustarse a la suscripción destino antes del primer `init`.
- `vars/*.tfvars` son locales: quien incorpora secretos nuevos debe documentar la variable y su manejo.

## Estado Actual de Implementación
La estructura `terraform/` está creada y validada con `terraform fmt` y `terraform validate` (Terraform 1.15.8, provider `azurerm ~> 4.0` fijado por `.terraform.lock.hcl`). El archivo de bloqueo se trasladó a la nueva raíz. El README describe la estructura y el flujo de despliegue por entorno.

## Próximos Pasos
1. Ajustar `backend/*.tfbackend` con los datos reales de las cuentas de almacenamiento de estado.
2. Definir el mecanismo de inyección de secretos (pipeline o almacén) para `sql_admin_password`.
3. Añadir validaciones automatizadas (fmt/validate) en CI.

## Historial de Cambios
- 2026-11-04: Creación del ADR al migrar de `iac/` (estilo hexagonal) a `terraform/` (módulos clásicos, raíz única, vars y backend por entorno).
