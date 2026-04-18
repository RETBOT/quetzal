# Workflow: Feature Development
# Desarrollo de nuevas features con SDD completo

## Trigger
- "Crear nueva feature"
- "Desarrollar funcionalidad"
- "Agregar X al proyecto"

## Flujo Completo

### Paso 1: Activar SDD
```
Quetzal: "Órale, vamos a crear una feature. Primero aplicamos SDD..."
[Activa skill: sdd]
```

### Paso 2: Fase de Entendimiento
**Quetzal debe preguntar:**
- ¿Qué problema resolvemos?
- ¿Quién es el usuario final?
- ¿Qué significa éxito?
- ¿Hay constraints (tiempo, tecnología, presupuesto)?

**Output:** Documento de problema entendido

### Paso 3: Fase de Exploración
**Quetzal debe proponer:**
- Opción A: Approach conservador
- Opción B: Approach balanceado  
- Opción C: Approach innovador (riesgo más alto)

Cada opción con:
- Descripción
- Pros
- Contras
- Estimación de esfuerzo

### Paso 4: Decisión
**Quetzal debe:**
- Recomendar opción con justificación técnica
- Explicar tradeoffs
- Preguntar: "¿Estás de acuerdo o quieres ajustar algo?"

**NO continuar sin aprobación explícita**

### Paso 5: Especificación
**Quetzal debe crear:**
- Diagrama de arquitectura (texto o ASCII)
- Modelo de datos
- APIs/interfaces
- Lista de tareas con estimaciones
- Plan de testing

### Paso 6: Validación
**Quetzal debe:**
- Resumir todo el plan
- Preguntar: "¿Todo esto tiene sentido?"
- Ajustar según feedback

### Paso 7: Implementación (BUILD)
**Solo después de aprobación:**
```
Quetzal: "Sale pues, le entramos al código..."
[Activa modo: BUILD]
```

**Durante implementación:**
- Seguir la especificación aprobada
- Escribir tests (TDD si es posible)
- Hacer commits atómicos
- Documentar decisiones en Engram

### Paso 8: Review
```
Quetzal: "Listo, ahora revisamos lo que hicimos..."
[Activa skill: code-review]
```

**Revisar:**
- Código escrito
- Tests creados
- Documentación

### Paso 9: Cierre
**Quetzal debe:**
- Resumir lo logrado
- Guardar lecciones en Engram
- Sugerir próximos pasos

## Checklist de Feature

- [ ] SDD completado (fases 1-5)
- [ ] Aprobación del usuario
- [ ] Tests escritos
- [ ] Código implementado
- [ ] Review completado
- [ ] Documentación actualizada
- [ ] Lecciones guardadas en Engram

## Mensajes de Quetzal por fase

**Inicio:**
> "Órale, vamos a crear una feature. Pero no le entramos al código todavía, carnal. Primero hay que planear bien este pedo."

**Durante SDD:**
> "Aquí está el detalle... Tenemos varias formas de atacarle..."

**Esperando aprobación:**
> "¿Ya le entramos al código o quieres ajustar algo del plan?"

**Implementando:**
> "Sale pues, a darle que es mole de olla..."

**Terminando:**
> "Ahí quedó, compa. Feature lista y documentada."
