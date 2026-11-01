---
name: engineering-flow
description: Flujo proporcional de ingeniería para Quetzal: entender, explorar, advertir, consultar seguridad, construir, verificar, revisar y entregar. Úsala para cambios no triviales, tareas multiarchivo o cuando haya que decidir cuánto proceso aplicar. Reemplaza a la skill `sdd` como ruta activa.
---

# Engineering Flow

> **Scaffold v2.1** — Reconstruida a partir de `docs/v2.1/engineering-loop.md` y
> `docs/v2.1/SKILLS-REGISTRY.md`. El paquete original no incluía esta skill.

## Objetivo

Implementar cambios sin imponer ceremonia pesada. El proceso es proporcional al
riesgo, no al número de archivos.

**Fuente de verdad del flujo:** [`workflows/engineering-loop.md`](../../workflows/engineering-loop.md).
Esta skill no lo duplica: te dice cuándo cargarlo y cómo aplicarlo.

## Cuándo cargarla

- Cambio relevante, multiarchivo o con decisiones difíciles de revertir.
- Cuando dudes cuánto proceso aplicar.
- Cuando la tarea huele a SDD completo pero no lo requiere.

## Cuándo NO cargarla

- Typo, rename, fix de una línea, agregar un test o un doc.
- Preguntas, análisis o code review sin cambios.

Si tu primera reacción es "esto necesita un documento de planeación", revisa si de
verdad lo necesita o si es costumbre.

## Las ocho etapas

| # | Etapa | Qué haces | Delegas cuando |
|---|---|---|---|
| 1 | **Entender** | Resultado, alcance, restricciones, estado del repo, criterios de aceptación | — |
| 2 | **Explorar** | Inspeccionas los archivos cercanos tú mismo | `codebase-explorer`, solo si la comprensión transversal o el volumen lo justifica |
| 3 | **Advertir y decidir** | Si ves un defecto: evidencia, severidad, consecuencia, alternativa | — |
| 4 | **Consultar seguridad** | Si hay superficie de seguridad material | `kukulkan`, solo lectura, sin delegación recursiva |
| 5 | **Construir** | Cambio mínimo correcto, convenciones del repo, skill tecnológica pertinente | — |
| 6 | **Verificar** | Build, tests, análisis estático y validación visual, cada uno por separado | — |
| 7 | **Revisar independiente** | Cambios no triviales, transversales, riesgo alto o difícil de revertir | `independent-reviewer`, solo lectura |
| 8 | **Entregar** | Cambios, decisiones, pruebas ejecutadas, limitaciones, riesgos residuales | — |

## Reglas de proporcionalidad

- No crees documentos de planeación para cada cambio pequeño.
- No delegues solo para cumplir un número de archivos.
- No hagas que dos agentes editen simultáneamente los mismos archivos.
- **Quetzal es el único responsable de integrar el cambio.**
- El usuario mantiene la decisión final sobre alcance, riesgo y publicación.

## Verificación: no mezcles niveles

| Nivel | Qué prueba | Qué NO prueba |
|---|---|---|
| Build | Compila | Que funcione, ni que la UI cargue |
| Tests | Comportamiento cubierto | Lo que no está cubierto |
| Análisis estático | Patrones y tipos | Correctitud de negocio |
| Validación visual | Que la pantalla/diseñador abre | Que el flujo completo jale |

**Nunca declares verificada una acción que no ejecutaste.** Si el diseñador de
Visual Studio no está disponible, di que esa parte quedó pendiente.

## Entregable

```
Cambios: <qué cambió y dónde>
Decisiones: <las que no eran obvias y por qué>
Verificación: <qué corriste de verdad y qué salió>
Limitaciones: <qué no pudiste comprobar>
Riesgos residuales: <los que quedan abiertos>
```

## Relación con lo anterior

La skill `sdd` queda fuera de la ruta activa. Conserva el historial y los artefactos
`.sdd`/OpenSpec existentes como documentación histórica — no los borres. Consulta
[`docs/v2.1/LEGACY-SDD-RETIREMENT.md`](../../docs/v2.1/LEGACY-SDD-RETIREMENT.md).
