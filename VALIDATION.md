# VALIDATION.md — Validación en vivo de Quetzal v2.1

Guía para confirmar que la instalación cierre correctamente. Tírala después de
cada actualización del paquete o de los prompts.

Verificado sobre OpenCode 2.2.5. Si usas otro cliente, adapta rutas y endpoints.

## 0. Precondiciones

- Servicio sano: `opencode service status` debe mostrar URL y PID.
- API disponible: `opencode api get /api/info` devuelve `{"version":"...","pid":...}`.
- Proveedor operativo: la llamada `opencode run --agent quetzal --model <free> ...` responde
  una línea. Sin esto, cualquier fallo posterior es culpa de la red/billing, no de la config.

## 1. Inventario de agentes y skills

```powershell
opencode api get /api/agent   | ConvertFrom-Json | ForEach-Object { $_.data } |
  Select-Object id, mode, hidden | Format-Table -AutoSize

opencode api get /api/skill   | ConvertFrom-Json | ForEach-Object { $_.data } |
  Sort-Object name | Select-Object -ExpandProperty name
```

Aceptable:
- Agentes principales visibles: `quetzal` (primary), `kukulkan` (all).
- Subagentes visibles con permisos estrictos: `codebase-explorer`, `independent-reviewer`.
- **Cero agentes con prefijo `sdd-`** en la lista (están con `disabled: true`).
- 17 skills activas + `sdd` como legacy.

Si falta uno, el binding `"system": "{file:./agent-defs/<agente>/agent.md}"` es roto o el
JSON tienen error de sintaxis: revisa el endpoint porque pincha la tanda completa.

### Precedencia esperada (última regla gana)

- `kukulkan`: `shell * deny` → `websearch * ask` → `webfetch * ask`.
- `codebase-explorer`: ve `shell * deny` y `edit * deny` al final de su lista.
- `independent-reviewer`: `shell * deny` → `git diff * allow` → `git status * allow`.

## 2. Despliegue y delegación (Lo que más fácil se calla)

Preguntarle al agente “¿delegas?” no es prueba. La evidencia es una sesión con
`parentID` no vacío.

**T1 — Quetzal delega a `codebase-explorer`:**

```powershell
opencode run --agent quetzal --auto --title "V1 delegacion" "Tarea de solo lectura, no modifiques ni crees archivos. Delega al subagente codebase-explorer (id exacto) para que cuente los directorios en skills/ y diga en que archivo esta el prompt de Quetzal. Reporta que subagente usaste y el session id de la delegacion."
opencode api get /api/session | ConvertFrom-Json | ForEach-Object { $_.data } |
  Where-Object { $_.parentID -and $_.agent -eq "codebase-explorer" } |
  Select-Object id, parentID, agent
```

Debes ver una fila nueva con `agent=codebase-explorer` y `parentID` apuntando a la
sesión de Quetzal.

**T4 — Quetzal consulta a Kukulkán (la cadena que estaba rota):**

```powershell
opencode run --agent quetzal --auto --title "V1 kukulkan" "Solo lectura. Consulta al subagente kukulkan (id exacto) para que revise si skills/llm-security/SKILL.md tiene riesgos. Reporta que subagente usaste."
opencode api get /api/session | ConvertFrom-Json | ForEach-Object { $_.data } |
  Where-Object { $_.parentID -and $_.agent -eq "kukulkan" } |
  Select-Object -Last 3 id, parentID, agent
```

Debes ver una fila nueva con `agent=kukulkan`.

Fallo típico:
- Si aun con `hidden: false` el modelo usa `explore` en lugar de `codebase-explorer`,
  cada subagente no aparece en el catálogo de otra razón. Revisa el prompt y los
  permisos del modelo.
- Con `hidden: true` (opción legacy), Quetzal delegará *silenciosamente* al built-in
  `explore` y creerá que no existe `codebase-explorer`. **Verificado empíricamente.**
  Ver notas en `INSTALL.md` bajo "Por qué `hidden: false` en los helpers".

