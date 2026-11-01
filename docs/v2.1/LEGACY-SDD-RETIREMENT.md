# Retiro controlado de los subagentes SDD importados

## Recomendación

Sí: retirar `sdd-orchestrator` y los agentes de fases `sdd-*` que se copiaron desde Gentle AI. Sustituir su función operativa por el `engineering-flow` de RETBOT más dos helpers acotados (`codebase-explorer`, `independent-reviewer`). No crear un subagente por cada fase o tecnología.

## Por qué

Gentle AI publicó en su release v4.0.0 que SDD y OpenSpec se retiraban en favor de ODD como ruta de desarrollo. v4.1.0 documentó la limpieza de agentes, skills, comandos y bloques SDD heredados en instalaciones anteriores. Esto no obliga a RETBOT a adoptar ODD ni a actualizar Gentle AI; sí indica que mantener sin cambios el conjunto SDD antiguo implica conservar una arquitectura que su proyecto de origen ya retiró.

Fuentes:

- Release v4.0.0 y notas de lanzamiento: https://github.com/Gentleman-Programming/gentle-ai/releases
- Componentes y estado de SDD/ODD: https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/components.md
- Licencia MIT upstream: https://github.com/Gentleman-Programming/gentle-ai/blob/main/LICENSE

## Qué retirar

Retira únicamente archivos o entradas que hayas confirmado como importados de Gentle AI y que no contengan modificaciones propias importantes:

- `sdd-orchestrator` y agentes de fase (`sdd-init`, `sdd-explore`, `sdd-propose`, `sdd-spec`, `sdd-design`, `sdd-tasks`, `sdd-apply`, `sdd-verify`, `sdd-archive`, `sdd-onboard` u otros que realmente existan).
- Entradas de esos agentes en `opencode.json[c]`, `.claude/agents/`, `.codex/agents/` o configuración equivalente.
- `permission.task` / `permissions` que permitan llamar `sdd-orchestrator`.
- Comandos o workflows que dependan de esos agentes y queden rotos al retirarlos.

**No ejecutes un borrado wildcard sin revisar el inventario.** Primero usa `git grep -n -i "sdd-"` y `git status --short`; clasifica cada resultado como upstream, personalizado, histórico o dato de usuario. Mantén intactos los archivos modificados por ti hasta reconciliar su contenido.

## Qué conservar o migrar

- Los artefactos históricos de especificaciones, propuestas, decisiones o tareas que ya sean parte del proyecto pueden conservarse como documentación histórica.
- No borres carpetas `.sdd/`, `openspec/` ni registros Engram del usuario automáticamente.
- Si un comando SDD contiene una operación útil que no dependa de un agente retirado, conviértelo a un comando RETBOT propio o migra su función a `engineering-flow`.
- Si quieres conservar contenido sustancial copiado de Gentle AI, conserva también su aviso de copyright/licencia MIT y documenta la procedencia. Este paquete no redistribuye los prompts de fases de Gentle AI.

## Qué instalar en su lugar

- `agents/codebase-explorer.md`
- `agents/independent-reviewer.md`
- `workflows/engineering-loop.md`
- `skills/engineering-flow/`

Kukulkán sigue siendo el especialista de seguridad. No crees `security-reviewer`, `pentest-agent` ni `dotnet-agent`: esas capacidades viven en Kukulkán y en las skills tecnológicas.

## Orden de migración

1. Crea una rama y respaldo.
2. Inventaría los agentes SDD instalados y revisa diferencias locales.
3. Añade y prueba primero los dos roles auxiliares y `engineering-flow`.
4. Actualiza permisos y referencias de delegación.
5. Retira únicamente los agentes SDD confirmados como importados y sin cambios locales pendientes.
6. Deshabilita/retira comandos que dependían de los agentes quitados.
7. Ejecuta `VALIDATION.md` y comprueba una tarea real pequeña y una multiarchivo.
