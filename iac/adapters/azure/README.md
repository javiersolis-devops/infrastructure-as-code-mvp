# Adapters - Azure

## Propósito y valor

`adapters/azure` centraliza la integración con Azure para que el resto del sistema no dependa de detalles específicos del proveedor. Su objetivo es encapsular autenticación, construcción de clientes, manejo de configuraciones y operaciones comunes detrás de una interfaz estable.

Valor principal:
- reduce el acoplamiento con Azure
- facilita pruebas y mantenimiento
- permite cambiar detalles internos sin impactar a los consumidores
- estandariza el uso de credenciales, regiones y recursos

## Alcance del servicio

Este adaptador cubre únicamente la lógica necesaria para interactuar con servicios de Azure definidos por el proyecto.

Incluye normalmente:
- inicialización de clientes SDK
- lectura y validación de configuración
- llamadas a servicios de Azure expuestas por el dominio
- normalización de respuestas y errores
- utilidades específicas del proveedor

No incluye:
- lógica de negocio del dominio
- reglas de orquestación de alto nivel
- almacenamiento de secretos en texto plano
- UI, APIs públicas o flujos ajenos a la integración

## Flujo

Flujo general de uso:

1. El consumidor solicita una operación al adaptador.
2. El adaptador valida parámetros y carga configuración requerida.
3. Se construye o reutiliza el cliente de Azure correspondiente.
4. Se ejecuta la operación contra el servicio externo.
5. La respuesta se normaliza al formato esperado por el sistema.
6. Los errores se traducen a errores internos consistentes.

Flujo típico de ejecución:

```text
Consumidor -> adapters/azure -> SDK de Azure -> respuesta normalizada -> consumidor
```

## Contrato de uso

Para usar este adaptador, el consumidor debe respetar estas reglas:

- pasar parámetros válidos y completos
- no asumir detalles internos del SDK de Azure
- tratar los errores del adaptador como parte del contrato público
- no depender de estructuras de respuesta sin normalización
- proveer credenciales y configuración por los mecanismos definidos por el proyecto

Entrada esperada:
- configuración de Azure
- identificadores de recursos
- parámetros específicos de la operación

Salida esperada:
- respuesta normalizada
- error estructurado en caso de fallo

Ejemplo conceptual:

```text
input: datos del recurso + configuración
output: resultado normalizado o error del adaptador
```

## Guía de extensión

Si necesitas agregar soporte para un nuevo servicio o capacidad de Azure:

1. Reutiliza la capa común de configuración y autenticación.
2. Agrega el cliente o wrapper mínimo necesario.
3. Mantén la normalización de respuestas dentro del adaptador.
4. Expón una interfaz consistente con el resto del directorio.
5. Agrega pruebas para casos exitosos y fallos.
6. Evita filtrar detalles del SDK hacia capas superiores.

Buenas prácticas:
- mantener funciones pequeñas y enfocadas
- centralizar manejo de errores
- no duplicar lógica entre servicios
- documentar parámetros obligatorios y opcionales

## ¿Dónde modificar en caso de problemas?

Si algo falla, revisa en este orden:

1. Configuración de entorno y credenciales de Azure
2. Inicialización de clientes y autenticación
3. Mapeo de parámetros de entrada
4. Normalización de respuestas
5. Traducción de errores y códigos de estado
6. Pruebas unitarias o de integración del adaptador

Puntos típicos a tocar:
- archivo de configuración del adaptador
- módulo de inicialización de clientes
- funciones de transformación de respuestas
- capa de manejo de errores
- pruebas asociadas al servicio afectado

Si el problema está en un comportamiento específico, modifica primero el punto más cercano a la causa:
- autenticación -> configuración y creación de cliente
- respuesta incorrecta -> normalización o mapeo
- error inesperado -> traducción de errores
- nuevo servicio -> módulo del servicio y sus pruebas