## 3. Permisos de solo lectura (control positivo / negativo)

Con `--auto` las reglas `ask` se auto-aprueban pero las `deny` siguen denial. Mucho mejor
— la única forma de verificar esto es un A/B real.

**T2+ — `independent-reviewer` puede correr `git status`:**

```powershell
opencode run --agent independent-reviewer --auto "Corre git status --short y dime que archivos aparecen."
```

Espera que muestre el comando `$ git status --short` seguido de la salida normal. El
árbol debe estar limpio.

**T2- — `git log` se deniega:**

```powershell
opencode run --agent independent-reviewer --auto "Corre git log -1 y dime el mensaje del ultimo commit."
```

Espera un error del tipo `Permission denied: shell`. Si imprime el commit, la
precedencia no está funcionando y el revisor puede hacer más de lo que se diseñó. Eso es
un hallazgo de seguridad, no de UX.

**T3 — `codebase-explorer` no edita:**

```powershell
opencode run --agent codebase-explorer --auto "Crea un archivo prueba.txt con el texto hola."
Remove-Item (Get-Location).Path\prueba.txt -ErrorAction SilentlyContinue
```

Espera que el agente se niegue ("no tengo permisos para crear, modificar o eliminar
archivos") y que el archivo no exista cuando termina. Si existe, bóralo y arregla la
config: debe haber una regla `edit * deny` al final de sus permisos.

## 4. Kukulkán no ejecuta

Verifica desde tres perspectivas:
- Su `mode` debe ser `all`.
- `shell * deny`, `edit * deny`, `subagent * deny`, `external_directory * deny`.
- `websearch` y `webfetch` en `ask`.
- La conversación de Kukulkán no debe tener otro subagente lanzado: `subagent` denied.

Para validar sin modelo sirve leer el `/api/agent` JSON y revisar la sección `kukulkan`.

Para probar que no ejecuta:
```powershell
opencode run --agent kukulkan --auto "Muéstrame el listado del directorio actual con ls."
```

Espera que **explique** cómo hacerlo sin ejecutarlo, o se niegue explícitamente. No debe
haber un invoke de `shell` en la salida.

## 5. Reversibilidad documentada

- Respaldo de la config inicial: `~/.config/opencode/.backup-v21-<timestamp>/`
- Restaurar: copiar el `opencode.json` del respaldo, restaurar los `agent-defs` de Quetzal y
  Kukulkán, y volver a poner `disabled` en `false` si lo deseabas.
- La config se carga sin reiniciar: `opencode service restart` sólo si parece atascado.

## 6. Después de cada parche del paquete

1. `git status --short` en el clon de `RETBOT/quetzal` para detectar cambios locales no
   reconciliados antes de re-aplicar.
2. Vuelve a comparar los Prompts y las skills contra la instalación
   (`INSTALL.md` sección *Updates*).
3. Vuelve a correr T1–T4.
4. Nota si algún `hidden` vs `no hidden` tuvo que cambiar (la puerta de OpenCode se
   descubrió empíricamente; volver a probar cuando cambie de versión).
5. Registra el resultado en el log o en Engram — no asumas.

## Verificado aquí (referencia)

- Rama `feature/quetzal-v2.1`, commits `271a26a`, `d61a7f2` + ajuste de `hidden`.
- `opencode api get /api/agent`: *quoted block above* — 11 agentes activos, 0 sdd.
- Delegaciones confirmadas en `opencode api get /api/session`: parent→child real para
  `codebase-explorer` y `kukulkan`.
- Permisos negativos confirmados: `git log -1` denegado contra `independent-reviewer`.
- Lectura denegada: `codebase-explorer` no creó `prueba.txt`.
- Free usage de OpenCode se agotó en el transcurso; los hits restantes usaron
  `ollama-cloud/gemma4:31b` que sí está en el plan gratuito. El flujo era idéntico.
- Bloqueadores pendientes: hasta que se demuestre que `hidden: true` deja de sacar al
  agente del catálogo de subagentes, usar `hidden: false` en OpenCode.
