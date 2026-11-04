# ADR 0003: Configuración por entorno agrupada y módulo de Kubernetes

## Contexto
Tras la migración al layout modular clásico (ADR 0002), la configuración de entornos vivía repartida en dos carpetas paralelas (`terraform/vars/` para tfvars y `terraform/backend/` para tfbackend), la capa de cómputo era App Service (mapeo provisional del "eks" original) y el bloque `terraform` convivía con la composición en `main.tf`.

Se decide refinar la estructura hacia el patrón de referencia: módulos `networking`, `database` y `kubernetes`, carpetas `environments/<entorno>/` que agrupan todo lo propio de cada entorno, y `versions.tf` separado. Se conserva Azure como proveedor (`azurerm`).

## Decisión
- `modules/vnet` pasa a llamarse `modules/networking`; su subred de aplicación se convierte en subred dedicada de AKS (`-snet-aks`).
- `modules/appservice` (plan de App Service, web apps y cuenta de almacenamiento) se elimina; la capa de cómputo pasa a ser `modules/kubernetes`: clúster AKS con node pool de sistema, identidad asignada por el sistema, red plugin `azure` e integración opcional con Log Analytics (`oms_agent`) y diagnósticos.
- El diagnostic setting se movió de `observability` a `kubernetes`: el clúster conoce su propio identificador y así el grafo queda sin ciclos (`kubernetes` consume `networking` y `observability`; nadie consume `kubernetes`).
- `vars/` y `backend/` se agrupan en `environments/<entorno>/` con `terraform.tfvars` y `backend.hcl` por entorno (dev, staging, prod).
- El bloque `terraform` (versiones, proveedor requerido y backend) se traslada a `versions.tf`; `main.tf` queda solo con provider, convenciones y composición.
- Variables retiradas por obsoletas: `app_service_*`, `enforce_https_only`; variables nuevas de AKS: `kubernetes_version`, `system_node_count`, `system_node_vm_size`, `aks_sku_tier`.

## Consecuencias
- Todo lo propio de un entorno está en una sola carpeta; incorporar un entorno es copiarla y ajustarla.
- El cómputo es Kubernetes administrado (AKS): el despliegue de aplicaciones pasará a ser vía manifiestos/Helm, no App Service.
- La cuenta de almacenamiento y las web apps desaparecen de los despliegues; su historial queda en git y en ADR 0002.
- `terraform.tfvars` sigue excluido del repositorio por contener secretos; `backend.hcl` se versiona (sin secretos, con marcadores `AJUSTAR`).

## Estado Actual de Implementación
La estructura quedó implementada y validada con `terraform fmt -check -recursive` y `terraform validate` (Terraform 1.15.8, provider `azurerm ~> 4.0`). El `.terraform.lock.hcl` se mantiene en `terraform/`.

## Próximos Pasos
1. Ajustar `environments/<entorno>/backend.hcl` con los datos reales de las cuentas de estado.
2. Definir el mecanismo de inyección de secretos (pipeline o almacén) para `sql_admin_password`.
3. Evaluar identidad de usuario asignada y DNS privado si el clúster pasa a privado.

## Historial de Cambios
- 2026-11-04: Creación del ADR al agrupar la configuración en `environments/`, renombrar `networking`, introducir `kubernetes` (AKS) y separar `versions.tf`.
