# Ambientes: Dev

## Propósito y valor

`iac/environments/dev` define la configuración del entorno de desarrollo para la infraestructura como código. Su objetivo es ofrecer un espacio seguro, predecible y aislado para probar cambios antes de promoverlos a otros entornos.

Valor principal:
- permite validar cambios sin impactar entornos superiores
- acelera iteraciones de desarrollo y pruebas
- reduce el riesgo de errores en producción
- mantiene una configuración específica para desarrollo sin contaminar otros entornos

## Alcance del servicio

Este entorno cubre únicamente la configuración necesaria para desarrollo.

Incluye normalmente:
- variables y parámetros específicos de dev
- selección de recursos, tamaños o capacidades de desarrollo
- configuraciones menos costosas o más flexibles
- referencias a módulos, adaptadores o stacks usados en dev
- valores por defecto adecuados para pruebas locales o integradas

No incluye:
- reglas exclusivas de producción
- optimizaciones de alto rendimiento que no sean necesarias en dev
- secretos incrustados en el código
- lógica de negocio
- configuración compartida que deba vivir en una capa común

## Flujo

Flujo general de uso:

1. Se define o ajusta la configuración de desarrollo.
2. La capa de IaC lee los valores del entorno dev.
3. Se construyen los recursos o módulos con parámetros específicos de desarrollo.
4. Se aplican cambios en un entorno aislado.
5. Se validan comportamientos antes de promoverlos a otros entornos.

Flujo típico de ejecución:

```text
Configuración dev -> plantillas/módulos IaC -> despliegue en entorno dev -> validación de cambios
```

## Contrato de uso

Para usar este entorno, el consumidor debe respetar estas reglas:

- no asumir que dev comparte valores con staging o producción
- tratar la configuración como específica del entorno
- mantener separados los parámetros sensibles
- no reutilizar recursos de producción para pruebas de desarrollo
- validar cambios antes de moverlos a otros entornos

Entrada esperada:
- variables de entorno
- parámetros de despliegue
- identificadores de recursos de desarrollo
- configuración de módulos o stacks

Salida esperada:
- infraestructura de desarrollo provisionada o actualizada
- errores de validación o despliegue
- configuración lista para consumir por la capa de aplicación

Ejemplo conceptual:

```text
input: parámetros de dev + configuración base
output: despliegue de desarrollo o error de validación
```

## Guía de extensión

Si necesitas ampliar `iac/environments/dev`:

1. Define primero si el cambio es exclusivo de desarrollo o si debe moverse a una capa común.
2. Agrega solo los parámetros necesarios para dev.
3. Mantén la compatibilidad con módulos y contratos existentes.
4. Evita copiar configuraciones de otros entornos sin revisar diferencias.
5. Agrega pruebas o validaciones si el entorno depende de reglas nuevas.
6. Documenta qué valores son específicos de dev y por qué.

Buenas prácticas:
- mantener dev simple y barato
- separar claramente lo común de lo específico del entorno
- usar nombres consistentes para recursos y variables
- evitar duplicar lógica entre entornos

## ¿Dónde modificar en caso de problemas?

Si algo falla, revisa en este orden:

1. Variables y parámetros del entorno dev
2. Referencias a módulos o recursos
3. Valores por defecto y overrides
4. Credenciales o permisos asociados al entorno
5. Validaciones de despliegue y pruebas

Puntos típicos a tocar:
- archivos de configuración del entorno dev
- variables locales o de despliegue
- módulos invocados por este entorno
- recursos específicos de desarrollo
- validaciones asociadas al stack

Si el problema está en un comportamiento específico, modifica primero el punto más cercano a la causa:
- valor incorrecto -> variable o parámetro
- recurso mal referenciado -> configuración del módulo
- despliegue fallido -> validación o dependencia faltante
- cambio solo aplicable a dev -> archivo de entorno dev
