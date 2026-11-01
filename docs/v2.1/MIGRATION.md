# Migración de Quetzal a v2.1.0

## Objetivo

Instalar la arquitectura de dos agentes principales con helpers internos y skills progresivas. Esta es una guía de overlay; no sobrescribe configuraciones de cliente ni actualiza GitHub por sí sola.

## 1. Preparación

1. Actualiza tu clon de `RETBOT/quetzal` y ejecuta `git status --short`.
2. Crea una rama: `feature/quetzal-v2-modular-agents`.
3. Respalda `QUETZAL.md`, `kukulkan.md`, configuraciones de OpenCode/Claude/Codex y el inventario `agents/`, `commands/`, `workflows/`, `skills/`.
4. Compara los archivos de este paquete con los tuyos. No sobrescribas cambios locales.

## 2. Integrar la arquitectura canónica

Fusiona estos elementos:

- `plugin.json` (si existe, actualiza y valida el manifiesto, no lo sustituyas ciegamente).
- `quetzal/QUETZAL.md` y `quetzal/references/`.
- `kukulkan/kukulkan.md` y `kukulkan/references/`.
- `agents/` y `workflows/`.
- `skills/` nuevas. Conserva las skills propias que no sean reemplazadas explícitamente.
- `client-adapters/` e `integrations/`.

Los prompts de agentes son contratos compactos. No pegues sus references completas dentro de ellos.

## 3. Migrar los SDD importados

Lee primero `LEGACY-SDD-RETIREMENT.md`. La propuesta es retirar el `sdd-orchestrator` y los agentes SDD por fases que importaste de Gentle AI. Añade los dos helpers RETBOT, actualiza los permisos y retira las entradas SDD que dependan de esos agentes. No borres artefactos históricos del usuario ni archivos modificados localmente.

La nueva ruta activa es `skills/engineering-flow/` y `workflows/engineering-loop.md`; no es una copia de ODD ni una cadena rígida de agentes.

## 4. OpenCode V1

1. Usa `client-adapters/opencode/opencode.fragment.jsonc` solo si tu instalación sigue usando la configuración V1 (`agent`/`permission.task`).
2. Fusiona el fragmento; no reemplaces modelos, providers, MCP ni el resto de tus agentes.
3. Quetzal debe poder invocar `kukulkan`, `codebase-explorer` e `independent-reviewer`; no debe existir un permiso para `sdd-orchestrator`.
4. Copia las skills a `.opencode/skills/<name>/SKILL.md` o a la ruta global del usuario.

## 5. OpenCode V2

1. Usa exclusivamente el adaptador `client-adapters/opencode-v2/` si tu instalación usa `agents`/`permissions` y agentes Markdown.
2. Copia los archivos de `agents/` de ese adaptador a `.opencode/agents/`.
3. Fusiona `opencode.fragment.jsonc` y `AGENTS.md.fragment` con la configuración e instrucciones existentes.
4. El adaptador define Quetzal como principal, Kukulkán en modo `all` y los helpers ocultos como subagentes.
5. La revisión independiente permite shell únicamente para `git diff` y `git status`; confirma que las reglas tengan prioridad correcta en la versión instalada.

**No mezcles adaptadores V1 y V2.** La sintaxis de permisos y el modelo de agentes no son compatibles entre ambos.

## 6. Claude Code

1. Fusiona `CLAUDE.md.fragment` con tu `CLAUDE.md`.
2. Copia `agents/kukulkan.md`, `agents/codebase-explorer.md` y `agents/independent-reviewer.md` a `.claude/agents/`.
3. Copia las skills a `.claude/skills/`.
4. Quetzal es el agente principal; Kukulkán puede ser invocado directamente o delegado. La experiencia de UI no es idéntica al selector de dos agentes principales de OpenCode.
5. Los helpers solo tienen herramientas de lectura en sus definiciones. Verifica también permisos globales y configuración organizacional.

## 7. Codex

1. Fusiona `AGENTS.md.fragment` con el `AGENTS.md` existente.
2. Copia `kukulkan.toml`, `codebase-explorer.toml` e `independent-reviewer.toml` a `.codex/agents/`.
3. Copia las skills a `.agents/skills/`.
4. Codex hereda sandbox y permisos de la sesión padre. Los roles personalizados no crean por sí solos un límite de seguridad aislado: para tareas de auditoría usa sandbox `read-only` o confirma controles de permisos efectivos antes de delegar.
5. La selección directa de Kukulkán depende de la interfaz y versión del cliente.

## 8. GitHub MCP

La carpeta `integrations/github-mcp/` contiene una receta opcional. No se agrega un `mcp.json` activo al paquete porque requiere configurar autenticación y capacidades deliberadamente. Empieza en lectura, habilita solo `repos`, `issues` y `pull_requests` y no distribuyas tokens en el repositorio.

## 9. Aceptación

Ejecuta `VALIDATION.md`. Prueba: un bug pequeño, una tarea multiarchivo, una modificación WinForms y una tarea con riesgo de seguridad. Registra por cliente qué delegaciones se ejecutaron de verdad.

No hagas commit ni push hasta revisar el diff y aprobarlo.
