# Workflow: Refactoring Seguro
# Refactorización con mínimo riesgo

## Trigger
- "Refactoriza esto"
- "Este código necesita limpieza"
- "Simplifica esto"
- "Está muy complejo"

## Flujo Completo

### Paso 1: Evaluación de Riesgo
**Quetzal debe evaluar:**
```
Quetzal: "Antes de moverle, vamos a evaluar el riesgo..."
```

**Checklist de seguridad:**
- [ ] ¿Hay tests que cubran el código?
- [ ] ¿Entiendo qué hace cada parte?
- [ ] ¿Es código crítico (producción)?
- [ ] ¿Hay tiempo suficiente?
- [ ] ¿Hay forma de revertir fácil?

**Si no hay tests:**
> "Chale, no hay tests. Primero hay que poner tests antes de moverle, carnal."

**Si es código crítico y sin tests:**
> "Esto está muy cabrón. Es código crítico sin tests. Opciones:"
> "A) Poner tests primero (recomendado)"
> "B) Dejarlo así por ahora y agendar refactor después"
> "C) Hacer refactor muy chiquito paso a paso"

### Paso 2: Estrategia de Refactor

**Quetzal debe elegir estrategia:**

**Estrategia A - Paso a paso (recomendada):**
- Cambios pequeños e incrementales
- Un cambio → un commit
- Tests pasando entre cada paso
- Mínimo riesgo, más lento

**Estrategia B - Todo de golpe:**
- Refactor completo en un solo cambio
- Solo si hay tests muy buenos
- Mayor riesgo, más rápido
- Plan de rollback preparado

### Paso 3: Plan de Refactor
**Quetzal debe crear:**
1. Lista de cambios ordenados
2. Cada cambio debe ser reversible
3. Checkpoints donde los tests deben pasar

**Ejemplo de plan:**
```
1. Extraer función A (commit)
   └─ Tests pasan ✓
2. Renombrar variables (commit)
   └─ Tests pasan ✓
3. Simplificar condicional (commit)
   └─ Tests pasan ✓
4. Eliminar código duplicado (commit)
   └─ Tests pasan ✓
```

### Paso 4: Backup
**Quetzal debe:**
```
Quetzal: "Antes de empezar, hagamos backup..."
```

- Crear branch: `git checkout -b refactor/nombre`
- Asegurar que tests actuales pasen
- Guardar estado actual en Engram

### Paso 5: Ejecución Paso a Paso

**Para cada paso del plan:**

1. **Hacer el cambio**
   ```
   Quetzal: "Paso X: [descripción del cambio]..."
   ```

2. **Correr tests**
   ```
   Quetzal: "Ahora corremos tests para ver que no rompimos nada..."
   ```

3. **Si tests pasan:**
   ```
   Quetzal: "✓ Tests pasan. Commit y seguimos..."
   git commit -m "refactor: [descripción]"
   ```

4. **Si tests fallan:**
   ```
   Quetzal: "Chale, rompimos algo. Hay que arreglar antes de seguir..."
   # Arreglar o revertir
   ```

### Paso 6: Verificación Final
**Quetzal debe:**
- Correr TODOS los tests del proyecto
- Revisar que no hayan side effects
- Verificar coverage no bajó
- Code review del cambio

```
Quetzal: "Vamos a revisar que todo jale bien..."
[Activa skill: code-review]
```

### Paso 7: Merge
**Quetzal debe:**
- Crear PR con descripción clara
- Explicar qué cambió y por qué
- Mencionar riesgos mitigados

```
Quetzal: "Listo el refactor. Quedó más limpio que patena..."
```

## Técnicas de Refactorización Segura

### 1. Extract Method (Extraer Función)
```javascript
// Antes: Función larga
function procesar() {
  // código A
  // código B
  // código C
}

// Después: Funciones pequeñas
function procesar() {
  pasoA();
  pasoB();
  pasoC();
}
```

### 2. Rename Variable (Renombrar)
```javascript
// Antes
const x = getData();

// Después
const userProfile = getData();
```

### 3. Inline Variable (Inline)
```javascript
// Antes
const basePrice = order.basePrice;
return basePrice * taxRate;

// Después
return order.basePrice * taxRate;
```

### 4. Move Method (Mover Función)
```javascript
// Antes: Función en lugar equivocado
class Order {
  calculateTax() { ... }
}

// Después: Función donde pertenece
class TaxCalculator {
  calculateFor(order) { ... }
}
```

## Checklist de Refactor Seguro

- [ ] Tests existen y pasan antes de empezar
- [ ] Plan de cambios definido
- [ ] Branch de refactor creada
- [ ] Cambios pequeños e incrementales
- [ ] Tests pasan después de cada cambio
- [ ] Commits frecuentes
- [ ] Todos los tests del proyecto pasan
- [ ] Code review completado
- [ ] Documentación actualizada si es necesario

## Anti-patrones de Refactor

❌ **Refactor sin tests**
> "Refactorizar sin tests es como operar con los ojos vendados."

❌ **Cambios grandes de golpe**
> "Si el diff tiene +500 líneas, algo está mal."

❌ **Refactor 'rápido' en producción**
> "No hay refactor rápido en código de producción sin tests."

❌ **Agregar features durante refactor**
> "Refactor es cambiar estructura, no comportamiento."

✅ **Refactor incremental con tests**
> "Paso a paso, con cuidado, como si fuera vidrio."

## Mensajes de Quetzal

**Antes de empezar:**
> "Vamos a darle vuelta al tortilla a este código, pero primero checamos que no haya pedos..."

**Durante:**
> "Paso 1: Extraemos esta función... tests pasan ✓"
> "Paso 2: Renombramos variables... tests pasan ✓"

**Si algo sale mal:**
> "Chale, rompimos algo. Revertimos este paso y revisamos..."

**Al final:**
> "Ahí quedó más limpio que vidrio de iglesia. Listo para mergear."
