# Skill: SDD - Spec-Driven Development

## Trigger
Usa esta skill cuando:
- El usuario quiera "planear una feature"
- Se necesite diseñar antes de codear
- Se quiera hacer "planning" o "diseño"
- El proyecto sea complejo y necesite especificación

## Objetivo
Aplicar SDD: pensar, especificar y validar ANTES de escribir código.

> *"El código es el último paso, carnal. Primero hay que saber qué estamos construyendo."*

## Fases del SDD

### **FASE 1: ENTENDER EL PROBLEMA (El Diagnóstico)**

**Qué hacer:**
- Escuchar lo que el usuario quiere
- Hacer preguntas hasta entender el pedo completo
- Identificar stakeholders y restricciones

**Preguntas clave:**
```
"Antes de proponer nada, dime:"
- "¿Qué problema estamos resolviendo?"
- "¿Para quién es esto?"
- "¿Qué éxito se ve?"
- "¿Hay deadlines o constraints?"
- "¿Qué NO debe hacer esto?"
```

**Output:**
```markdown
## Problema Entendido
- Contexto: [situación actual]
- Usuario final: [quién lo usa]
- Objetivo: [qué se quiere lograr]
- Constraints: [limitaciones]
```

---

### **FASE 2: EXPLORAR OPCIONES (Las Alternativas)**

**Qué hacer:**
- Proponer 2-3 soluciones diferentes
- Comparar pros y contras de cada una
- No comprometerse con una todavía

**Estructura:**
```markdown
## Opciones Exploradas

### Opción A: [Nombre descriptivo]
**Descripción:** Cómo funciona
**Pros:**
- Ventaja 1
- Ventaja 2
**Contras:**
- Desventaja 1
- Desventaja 2
**Cuándo usar:** Escenarios ideales

### Opción B: [Nombre descriptivo]
...

### Opción C: [Nombre descriptivo]
...
```

**Frases:**
> *"Tenemos varias formas de atacarle..."
> *"Cada una tiene sus pro y sus contra..."
> *"La neta, depende de qué priorices..."

---

### **FASE 3: DECIDIR (La Elección)**

**Qué hacer:**
- Recomendar una opción con justificación técnica
- Explicar por qué NO las otras
- Pedir aprobación del usuario

**Estructura:**
```markdown
## Recomendación

**Opción elegida:** [A/B/C]

**Por qué:**
- Razón técnica 1
- Razón técnica 2
- Tradeoffs aceptables

**Por qué no las otras:**
- Opción X: [razón]
- Opción Y: [razón]

**Riesgos:**
- Riesgo 1 y mitigación
- Riesgo 2 y mitigación
```

**Frases:**
> *"Yo le entraría a la Opción X porque..."
> *"La neta, esta es la que más nos conviene..."
> *"Tiene sus detalles, pero..."

**Pregunta obligatoria:**
```
"¿Estás de acuerdo con este approach o quieres explorar otra opción?"
```

---

### **FASE 4: ESPECIFICAR (El Plan Detallado)**

**Qué hacer:**
- Crear una especificación técnica
- Definir APIs, modelos de datos, flujos
- Estimar esfuerzo

**Estructura:**
```markdown
## Especificación Técnica

### Arquitectura
[Diagrama o descripción de componentes]

### Modelo de Datos
```
Entity: User
- id: UUID
- email: String (unique)
- name: String
- createdAt: DateTime
```

### APIs/Interfaces
```
POST /api/users
Request: { name, email }
Response: { id, name, email, createdAt }
Errors: 400, 409, 500
```

### Flujo de Datos
1. Paso 1
2. Paso 2
3. Paso 3

### Tareas/Tickets
- [ ] Tarea 1 (estimación)
- [ ] Tarea 2 (estimación)
- [ ] Tarea 3 (estimación)

### Consideraciones
- Seguridad
- Performance
- Escalabilidad
- Testing
```

**Frases:**
> *"Aquí está el plan detallado..."
> *"Vamos paso a paso..."
> *"Esta es la arquitectura que propongo..."

---

### **FASE 5: VALIDAR (El Check Final)**

**Qué hacer:**
- Revisar la especificación con el usuario
- Confirmar que entendió todo bien
- Ajustar si hay feedback

**Checklist:**
- [ ] ¿El usuario validó el approach?
- [ ] ¿Las estimaciones son razonables?
- [ ] ¿Se identificaron los riesgos?
- [ ] ¿Hay plan de testing?

**Frases:**
> *"Dime si le atiné al pedo o hay algo que ajustar..."
> *"¿Todo esto tiene sentido para ti?"
> *"¿Algo que no haya considerado?"

---

## Cuándo aplicar SDD vs Cuándo NO

### **APLICAR SDD cuando:**
- Feature compleja (>2-3 días de trabajo)
- Arquitectura nueva o cambio grande
- Integración con sistemas externos
- Decisión difícil de revertir
- Múltiples stakeholders

### **NO aplicar SDD cuando:**
- Bug fix simple
- Cambio de 1 línea
- Refactor menor
- Spike/experimentación rápida

**Frase:**
> *"Para este cambio chiquito, no le busquemos ruido al chicharrón. Lo hacemos y listo."
> *"Para esto sí vale la pena planear bien, carnal. No queremos que se convierta en un desmadre."

---

## Anti-Patrones de SDD

❌ **Analysis Paralysis**
> "Llevamos 3 semanas planeanado y no codeamos nada. A darle que es mole de olla."

❌ **Over-specification**
> "Especificamos hasta el color de los botones y ni siquiera sabemos si el approach funciona."

❌ **No-involucrar al equipo**
> "El arquitecto planeó todo solo y el equipo no está de acuerdo. Chale..."

✅ **Balance**
> "Planeamos lo suficiente para no meternos en pedos, pero no tanto que no avancemos."

---

## Ejemplo Completo de SDD

**Usuario:** "Quiero agregar autenticación a mi app"

**Quetzal (FASE 1 - Entender):**
> *"Órale, autenticación. Déjame entender el pedo primero..."
> 
> - "¿Es para app web, móvil o ambas?"
> - "¿Necesitas MFA desde el día 1?"
> - "¿Preferencia por algún provider (Auth0, Firebase, DIY)?"
> - "¿Cuántos usuarios esperas?"

**Quetzal (FASE 2 - Opciones):**
> *"Entendido. Aquí tenemos varias formas de atacarle..."
> 
> **Opción A - Auth0/Firebase Auth:**
> - Pro: Rápido, seguro, escalable
> - Contra: Vendor lock-in, costo mensual
> 
> **Opción B - JWT propio:**
> - Pro: Control total, gratis
> - Contra: Tú mantienes la seguridad
> 
> **Opción C - OAuth social (Google/GitHub):**
> - Pro: Sin passwords
> - Contra: No todos los usuarios quieren esto

**Quetzal (FASE 3 - Decidir):**
> *"Yo le entraría a Auth0 porque..."
> 
> "¿Estás de acuerdo o quieres explorar otra?"

**Quetzal (FASE 4 - Especificar):**
> *"Sale pues. Aquí está el plan detallado..."
> 
> [Especificación completa con diagramas, APIs, tareas]

**Quetzal (FASE 5 - Validar):**
> *"¿Todo esto tiene sentido? ¿Algo que ajustar antes de codear?"
> 
> *"Cuando me des el 👍, le entramos al código."

---

## Regla de Oro del SDD

> **"Es más barato cambiar una especificación que cambiar código ya escrito."**
>
> *"Por eso planeamos primero, carnal. Para no andar reescribiendo código a cada rato."*
