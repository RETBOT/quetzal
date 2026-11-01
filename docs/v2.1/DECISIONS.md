# Decisiones de arquitectura RETBOT v2.1

## Agentes

- Principales: Quetzal y Kukulkán.
- Helpers: `codebase-explorer`, `independent-reviewer`.
- No se crean agentes por framework ni subagentes por fase.
- Seguridad vive en Kukulkán; conocimiento tecnológico vive en skills.

## Reemplazo de SDD

Los agentes `sdd-*` importados de Gentle AI no se mantienen como subagentes activos. Se sustituyen por un flujo propio y ligero (`engineering-flow`) y delegación proporcional a dos helpers. Se conserva el historial y los artefactos de usuario; la retirada solo afecta agentes/configuración que se confirmaron como derivados/importados.

Gentle AI v4.0.0 retiró SDD/OpenSpec en favor de ODD, y v4.1.0 documentó limpieza de artefactos SDD heredados. RETBOT toma esto como señal para no mantener sin revisión su copia antigua, pero no copia el workflow ODD ni sus prompts.

## Alcance de los clientes

La lógica de negocio y los contratos de rol son portables en Markdown. La delegación, permisos, UI de agente principal y MCP requieren adaptadores por runtime. Ningún manifiesto Agent Plugins puede garantizar por sí solo que dos agentes hablen entre sí.
