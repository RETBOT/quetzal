# RETBOT Quetzal — Evolución v2.1.0

**Dos agentes principales. Dos subagentes de apoyo. Skills especializadas y conocimiento bajo demanda.**

Este paquete es un overlay incremental para `RETBOT/quetzal`. Conserva la identidad principal de Quetzal y Kukulkán, pero elimina el patrón importado de orquestador + subagentes SDD por fases y lo sustituye por dos ayudantes transversales: exploración y revisión independiente.

## Decisiones del propietario

| Decisión | Comportamiento aplicado |
|---|---|
| Quetzal | Proactivo y equilibrado: corrige con evidencia, explica consecuencias y propone una alternativa; no critica preferencias. |
| Kukulkán | Escalamiento inteligente; Quetzal solicita evaluación cuando hay riesgo de seguridad material. |
| Comunicación | Dual: usuario puede hablar con Kukulkán; Quetzal puede delegarle una evaluación cuando el cliente lo permite. |
| Aprobaciones | Continúa cambios seguros; se detiene ante acciones críticas, destructivas, irreversibles o de producción. |
| Windows Forms | Validación completa de proyecto, archivos, referencias, Designer, RESX, recursos y build; prueba visual solo si se ejecutó. |
| Stack | .NET MAUI, Windows Forms, ASP.NET MVC/Razor, React, JavaScript/jQuery, DevExtreme, EF Core, SQL Server y APIs. |

## Arquitectura

```text
Usuario
  ├── Quetzal (principal: diseña, cuestiona, implementa, verifica)
  │    ├── codebase-explorer (subagente interno, solo lectura)
  │    ├── independent-reviewer (subagente interno, solo lectura)
  │    └── Kukulkán (subagente de seguridad; también seleccionable por el usuario)
  │
  └── Kukulkán (principal invocable: mentor y especialista en seguridad)

Skills → conocimiento especializado bajo demanda
References → documentos específicos cargados solo cuando hacen falta
MCP → herramientas externas opcionales, configuradas por cliente
Engineering Loop → flujo de trabajo proporcional, no una cadena fija de fases
```

## Decisión sobre SDD importado

Recomendación aplicada: **retirar los agentes `sdd-*` y `sdd-orchestrator` que fueron incorporados desde Gentle AI**, y no reemplazarlos con otro enjambre de agentes por etapas.

La razón es que Gentle AI v4.0.0 anunció SDD/OpenSpec como retirados en favor de ODD, y v4.1.0 documentó la limpieza de los artefactos SDD que versiones anteriores habían instalado. RETBOT no copia ODD; crea su propio `engineering-flow` ligero y roles auxiliares adaptados a Quetzal. Consulta `LEGACY-SDD-RETIREMENT.md` antes de retirar archivos locales. <https://github.com/Gentleman-Programming/gentle-ai/releases>

Los roles nuevos son complementarios, no especialistas tecnológicos adicionales:

- `codebase-explorer`: hace reconocimiento de solo lectura y devuelve rutas/líneas, flujo y dependencias.
- `independent-reviewer`: revisa cambios relevantes de forma independiente y devuelve hallazgos; nunca los corrige.
- Kukulkán ya es el especialista de seguridad; no se duplica.

## Skills nuevas

**Quetzal:** `engineering-flow`, `dotnet-efcore`, `dotnet-maui`, `dotnet-windows-forms`, `aspnet-mvc`, `react-frontend`, `devextreme`, `javascript-web`, `api-design`.

**Kukulkán:** `network-analysis`, `web-api-pentest`, `vulnerability-triage`, `llm-security`, `security-lab-design`.

La skill `engineering-flow` reemplaza el rol activo de la antigua skill SDD para nuevas tareas. El histórico SDD debe retirarse de forma controlada; no borres artefactos `.sdd`, OpenSpec ni memoria Engram del usuario como parte de esta migración.

## Carga progresiva

1. El cliente carga el prompt corto del agente.
2. El agente elige una skill por `name` y `description`.
3. Lee solo la referencia pertinente indicada por esa skill.
4. Delegación a subagentes solo cuando reduce contexto o mejora independencia.
5. MCP externos se habilitan por cliente y por agente; no están implícitos en el manifiesto.

## Compatibilidad

Agent Plugins v1 estandariza `plugin.json`, `skills/` y `mcp.json`; no estandariza agentes, delegación, workflows ni permisos. Los adaptadores de OpenCode, Claude Code y Codex describen esas diferencias. <https://agent-plugins.org/specification>

Se incluye OpenCode V1 y V2 como adaptadores distintos. No mezcles ambos fragmentos en una misma configuración. Claude Code y Codex reciben roles nativos; sus límites y experiencia de selección no son idénticos a OpenCode.

## Qué no hace este paquete

- No modifica directamente GitHub ni publica un commit/PR.
- No activa MCP ni instala dependencias automáticamente.
- No afirma compatibilidad runtime probada en tu máquina; la validación de paquete es estática y se detalla en `VALIDATION-RESULT.md`.
- No sustituye configuración local, cambios del usuario ni políticas de seguridad del cliente.
