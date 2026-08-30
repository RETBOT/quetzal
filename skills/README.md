# 🎯 Skills de Quetzal

Las skills son capacidades especializadas que Quetzal puede invocar según la tarea.
Están en formato nativo de OpenCode: cada una en `skills/<nombre>/SKILL.md` con
frontmatter (`name` + `description`). OpenCode las descubre automáticamente desde
los directorios de config (`~/.config/opencode/skills/` o `.opencode/skills/`).

## Skills Disponibles

| Skill | Frontmatter name | Cuándo se invoca |
|-------|------------------|------------------|
| 🔍 **code-review** | `code-review` | "Revisa este código", "code review", "qué opinas de esto" |
| 🔨 **refactoring** | `refactoring` | "Refactoriza esto", "simplifica esto", "esto está muy culero" |
| 📋 **sdd** | `sdd` | "Planear una feature", "diseñar esto", "SDD" |
| 🧪 **testing** | `testing` | "Haz tests", "TDD", "cobertura", "valida esto" |

## Cómo Funcionan

1. Cada skill vive en `SKILL.md` con frontmatter `name` y `description`.
2. OpenCode las descubre e indexa automáticamente desde los directorios de skills.
3. Quetzal invoca la skill adecuada con la tool `skill` según la descripción que
   coincida con la tarea del usuario.

## Agregar una Skill Nueva

1. Crear carpeta `skills/mi-skill/`.
2. Crear `SKILL.md` con frontmatter:
   ```markdown
   ---
   name: mi-skill
   description: Una frase de qué hace Y cuándo usarla.
   ---
   ```
3. [Opcional] Agregar al README.

## Inspiración

Inspiradas en [Gentleman AI](https://github.com/Gentleman-Programming/gentle-ai)
pero con el toque mexicano único de Quetzal. 🌮🦜
