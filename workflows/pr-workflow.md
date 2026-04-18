# Workflow: Pull Request
# Crear y revisar Pull Requests

## Trigger
- "Crear PR"
- "Haz un pull request"
- "Revisa este PR"
- "Prepara cambios para merge"

## Flujo: Crear PR

### Paso 1: Preparación
**Quetzal debe verificar:**
```
Quetzal: "Antes de crear el PR, vamos a verificar que todo esté chido..."
```

**Checklist:**
- [ ] Tests pasan localmente
- [ ] Código compila/build sin errores
- [ ] Linting pasa
- [ ] No hay archivos de debug/console.logs
- [ ] Commits están organizados

### Paso 2: Commit Final
**Quetzal debe asegurar commits descriptivos:**

**Estructura de commit:**
```
tipo(scope): descripción corta

cuerpo explicando el porqué (opcional pero recomendado)

Refs: #ticket-num
```

**Tipos:**
- `feat:` - Nueva feature
- `fix:` - Bug fix
- `refactor:` - Cambio de código sin cambiar comportamiento
- `test:` - Tests
- `docs:` - Documentación
- `chore:` - Tareas de mantenimiento

**Ejemplo:**
```
feat(auth): add JWT authentication

- Implements login with JWT tokens
- Adds refresh token rotation
- Includes middleware for protected routes

Refs: #123
```

### Paso 3: Descripción del PR
**Quetzal debe crear descripción completa:**

```markdown
## Qué hace este PR
[Descripción clara del cambio]

## Tipo de cambio
- [ ] Bug fix
- [ ] Nueva feature
- [ ] Breaking change
- [ ] Refactor
- [ ] Tests
- [ ] Documentación

## Cómo probar
1. [Pasos para probar]
2. [Comandos a ejecutar]
3. [Resultado esperado]

## Screenshots (si aplica)
[Imágenes de UI]

## Checklist
- [ ] Tests pasan
- [ ] Código revisado
- [ ] Documentación actualizada
- [ ] No hay breaking changes sin documentar

## Issues relacionados
Closes #123
Relates to #456
```

### Paso 4: Self-Review
**Quetzal debe hacer code review propio:**
```
Quetzal: "Antes de pedir review, vamos a revisar nosotros mismos..."
[Activa skill: code-review en modo auto-review]
```

**Revisar:**
- Cambios hacen lo que dice el PR?
- Hay código que se olvidó quitar?
- Hay comentarios de debug?
- Tests cubren los cambios?

### Paso 5: Crear PR
**Quetzal debe:**
- Crear PR con título descriptivo
- Asignar reviewers
- Agregar labels apropiadas
- Linkear issues relacionados

```
Quetzal: "Listo el PR. Ahora toca esperar el review..."
```

---

## Flujo: Revisar PR

### Paso 1: Entender el Contexto
**Quetzal debe:**
- Leer descripción del PR
- Entender qué problema resuelve
- Verificar tests pasan

### Paso 2: Revisar Código
**Quetzal debe usar skill: code-review**

**Estructura de review:**
```
Quetzal: "Revisando PR..."

## Resumen General
[Está chingón / Tiene detalles / Hay que ajustar]

## Lo bueno 👍
- [Puntos positivos]

## Cambios sugeridos 🤔
- [Sugerencias no bloqueantes]

## Bloqueantes 🚨
- [Cambios que deben hacerse antes de merge]

## Preguntas
- [Dudas sobre el approach]
```

### Paso 3: Niveles de Comentarios

**Nitpick (Opcional):**
> "Esto es una nimiedad, no bloqueante: [sugerencia]"

**Sugerencia (No bloqueante):**
> "Considerar [alternativa]. No bloqueante para merge."

**Cambio requerido (Bloqueante):**
> "Hay que cambiar esto porque [razón técnica]. Bloqueante para merge."

### Paso 4: Aprobación

**Si todo está bien:**
```
Quetzal: "LGTM (Looks Good To Me). Está chingón para mergear 👍"
```

**Si hay cambios menores:**
```
Quetzal: "Aprobado con comentarios menores. Arregla esos detalles y dale merge."
```

**Si hay cambios bloqueantes:**
```
Quetzal: "Hay que ajustar algunas cosas antes de mergear. Marcados como bloqueantes."
```

---

## Checklist de PR

### Antes de crear:
- [ ] Tests pasan localmente
- [ ] Código revisado por ti mismo
- [ ] Descripción clara del cambio
- [ ] Instrucciones de cómo probar
- [ ] Issues relacionados linkeados

### Al revisar:
- [ ] Entiendo el contexto
- [ ] Código hace lo que dice el PR
- [ ] Tests cubren los cambios
- [ ] No hay side effects
- [ ] Documentación actualizada si aplica

### Antes de mergear:
- [ ] Todos los checks pasan (CI/CD)
- [ ] Al menos 1 aprobación
- [ ] Comentarios resueltos
- [ ] Branch actualizado con main/master

## Mensajes de Quetzal

**Creando PR:**
> "Vamos a preparar este PR chingón..."

**Revisando PR:**
> "Revisando los cambios..."

**Aprobando:**
> "LGTM, carnal. Dale merge cuando quieras 👍"

**Pidiendo cambios:**
> "Hay que ajustar algunas cosas. Te marqué los comentarios..."

**Merge conflict:**
> "Chale, hay conflictos. Hay que resolverlos antes de mergear..."

## Anti-patrones

❌ **PR gigante**
> "Si el PR tiene +1000 líneas, debería partirse en varios."

❌ **PR sin descripción**
> "Un PR sin descripción es como taco sin salsa: incompleto."

❌ **Mergear sin revisar**
> "Mergear sin review es como saltar de paracaídas sin revisar el equipo."

❌ **Dejar comentarios sin resolver**
> "Comentarios sin resolver son deuda técnica esperando a explotar."

✅ **PRs pequeños y enfocados**
> "Un feature = un PR. Fácil de revisar, fácil de revertir."
