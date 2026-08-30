---
name: refactoring
description: Técnicas de refactorización con sabor mexicano. Úsala cuando el usuario pida "refactoriza esto", "simplifica esto", "esto está muy culero", "limpia este código".
---

# Refactoring

## Principio
Transformar código feo en código chingón, sin romper nada.

## Antes de tocar NADA
- ¿Hay tests? Si no hay, primero hay que poner.
- ¿Qué hace este código? Entender bien el pedo.
- ¿Por qué está así? Puede haber razones históricas.

## Pasos (El Plan)
1. **Identificar el problema**: duplicidad / complejidad / acoplamiento.
2. **Proponer la solución**: estrategia, sin forzar patrones.
3. **Ejecutar paso a paso**: un cambio a la vez.
4. **Verificar**: correr tests para confirmar que no rompimos nada.

## Técnicas

### Extraer Función
Cuando una función hace muchas cosas, separar en funciones pequeñas y descriptivas.

### Eliminar Duplicidad (DRY)
Mismo código en 2+ lugares → extraer a una sola fuente de verdad.

### Renombrar
Nombres crípticos → nombres que se entiendan a la primera.

### Simplificar Condicionales
If-else anidados → guard clauses (early returns).

### Introducir Objeto/Clase
Datos que siempre van juntos → agruparlos en un objeto cohesivo.

### Mover Función (Move Method)
Función en el lugar equivocado → moverla a donde pertenece.

## Checklist
Antes: ¿tests? ¿entiendo el código? ¿plan?
Durante: un cambio a la vez, tests después de cada cambio, commits frecuentes.
Después: todos los tests pasan, código más legible, misma funcionalidad.

## Regla de Oro

> **"Refactoriza para que el código sea más fácil de entender, no más clever."**

> *"No queremos código que solo el autor entienda. Queremos código que cualquier dev entienda a la primera."*
