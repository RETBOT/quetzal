# 🎯 Skills de Quetzal

Las skills son capacidades especializadas que Quetzal puede invocar según la tarea.
Están en formato nativo de OpenCode: cada una en `skills/<nombre>/SKILL.md` con
frontmatter (`name` + `description`). OpenCode las descubre automáticamente desde
los directorios de config (`~/.config/opencode/skills/` o `.opencode/skills/`).

## Skills Disponibles

### Generales

| Skill | Frontmatter name | Cuándo se invoca |
|-------|------------------|------------------|
| 🔍 **code-review** | `code-review` | "Revisa este código", "code review", "qué opinas de esto" |
| 🔨 **refactoring** | `refactoring` | "Refactoriza esto", "simplifica esto", "esto está muy culero" |
| ⚙️ **engineering-flow** | `engineering-flow` | Cambios multiarchivo, "¿cuánto proceso necesita esto?" |
| 🧪 **testing** | `testing` | "Haz tests", "TDD", "cobertura", "valida esto" |

### .NET (Quetzal)

| Skill | Frontmatter name | Cuándo se invoca |
|-------|------------------|------------------|
| 🗄️ **dotnet-efcore** | `dotnet-efcore` | EF Core, LINQ, migraciones, consultas lentas, tracking |
| 📱 **dotnet-maui** | `dotnet-maui` | MAUI, Android/iOS/Windows, navegación, binding |
| 🪟 **dotnet-windows-forms** | `dotnet-windows-forms` | WinForms, Designer, RESX, `.csproj`, build |
| 🌐 **aspnet-mvc** | `aspnet-mvc` | MVC, Razor, controllers, routing, CSRF |

### Web (Quetzal)

| Skill | Frontmatter name | Cuándo se invoca |
|-------|------------------|------------------|
| ⚛️ **react-frontend** | `react-frontend` | Componentes, hooks, re-renders, dónde vive el estado |
| 📊 **devextreme** | `devextreme` | DataGrid, CustomStore, `DataSourceLoader`, virtual scrolling |
| 🟨 **javascript-web** | `javascript-web` | DOM, jQuery, AJAX, async, XSS en cliente |
| 🔌 **api-design** | `api-design` | Contratos REST, versionado, errores, idempotencia |

### Seguridad (Kukulkán)

| Skill | Frontmatter name | Cuándo se invoca |
|-------|------------------|------------------|
| 🕸️ **network-analysis** | `network-analysis` | TCP/IP, DNS, TLS, `tcpdump`, lectura de pcap |
| 🎯 **web-api-pentest** | `web-api-pentest` | Pentest web/API autorizado, OWASP, BOLA |
| 🧾 **vulnerability-triage** | `vulnerability-triage` | "¿Me afecta este CVE?", CVSS, CWE, priorización |
| 🤖 **llm-security** | `llm-security` | Prompt injection, RAG, abuso de herramientas, MCP |
| 🧪 **security-lab-design** | `security-lab-design` | Laboratorios aislados, reproducibilidad, limpieza |

### Legacy

| Skill | Frontmatter name | Estado |
|-------|------------------|--------|
| 📋 **sdd** | `sdd` | Fuera de la ruta activa — ver [`docs/v2.1/LEGACY-SDD-RETIREMENT.md`](../docs/v2.1/LEGACY-SDD-RETIREMENT.md) |

> **Nota v2.1:** las skills marcadas como scaffold en su encabezado fueron reconstruidas
> a partir de `docs/v2.1/SKILLS-REGISTRY.md`, porque el paquete original de 81 archivos
> llegó incompleto. Reemplázalas cuando tengas la versión de referencia.

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
