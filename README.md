# infrastructure-as-code-mvp

## Índice

- [Propósito y valor](#propósito-y-valor)
- [Estructura general](#estructura-general)
- [Flujo](#flujo)
- [Contrato de uso](#contrato-de-uso)
- [Guía de extensión](#guía-de-extensión)
- [¿Dónde modificar en caso de problemas?](#dónde-modificar-en-caso-de-problemas)

## Propósito y valor

Este proyecto organiza la infraestructura como código de forma modular sobre el proveedor **Azure** (provider `azurerm`). Sigue el patrón clásico de Terraform: una raíz única que compone módulos reutilizables, con configuración y estado separados por entorno.

Valor principal:

- una sola raíz de Terraform para todos los entornos
- módulos pequeños con contratos explícitos (variables y outputs)
- configuración por entorno aislada en `environments/<entorno>/`
- estado remoto por entorno en Azure Storage
- facilita extender el proyecto con nuevos módulos o entornos
- mejora la trazabilidad de cambios en infraestructura

## Estructura general

```text
terraform/
├── modules/
│   ├── networking/     # grupo de recursos, red virtual y subredes (AKS y base de datos)
│   ├── database/       # servidor Azure SQL, base de datos y regla de VNet
│   ├── kubernetes/     # clúster AKS con node pool de sistema e integración con Log Analytics
│   └── observability/  # Log Analytics y Application Insights
│
├── environments/
│   ├── dev/
│   │   ├── terraform.tfvars   # valores del entorno (contiene secretos; fuera de git)
│   │   └── backend.hcl        # estado remoto del entorno
│   ├── staging/
│   │   ├── terraform.tfvars
│   │   └── backend.hcl
│   └── prod/
│       ├── terraform.tfvars
│       └── backend.hcl
│
├── main.tf             # provider, convenciones de nombres y tags, composición de módulos
├── variables.tf        # variables de entrada y sus validaciones
├── outputs.tf          # salidas del despliegue
└── versions.tf         # versión de Terraform, proveedor requerido y backend
```

Responsabilidades:

- `modules/*`: recursos de Azure agrupados por capacidad; solo exponen variables y outputs. `kubernetes` depende de `networking` (subred) y de `observability` (workspace); nunca al revés.
- `main.tf`: convenciones de nombres y etiquetas, y cableado entre módulos.
- `versions.tf`: bloque `terraform` con `required_version`, `required_providers` y `backend "azurerm" {}`.
- `environments/<entorno>/terraform.tfvars`: valores del entorno. Contienen secretos, por lo que `*.tfvars` está excluido del repositorio por `.gitignore`; cada persona mantiene sus copias locales.
- `environments/<entorno>/backend.hcl`: configuración del estado remoto; ajustar los valores marcados con `AJUSTAR` a la suscripción destino.

## Flujo

Cada operación se ejecuta desde `terraform/` indicando el entorno objetivo.

Inicialización (estado remoto por entorno):

```bash
terraform init -reconfigure -backend-config=environments/dev/backend.hcl
```

Despliegue por entorno:

```bash
terraform plan  -var-file=environments/dev/terraform.tfvars -out=tfplan
terraform apply tfplan
```

Flujo típico de trabajo:

```text
ajuste en módulo o raíz -> terraform fmt -> terraform validate -> plan con el tfvars del entorno -> apply
```

Entre entornos, use `-reconfigure` en el `init` para apuntar al backend correspondiente.

## Contrato de uso

Para trabajar con este proyecto, conviene respetar estas reglas:

- los módulos no conocen el entorno: lo reciben como variables
- no duplicar convenciones de nombres: se calculan en `main.tf` y se pasan a los módulos
- no introducir recursos de un módulo dentro de otro; el cableado vive en la raíz
- mantener el grafo de dependencias sin ciclos: `observability` y `networking` no consumen salidas de `kubernetes`
- no subir secretos al repositorio: van en `environments/*/terraform.tfvars` (ignorado por git) o en un almacén de secretos
- mantener un `terraform.tfvars` y un `backend.hcl` por entorno
- documentar outputs, variables y dependencias relevantes de cada módulo

Entrada esperada:

- variables declaradas en `variables.tf` y valores en `environments/<entorno>/terraform.tfvars`
- backend configurado en `environments/<entorno>/backend.hcl`
- credenciales de Azure disponibles para el provider `azurerm`

Salida esperada:

- infraestructura Azure consistente por entorno
- outputs reutilizables para otros sistemas
- errores de validación o referencia cuando algo esté mal definido

## Guía de extensión

Si vas a agregar algo nuevo al proyecto:

1. Identifica si es un nuevo recurso dentro de un módulo existente o un módulo nuevo.
2. Expón solo las variables necesarias; usa tipos específicos y validaciones.
3. Conecta el módulo desde `main.tf`; no crees dependencias entre módulos hermanos.
4. Añade los valores nuevos a los `terraform.tfvars` de los entornos afectados.
5. Agrega documentación local en el módulo si el cambio introduce nuevas reglas.
6. Revisa el impacto sobre referencias, outputs y validaciones.

Cuándo crear un nuevo módulo:

- cuando una capacidad crezca lo suficiente para separarse de su módulo actual
- cuando aparezca un recurso con ciclo de vida o permisos propios
- cuando se necesite reutilizar un conjunto de recursos en otro contexto

## ¿Dónde modificar en caso de problemas?

Si algo falla, revisa en este orden:

1. Referencias y outputs entre módulos y la raíz
2. Valores de `environments/<entorno>/terraform.tfvars` y su correspondencia con `variables.tf`
3. Configuración de `environments/<entorno>/backend.hcl` y credenciales de Azure
4. Validaciones de variables (ubicación permitida, nivel de SKU, etc.)
5. Recurso específico dentro del módulo afectado

Puntos típicos a tocar:

- `terraform/main.tf` si el problema es de composición, nombres o etiquetas
- `terraform/versions.tf` si el problema es de versiones, proveedor o backend
- `terraform/variables.tf` si falta una variable o una validación
- `terraform/environments/<entorno>/` si el problema depende del entorno
- `terraform/modules/<módulo>` si el problema es de un recurso concreto

Si el problema está en un comportamiento específico, modifica primero el punto más cercano a la causa:

- referencia rota -> output faltante en el módulo productor
- valor incorrecto -> variable en `environments/<entorno>/terraform.tfvars`
- error de estado -> `backend.hcl` del entorno y autenticación
- recurso mal creado -> módulo correspondiente
