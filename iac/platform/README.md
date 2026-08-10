# iac/platform

## Propósito y valor

`iac/platform` concentra la infraestructura base y las capacidades compartidas que sirven como plataforma para los demás componentes del sistema. Su objetivo es proveer una capa estable para observabilidad, red, seguridad, identidad, operaciones y otros servicios transversales que no pertenecen a un dominio funcional específico.

Valor principal:
- centraliza capacidades compartidas de la plataforma
- reduce duplicación entre módulos y entornos
- estandariza recursos base para el resto del sistema
- facilita mantener criterios consistentes de operación y soporte

## Alcance del servicio

Este módulo cubre únicamente la infraestructura de plataforma y los componentes transversales definidos por el proyecto.

Incluye normalmente:
- observabilidad y monitoreo
- recursos compartidos de plataforma
- configuración base para integración entre servicios
- componentes transversales de seguridad o identidad
- módulos reutilizables para necesidades comunes

No incluye:
- lógica de negocio de un dominio específico
- configuración exclusiva de un entorno puntual si puede vivir en `iac/environments`
- detalles internos de un adaptador concreto
- reglas de dominio
- secretos incrustados en código

## Flujo

Flujo general de uso:

1. Se define la infraestructura base de plataforma.
2. Los módulos de plataforma exponen recursos y contratos reutilizables.
3. Los entornos consumen esa base para desplegar componentes específicos.
4. Los adaptadores o servicios usan capacidades de plataforma ya estandarizadas.
5. Se monitorea y opera la plataforma de forma centralizada.

Flujo típico de ejecución:

```text
infraestructura base -> iac/platform -> recursos compartidos -> entornos y servicios consumidores
```

## Contrato de uso

Para usar este módulo, el consumidor debe respetar estas reglas:

- no mezclar aquí lógica de dominio o de aplicación
- consumir solo los recursos y outputs expuestos por la plataforma
- no duplicar recursos compartidos en capas superiores
- mantener compatibilidad con los contratos de salida
- tratar la plataforma como una base común y estable

Entrada esperada:
- parámetros de infraestructura base
- variables de despliegue
- referencias a redes, identidades o servicios comunes
- configuración de observabilidad o seguridad

Salida esperada:
- recursos de plataforma provisionados
- outputs reutilizables por otros módulos
- errores de validación o despliegue

Ejemplo conceptual:

```text
input: parámetros de plataforma + configuración base
output: infraestructura compartida o error de validación
```

## Guía de extensión

Si necesitas ampliar `iac/platform`:

1. Confirma que la capacidad es transversal y no pertenece a un dominio o entorno específico.
2. Agrega el recurso o módulo en la sección más cercana a su responsabilidad.
3. Expón outputs mínimos y estables.
4. Mantén separados observabilidad, seguridad, red y otros bloques si crecen.
5. Agrega validaciones y pruebas para cambios en contratos compartidos.
6. Documenta qué consumen los demás módulos de esta plataforma.

Buenas prácticas:
- mantener la plataforma modular y reutilizable
- evitar duplicar recursos comunes
- documentar outputs y dependencias
- conservar compatibilidad hacia abajo siempre que sea posible

## ¿Dónde modificar en caso de problemas?

Si algo falla, revisa en este orden:

1. Variables y parámetros de plataforma
2. Referencias entre módulos y outputs
3. Permisos, redes o dependencias transversales
4. Configuración de observabilidad o seguridad
5. Validaciones y pruebas del módulo

Puntos típicos a tocar:
- archivos de la plataforma base
- módulos compartidos
- outputs consumidos por entornos
- recursos transversales como observabilidad o seguridad
- validaciones asociadas al despliegue

Si el problema está en un comportamiento específico, modifica primero el punto más cercano a la causa:
- output faltante -> módulo de plataforma o su definición
- recurso mal referenciado -> contrato entre módulos
- fallo de despliegue -> validación o dependencia base
- necesidad transversal nueva -> archivo o módulo dentro de `iac/platform`
