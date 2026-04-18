# 📦 Pack Esencial de Quetzal

El Pack Esencial incluye los componentes que hacen a Quetzal un ecosistema completo de desarrollo, inspirado en [Gentleman AI](https://github.com/Gentleman-Programming/gentle-ai).

## ¿Qué incluye?

### 🚀 3 Comandos de Proyecto

Comandos ejecutables para configurar y gestionar proyectos:

| Comando | Descripción | Uso |
|---------|-------------|-----|
| `project-init` | Inicializa proyecto con Quetzal | `./commands/project-init` |
| `sdd-init` | Detecta stack y configura SDD | `./commands/sdd-init` |
| `skill-registry` | Registra skills disponibles | `./commands/skill-registry` |

**Flujo típico:**
```bash
cd mi-proyecto
../quetzal/commands/project-init    # Crea .quetzal/ y configura
../quetzal/commands/sdd-init        # Detecta React/Node/Python/etc
../quetzal/commands/skill-registry  # Escanea skills y convenciones
```

---

### 📋 4 Workflows

Workflows predefinidos para situaciones comunes:

| Workflow | Archivo | Descripción |
|----------|---------|-------------|
| **Feature** | `feature-workflow.md` | Crear nueva feature con SDD completo |
| **Bugfix** | `bugfix-workflow.md` | Arreglar bugs con análisis root cause |
| **Refactor** | `refactor-workflow.md` | Refactorización segura paso a paso |
| **PR** | `pr-workflow.md` | Crear y revisar Pull Requests |

Cada workflow incluye:
- Pasos detallados
- Checklists
- Mensajes de Quetzal
- Anti-patrones a evitar

---

### 🎛️ 3 Presets

Modos de operación para diferentes contextos:

| Preset | Archivo | Cobertura | SDD | Aprobaciones |
|--------|---------|-----------|-----|--------------|
| **Strict** | `strict-mode.md` | 80%+ | Obligatorio completo | 2 |
| **Fast** | `fast-mode.md` | 60% objetivo | Simplificado | 1 |
| **Team** | `team-mode.md` | 70% | Estándar | 1 + convenciones |

**Cambiar preset:**
```json
// .quetzal/config.json
{
  "mode": "strict"  // "strict" | "fast" | "team"
}
```

---

## Inspiración

Este Pack Esencial está inspirado en el sistema de **componentes, skills y presets** de [Gentleman AI](https://github.com/Gentleman-Programming/gentle-ai), adaptado con el toque mexicano único de Quetzal.

**Diferencias con Gentleman AI:**
- ✅ Comandos en bash (no requiere CLI en Go)
- ✅ Workflows documentados en markdown
- ✅ Personalidad mexicana auténtica
- ✅ Integración nativa con Engram y Context7

---

## Instalación

Los comandos, workflows y presets se instalan automáticamente con Quetzal. Solo necesitas ejecutar:

```bash
git clone https://github.com/RETBOT/quetzal.git
./quetzal/install.sh
```

Luego en tu proyecto:
```bash
cd mi-proyecto
../quetzal/commands/project-init
```

---

## Personalización

### Agregar Workflows
1. Crea archivo en `workflows/mi-workflow.md`
2. Define trigger, pasos y checklists
3. Documenta en este README

### Agregar Presets
1. Crea archivo en `presets/mi-preset.md`
2. Define reglas, cobertura, aprobaciones
3. Agrega mensajes característicos de Quetzal

### Agregar Comandos
1. Crea script en `commands/mi-comando`
2. Hazlo ejecutable: `chmod +x commands/mi-comando`
3. Sigue el formato de los comandos existentes

---

## Flujo de Trabajo Completo

```bash
# 1. Clonar Quetzal
git clone https://github.com/RETBOT/quetzal.git

# 2. Instalar Quetzal (instala Engram, Context7, etc)
cd quetzal
./install.sh

# 3. Ir a tu proyecto
cd ../mi-proyecto

# 4. Inicializar con Quetzal
../quetzal/commands/project-init

# 5. Configurar SDD para tu stack
../quetzal/commands/sdd-init

# 6. Registrar skills
../quetzal/commands/skill-registry

# 7. Abrir OpenCode y empezar a trabajar con Quetzal
```

---

## Ejemplo de Uso

**Usuario:** "Quiero crear una feature de login"

**Quetzal con Pack Esencial:**
> "Órale, vamos a crear login. Primero veo qué preset tienes activo..."
> 
> "Tienes activado team-mode. Perfecto para este equipo."
>
> "Vamos a seguir el feature-workflow:"
> "1. Primero aplicamos SDD completo..."
> "2. Veo que usas React, así que aplico las convenciones de React..."
> "3. Necesitamos 70% coverage y 1 aprobación..."
>
> [Proceso completo con SDD, tests, implementación]
>
> "Listo, feature lista. Guardé las decisiones en Engram para el equipo."

---

**¡A darle que es mole de olla!** 🦜🌮
