# ADR 0001: Arquitectura del MVP de Infrastructure as Code

## Contexto
Este proyecto define un MVP de infraestructura como código modular. La intención es separar claramente la lógica de dominio, los adaptadores de proveedor, la plataforma compartida y las configuraciones por entorno. El enfoque debe facilitar la extensibilidad a nuevos proveedores y entornos, y permitir un mantenimiento más simple.

## Decisión
Adoptar una arquitectura de carpetas y responsabilidades explícitas:

- `iac/domain`: reglas, contratos y modelo lógico del dominio.
- `iac/adapters`: integración con proveedores o servicios externos.
- `iac/platform`: infraestructura compartida y capacidades transversales.
- `iac/environments`: configuraciones específicas de entornos (`dev`, `prod`, etc.).

La implementación del MVP también seguirá un flujo de trabajo basado en:

1. Definir el dominio lógico.
2. Exponer recursos compartidos en la plataforma.
3. Conectar con servicios externos mediante adaptadores.
4. Parametrizar y desplegar en los entornos.

## Consecuencias
- Claridad de responsabilidades: cada cambio se ubica donde corresponde.
- Menor acoplamiento: los entornos no deben contener lógica de proveedor ni reglas de dominio.
- Mayor reutilización: la plataforma y el dominio pueden servir a múltiples entornos.
- Escalabilidad: permite agregar nuevos proveedores o entornos con mínimo cambio transversal.
- Necesidad de disciplina: se requiere mantener la separación y evitar duplicaciones.

## Estado Actual de Implementación
El repositorio ya refleja esta estructura y el enfoque de separaciones:

- `iac/domain` contiene contratos y reglas lógicas.
- `iac/adapters/azure` incluye recursos de cómputo, red y observabilidad.
- `iac/platform` agrupa componentes compartidos por la plataforma.
- `iac/environments/dev` y `iac/environments/prod` contienen las configuraciones propias de cada entorno.

El README describe el propósito, la estructura y las reglas de ubicación de cambios.

## Decisiones de Calidad
- Mantener documentación local en cada capa cuando una pieza introduce nuevas reglas o contratos.
- Evitar referencias circulares y duplicación entre módulos.
- Tratar dev y prod como entornos separados con parámetros y variables distintos.
- Documentar outputs, variables y dependencias relevantes a nivel de módulo.
- Priorizar la validación de contratos antes del despliegue.

## Próximos Pasos
1. Crear una convención ADR para futuros cambios arquitectónicos.
2. Añadir pruebas o validaciones automatizadas para las dependencias entre módulos.
3. Revisar y documentar claramente los contratos de `iac/domain` y `iac/adapters`.
4. Evaluar si los componentes de `iac/platform` pueden separarse aún más según su dominio.
5. Incorporar nuevos entornos o proveedores usando esta misma estructura.

## Historial de Cambios
- 2026-08-10: Creación del ADR inicial para la arquitectura del MVP y la separación de responsabilidades.