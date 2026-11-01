# Designer y recursos (.resx)

> **Scaffold v2.1** — Referencia declarada por `skills/dotnet-windows-forms/SKILL.md`.
> Reconstruida a partir de su checklist. El paquete original no la incluía.

El diseñador de Windows Forms es un generador de código con supuestos fuertes. Si
esos supuestos se rompen, el formulario sigue compilando pero no abre.

## 1. La estructura de tres archivos

```
MainForm.cs            # tu código; declara la clase partial
MainForm.Designer.cs   # generado por el diseñador; NO lo edites a mano
MainForm.resx          # recursos; imágenes, iconos, strings
```

## 2. Invariantes que el diseñador exige

| Invariante | Dónde vive | Qué rompe si falta |
|---|---|---|
| `partial class MainForm : Form` | ambos `.cs` | CS0260, o el diseñador no encuentra `InitializeComponent` |
| `InitializeComponent()` en el constructor | `MainForm.cs` | El diseñador abre vacío |
| `InitializeComponent` definido en el `Designer.cs` | `Designer.cs` | CS0103 |
| `Dispose(bool)` con `components.Dispose()` | `Designer.cs` | Fuga de recursos; el diseñador puede regenerarlo |
| `#region Windows Form Designer generated code` | `Designer.cs` | Advertencia de regeneración |

## 3. Reglas de edición

- **No edites el `Designer.cs` a mano si el diseñador puede regenerarlo.** Lo que
  escribas se pierde en el primer "Guardar" del diseñador.
- **Si debes editarlo** (build roto, diseñador que no abre, entorno sin Visual
  Studio): conserva las regiones, el orden de declaración y los patrones de
  `SuspendLayout`/`ResumeLayout`.
- **No reordenes el bloque `InitializeComponent`.** El orden importa: los
  contenedores se crean antes de agregarles hijos.
- **No borres `components`.** Es el `IContainer` que libera los controles.

## 4. `.resx`

| Punto | Verifica |
|---|---|
| Inclusión | `EmbeddedResource` con `DependentUpon` del `.cs` |
| Cultura | `MainForm.resx` es neutral; `MainForm.es-MX.resx` es localizado |
| Imágenes | Se referencian por nombre de recurso, no por ruta de archivo |
| Regeneración | El diseñador reescribe el `.resx`; el diff puede ser ruidoso |
| Recursos huérfanos | Un recurso borrado del diseñador puede quedar en el `.resx` |

**Nunca reemplaces un `.resx` existente sin revisar su contenido.** Puede contener
imágenes, iconos o strings que nadie declaró en el código y que se perderían
silenciosamente.

## 5. Síntomas y causa

| Síntoma | Causa probable |
|---|---|
| "El diseñador no puede abrir este archivo" | `InitializeComponent` inexistente, clase no `partial`, o excepción en el constructor |
| El diseñador abre vacío | El `.cs` no llama a `InitializeComponent()` |
| Los controles desaparecen al guardar | Se editaron a mano en el `Designer.cs` y el diseñador regeneró |
| `MainForm.resx` no se encuentra | Falta `DependentUpon`, o el `.resx` no es `EmbeddedResource` |
| La compilación pasa pero el form truena al abrir | `InitializeComponent` lanza excepción: recurso faltante o control null |
| Recursos "fantasma" tras un rename | El diseñador creó `<OldName>.resx` y quedó incluido |

## 6. Cuándo sí toca abrir Visual Studio

Abre el diseñador y guarda, para confirmar que carga sin regenerar errores, cuando:

- Creaste o renombraste un formulario.
- Moviste controles entre contenedores.
- Tocaste `.resx` o recursos anidados.
- El build pasa pero el form no abre.

Si no tienes Visual Studio disponible, **di que esa validación quedó pendiente**.
`dotnet build` no la sustituye.
