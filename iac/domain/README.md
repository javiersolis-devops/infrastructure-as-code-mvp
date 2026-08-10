# Domain

## Propósito y valor

`iac/domain` concentra la lógica de dominio relacionada con la definición, validación y organización del modelo de infraestructura como código. Su objetivo es mantener separadas las reglas del negocio del resto de la implementación técnica y servir como fuente de verdad para conceptos, contratos y estructuras del dominio.

Valor principal:
- aísla las reglas del dominio de detalles de infraestructura
- mejora la mantenibilidad y la claridad del modelo
- reduce el acoplamiento entre capas
- facilita validar cambios antes de llevarlos a adaptadores o proveedores

## Alcance del servicio

Este módulo cubre únicamente la lógica de dominio necesaria para representar y validar el sistema de infraestructura.

Incluye normalmente:
- entidades y objetos de valor del dominio
- reglas e invariantes del modelo
- validaciones de entrada a nivel de negocio
- contratos internos entre capas
- transformaciones puramente de dominio

No incluye:
- acceso directo a Azure u otros proveedores
- llamadas a SDKs o APIs externas
- persistencia
- orquestación de ejecución
- UI, CLI o responsabilidades de presentación

## Flujo

Flujo general de uso:

1. Una capa superior recibe o construye una solicitud.
2. La solicitud se traduce a estructuras del dominio.
3. `iac/domain` valida reglas e invariantes.
4. El dominio expone un resultado, decisión o contrato normalizado.
5. Las capas externas usan ese resultado para ejecutar adaptadores o acciones.

Flujo típico de ejecución:

```text
Entrada de aplicación -> iac/domain -> validación/reglas -> contrato de dominio -> capa consumidora
```

## Contrato de uso

Para usar este módulo, el consumidor debe respetar estas reglas:

- pasar datos válidos según el modelo del dominio
- no depender de detalles de implementación interna
- tratar las validaciones del dominio como reglas obligatorias
- no mezclar lógica de proveedor con lógica de dominio
- consumir solo los contratos expuestos por esta capa

Entrada esperada:
- datos de infraestructura
- parámetros de configuración lógica
- referencias o identificadores de recursos

Salida esperada:
- modelo validado
- decisión de dominio
- error de validación o contrato incumplido

Ejemplo conceptual:

```text
input: definición lógica + parámetros
output: objeto de dominio validado o error de regla
```

## Guía de extensión

Si necesitas ampliar el dominio:

1. Identifica primero la regla o concepto de negocio que falta.
2. Agrega la entidad, valor o validación en el lugar más cercano al modelo.
3. Mantén las dependencias fuera de proveedores o adaptadores.
4. Expón contratos pequeños y explícitos.
5. Agrega pruebas para invariantes y casos límite.
6. Evita duplicar reglas en capas superiores.

Buenas prácticas:
- mantener el dominio puro y estable
- nombrar conceptos con términos del negocio
- evitar acoplar el dominio a detalles técnicos
- centralizar validaciones importantes

## ¿Dónde modificar en caso de problemas?

Si algo falla, revisa en este orden:

1. Reglas e invariantes del dominio
2. Validaciones de entrada
3. Modelos y contratos internos
4. Transformaciones entre capas
5. Pruebas del dominio

Puntos típicos a tocar:
- entidades del dominio
- objetos de valor
- validadores
- errores de dominio
- pruebas unitarias del modelo

Si el problema está en un comportamiento específico, modifica primero el punto más cercano a la causa:
- validación incorrecta -> reglas o validadores
- modelo incompleto -> entidad u objeto de valor
- contrato ambiguo -> interfaz o tipo del dominio
- fallo en integración -> mapeo entre dominio y capa externa
