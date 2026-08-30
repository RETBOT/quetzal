---
name: sdd
description: Spec-Driven Development, planear antes de codear. Úsala cuando el usuario pida "planear una feature", "diseñar esto", "hacer planning", "SDD".
---

# SDD - Spec-Driven Development

## Objetivo
Pensar, especificar y validar ANTES de escribir código.

> *"El código es el último paso, carnal. Primero hay que saber qué estamos construyendo."*

## Fases

### FASE 1: ENTENDER EL PROBLEMA
Escuchar qué quiere el usuario, hacer preguntas hasta entender el pedo completo, identificar stakeholders y restricciones.

**Preguntas clave:**
- "¿Qué problema estamos resolviendo?"
- "¿Para quién es esto?"
- "¿Qué éxito se ve?"
- "¿Hay deadlines o constraints?"
- "¿Qué NO debe hacer esto?"

### FASE 2: EXPLORAR OPCIONES
Proponer 2-3 soluciones, comparar pros/contras de cada una, sin comprometerse todavía.

```
### Opción A: [Nombre]
**Pros:** ... **Contras:** ... **Cuándo usar:** ...
### Opción B: ...
### Opción C: ...
```

### FASE 3: DECIDIR
Recomendar una opción con justificación técnica, explicar por qué NO las otras, pedir aprobación.

```
**Opción elegida:** [A/B/C]
**Por qué:** ...
**Por qué no las otras:** ...
**Riesgos:** ... y mitigación
```

### FASE 4: ESPECIFICAR
Crear especificación técnica: arquitectura, modelo de datos, APIs, flujos, tareas, consideraciones (seguridad, perf, escalabilidad, testing).

### FASE 5: VALIDAR
Revisar con el usuario, confirmar que se entendió, ajustar por feedback.

## Cuándo aplicar SDD vs NO

**Aplicar** cuando: feature compleja (>2-3 días), arquitectura nueva o cambio grande, integración externa, decisión difícil de revertir, múltiples stakeholders.

**NO aplicar** cuando: bug fix simple, cambio de 1 línea, refactor menor, spike/experimentación rápida.

> *"Para este cambio chiquito, no le busquemos ruido al chicharrón. Lo hacemos y listo."*

## Anti-Patrones
- **Analysis Paralysis**: planear demasiado sin avanzar.
- **Over-specification**: especificar hasta el color de los botones.
- **No-involucrar al equipo**: planear solo y que nadie esté de acuerdo.
- ✅ **Balance**: "Planeamos lo suficiente para no meternos en pedos, pero no tanto que no avancemos."

## Regla de Oro

> **"Es más barato cambiar una especificación que cambiar código ya escrito."**
