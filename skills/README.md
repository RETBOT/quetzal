# 🎯 Skills de Quetzal

Las skills son capacidades especializadas que Quetzal puede activar según el contexto.

## Skills Disponibles

### 🔍 [code-review](./code-review/)
Revisión de código al estilo arquitecto senior mexicano.

**Trigger:** "Revisa este código", "Haz code review", "Qué opinas de esto?"

**Incluye:**
- Calificación general (Está chingón / Tiene detalles / Aquí la cagaron)
- Qué está bien
- Qué está mal (con explicaciones técnicas)
- Por qué importa
- Cómo mejorarlo (con ejemplos)

---

### 🔨 [refactoring](./refactoring/)
Técnicas de refactorización con sabor mexicano.

**Trigger:** "Refactoriza esto", "Esto está muy culero", "Simplifica esto"

**Incluye:**
- Extraer función
- Eliminar duplicidad (DRY)
- Renombrar variables/funciones
- Simplificar condicionales
- Introducir objetos/clases
- Mover métodos
- Checklist de refactorización segura

---

### 📋 [sdd](./sdd/)
Spec-Driven Development: Planear antes de codear.

**Trigger:** "Planear una feature", "Diseñar esto", "SDD"

**Incluye:**
- Fase 1: Entender el problema
- Fase 2: Explorar opciones
- Fase 3: Decidir approach
- Fase 4: Especificar en detalle
- Fase 5: Validar

---

### 🧪 [testing](./testing/)
Testing: Unit, Integration, E2E, TDD.

**Trigger:** "Haz tests", "TDD", "Cobertura", "Validar esto"

**Incluye:**
- Unit tests
- Integration tests
- E2E tests
- TDD (Test-Driven Development)
- Coverage
- Buenas prácticas
- Ejemplos en diferentes escenarios

---

## Cómo Funcionan

Las skills se activan automáticamente cuando Quetzal detecta ciertos triggers en la conversación. No necesitas hacer nada especial, solo hablar con Quetzal y él sabrá cuándo usar cada skill.

**Ejemplo:**

```
Usuario: "Revisa este código"
Quetzal: [Activa skill: code-review]
        "🤔 Tiene detalles..."

Usuario: "Refactoriza esto"
Quetzal: [Activa skill: refactoring]
        "Vamos a darle vuelta al tortilla..."

Usuario: "Quiero planear una feature"
Quetzal: [Activa skill: sdd]
        "Órale, vamos a aplicar SDD..."
```

## Agregar Nuevas Skills

1. Crear carpeta `skills/nueva-skill/`
2. Crear archivo `skill.md` con:
   - Trigger (cuándo se activa)
   - Objetivo (qué hace)
   - Contenido (cómo lo hace)
   - Ejemplos
3. Agregar al README de skills

## Inspiración

Las skills están inspiradas en [Gentleman AI](https://github.com/Gentleman-Programming/gentle-ai) pero con el toque mexicano único de Quetzal. 🌮🦜
