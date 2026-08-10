# Ambientes - Produccion
## Propósito y valor

`iac/environments/prod` define la configuración del entorno de producción para la infraestructura como código. Su objetivo es desplegar recursos estables, seguros y controlados para soportar el uso real del sistema.

Valor principal:
- separa producción de los demás entornos
- reduce el riesgo de cambios no validados
- permite aplicar controles más estrictos
- centraliza la configuración crítica del entorno productivo

## Alcance del servicio

Este entorno cubre únicamente la configuración necesaria para producción.

Incluye normalmente:
- variables y parámetros específicos de prod
- tamaños, réplicas y capacidades apropiadas para carga real
- referencias a recursos estables y duraderos
- configuraciones de seguridad, resiliencia y observabilidad
- valores que deben mantenerse consistentes entre despliegues

No incluye:
- configuraciones temporales o de prueba
- ajustes orientados solo a desarrollo
- secretos incrustados en el código
- lógica de negocio
- duplicación innecesaria de parámetros comunes

## Flujo

Flujo general de uso:

1. Se define la configuración de producción.
2. La capa de IaC lee los valores del entorno prod.
3. Se construyen los recursos o módulos con parámetros productivos.
4. Se valida el despliegue con controles más estrictos.
5. Se aplica el cambio de forma controlada en producción.

Flujo típico de ejecución:

```text
Configuración prod -> plantillas/módulos IaC -> validación estricta -> despliegue productivo
```

## Contrato de uso

Para usar este entorno, el consumidor debe respetar estas reglas:

- no asumir que prod comparte parámetros con dev
- tratar la configuración como crítica y estable
- mantener separados los valores sensibles
- evitar cambios directos sin validación previa
- preservar compatibilidad con contratos existentes

Entrada esperada:
- variables de entorno
- parámetros de despliegue
- identificadores de recursos de producción
- configuración de módulos o stacks

Salida esperada:
- infraestructura de producción provisionada o actualizada
- errores de validación o despliegue
- configuración lista para consumo por servicios reales

Ejemplo conceptual:

```text
input: parámetros de prod + configuración base
output: despliegue productivo o error de validación
```

## Guía de extensión

Si necesitas ampliar `iac/environments/prod`:

1. Confirma primero que el cambio es realmente necesario en producción.
2. Agrega solo los parámetros imprescindibles.
3. Revisa impacto en seguridad, costo y disponibilidad.
4. Mantén alineación con los contratos del resto de entornos.
5. Agrega validaciones o revisiones adicionales si el cambio es sensible.
6. Documenta cualquier diferencia relevante respecto a dev o staging.

Buenas prácticas:
- mantener prod estable y predecible
- minimizar cambios manuales
- separar claramente lo común de lo productivo
- revisar dependencias antes de desplegar

## ¿Dónde modificar en caso de problemas?

Si algo falla, revisa en este orden:

1. Variables y parámetros del entorno prod
2. Referencias a módulos o recursos
3. Valores por defecto y overrides
4. Permisos, redes o restricciones de seguridad
5. Validaciones de despliegue y monitoreo

Puntos típicos a tocar:
- archivos de configuración del entorno prod
- variables de despliegue
- módulos invocados por este entorno
- recursos específicos de producción
- validaciones y controles del stack

Si el problema está en un comportamiento específico, modifica primero el punto más cercano a la causa:
- valor incorrecto -> variable o parámetro
- recurso mal referenciado -> configuración del módulo
- despliegue fallido -> validación o dependencia faltante
- ajuste solo aplicable a prod -> archivo de entorno prod
