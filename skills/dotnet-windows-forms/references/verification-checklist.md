# Gate de aceptación — Windows Forms

> **Scaffold v2.1** — Referencia declarada por `skills/dotnet-windows-forms/SKILL.md`.
> Reconstruida a partir de su checklist. El paquete original no la incluía.

No declares un cambio de Windows Forms terminado hasta pasar cada casilla que
aplique. Marca `N/A` con razón, no en silencio.

## A. Proyecto

- [ ] Identifiqué el estilo: .NET Framework clásico o SDK-style.
- [ ] Confirmé el TFM y `UseWindowsForms` si es SDK-style.
- [ ] Revisé el `.csproj` antes de crear o editar archivos.
- [ ] `dotnet build` (o MSBuild) del **proyecto** pasa sin errores nuevos.
- [ ] `dotnet build` de la **solución** pasa sin errores nuevos.

## B. Archivos

- [ ] Cada archivo nuevo está incluido según el estilo del proyecto.
- [ ] No hay inclusión duplicada (CS0101).
- [ ] Los archivos eliminados también se quitaron del `.csproj` si es clásico.
- [ ] Los namespaces coinciden con la carpeta y el `RootNamespace`.

## C. Formulario

- [ ] `Form.cs` y `Form.Designer.cs` declaran la misma clase `partial`.
- [ ] La clase hereda de `Form` (o `UserControl` si aplica).
- [ ] El constructor llama a `InitializeComponent()`.
- [ ] `InitializeComponent` existe en el `Designer.cs`.
- [ ] `Dispose(bool)` está presente y libera `components`.

## D. Designer y recursos

- [ ] `DependentUpon` apunta al `.cs` correcto en el `Designer.cs` y el `.resx`.
- [ ] El `.resx` está como `EmbeddedResource`.
- [ ] No edité el `Designer.cs` a mano sin necesidad.
- [ ] Si lo edité, conservé regiones, orden y patrones existentes.
- [ ] No reemplacé un `.resx` sin revisar su contenido.

## E. Referencias

- [ ] `ProjectReference` de los proyectos necesarios.
- [ ] `Reference` de los ensamblados del framework clásico.
- [ ] `PackageReference` de los paquetes NuGet, o `packages.config` consistente.
- [ ] Ninguna referencia quedó huérfana tras un rename o borrado.

## F. Validación visual

- [ ] Abrí el diseñador en Visual Studio y cargó sin errores. ← **o**
- [ ] Informé explícitamente que la validación visual **quedó pendiente** porque
      Visual Studio no está disponible.

## G. Entrega

- [ ] Corrí el build yo mismo; no lo estoy suponiendo.
- [ ] Distinguí lo que verifiqué de lo que no.
- [ ] No declaré el diseñador verificado basándome solo en `dotnet build`.

---

> **El build no es la validación visual.** Un formulario puede compilar, pasar todos
> los tests y tronar en `InitializeComponent` al abrirse. Si no lo abriste, no lo
> declaraste verificado.
