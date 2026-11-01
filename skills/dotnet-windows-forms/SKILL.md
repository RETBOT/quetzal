---
name: dotnet-windows-forms
description: >-
  Crea, corrige y valida aplicaciones Windows Forms en .NET Framework y .NET moderno. Úsala para formularios, Designer, RESX, archivos no incluidos, referencias y errores de compilación o diseñador.
---

# .NET Windows Forms

**Alcance de plataforma:** Windows Forms es una tecnología de escritorio para Windows; no es una UI multiplataforma. Si el requisito incluye Android/iOS/macOS, evalúa .NET MAUI u otra UI multiplataforma en vez de forzar WinForms.

## Regla principal

Un formulario no está terminado solo porque exista un `.cs`. Deben quedar coherentes el código, Designer, recursos, proyecto, referencias y solución.

## Procedimiento obligatorio

1. Identifica si el proyecto es .NET Framework clásico o SDK-style (`Microsoft.NET.Sdk.WindowsDesktop`/`Microsoft.NET.Sdk`), TFM, `UseWindowsForms` y versión de Visual Studio.
2. Inspecciona el `.csproj` y archivos hermanos antes de crear o editar archivos.
3. Comprueba inclusión de cada archivo según el formato de proyecto: inclusiones explícitas (`Compile Include`, `EmbeddedResource`) o inclusión automática SDK; no dupliques entradas.
4. Comprueba `Form.cs`, `Form.Designer.cs`, namespace, clase `partial`, constructor y `InitializeComponent()`.
5. Comprueba metadatos de anidación (`DependentUpon`, `SubType`) y recursos `.resx`/`EmbeddedResource`.
6. Revisa referencias de proyecto (`ProjectReference`), ensamblados (`Reference`) y paquetes (`PackageReference`) necesarios.
7. Compila proyecto y solución; inspecciona errores y warnings relacionados.
8. Si Visual Studio está disponible, abre el diseñador y confirma que carga y guarda sin regenerar errores. Si no está disponible, informa que esa validación quedó pendiente.

## Límites

- No inventes entradas `.csproj`; confirma el estilo del proyecto primero.
- No edites manualmente el Designer si el cambio puede generarse por el diseñador; si debes hacerlo, conserva patrones y regiones existentes.
- No reemplaces un `.resx` existente sin revisar recursos.
- No declares éxito visual basándote solo en `dotnet build`.

## Referencias

- Inclusión del proyecto: `references/project-inclusion.md`.
- Designer y recursos: `references/designer-resx.md`.
- Gate de aceptación: `references/verification-checklist.md`.
