# infrastructure-as-code-mvp

## Índice

- [Propósito y valor](#propósito-y-valor)
- [Estructura general](#estructura-general)
- [Flujo](#flujo)
- [Contrato de uso](#contrato-de-uso)
- [Guía de extensión](#guía-de-extensión)
- [¿Dónde modificar en caso de problemas?](#dónde-modificar-en-caso-de-problemas)

## Propósito y valor

Este proyecto organiza la infraestructura como código de forma modular para separar claramente dominio, adaptadores, plataforma y entornos. Su objetivo es facilitar el mantenimiento, la evolución y la validación de la infraestructura sin mezclar responsabilidades.

Valor principal:

- separa responsabilidades por capa
- reduce acoplamiento entre recursos, dominio y proveedores
- facilita extender el proyecto por proveedor o por entorno
- mejora la trazabilidad de cambios en infraestructura
- permite documentar contratos claros entre piezas del sistema

## Estructura general

La organización esencial del proyecto es la siguiente:

- `iac/domain`: reglas, contratos y modelo lógico del dominio
- `iac/adapters`: integración con proveedores o servicios externos
- `iac/platform`: infraestructura compartida y capacidades transversales
- `iac/environments/dev`: configuración del entorno de desarrollo
- `iac/environments/prod`: configuración del entorno de producción

Regla práctica de ubicación:

- si define reglas o modelos lógicos, va en `domain`
- si integra con un proveedor, va en `adapters`
- si es infraestructura compartida, va en `platform`
- si cambia según el entorno, va en `environments`

## Flujo

Flujo general del proyecto:

1. El dominio define el contrato lógico.
2. La plataforma expone recursos compartidos.
3. Los adaptadores conectan con servicios externos.
4. Los entornos combinan y parametrizan los módulos.
5. El despliegue aplica la configuración al entorno objetivo.

Flujo típico de trabajo:

```text
cambio en dominio/plataforma/adaptador -> ajuste de entorno -> validación -> despliegue
```

## Contrato de uso

Para trabajar con este proyecto, conviene respetar estas reglas:

- mantener cada cambio en la capa correcta
- no mezclar lógica de negocio con detalles de infraestructura
- no duplicar configuraciones que deban ser compartidas
- evitar referencias circulares entre módulos
- documentar outputs, variables y dependencias relevantes
- tratar dev y prod como entornos distintos con contratos propios

Entrada esperada:

- definiciones de recursos
- contratos de dominio
- parámetros de entorno
- referencias a módulos o proveedores

Salida esperada:

- infraestructura organizada por capas
- contratos reutilizables
- despliegues consistentes por entorno
- errores de validación o referencia cuando algo esté mal definido

## Guía de extensión

Si vas a agregar algo nuevo al proyecto:

1. Identifica primero si es dominio, adaptador, plataforma o entorno.
2. Coloca el cambio en la carpeta más cercana a su responsabilidad real.
3. Expón solo los contratos necesarios.
4. Evita duplicar lógica entre entornos o proveedores.
5. Agrega documentación local en la carpeta afectada si el cambio introduce nuevas reglas.
6. Revisa el impacto sobre referencias, outputs y validaciones.

Cuándo crear una nueva carpeta:

- cuando aparezca un nuevo proveedor de nube con reglas propias
- cuando exista un entorno adicional con configuración distinta
- cuando una capacidad transversal crezca lo suficiente para separarse
- cuando el modelo del dominio requiera dividirse por áreas claras

## ¿Dónde modificar en caso de problemas?

Si algo falla, revisa en este orden:

1. Contratos y referencias entre módulos
2. Variables de entorno y parámetros de despliegue
3. Salidas expuestas por plataforma o adaptadores
4. Reglas y validaciones del dominio
5. Configuración específica del entorno afectado

Puntos típicos a tocar:

- `iac/domain` si el problema es de modelo o validación
- `iac/adapters` si el problema es de integración externa
- `iac/platform` si el problema es de recursos compartidos
- `iac/environments/dev` o `iac/environments/prod` si el problema depende del entorno

Si el problema está en un comportamiento específico, modifica primero el punto más cercano a la causa:

- referencia rota -> contrato o output faltante
- valor incorrecto -> variable de entorno o parámetro
- integración fallida -> adaptador o credenciales
- regla mal aplicada -> dominio
