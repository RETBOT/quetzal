# Inclusión de archivos en el proyecto

> **Scaffold v2.1** — Referencia declarada por `skills/dotnet-windows-forms/SKILL.md`.
> Reconstruida a partir de su checklist. El paquete original no la incluía.

El error más común en Windows Forms no es de C#: es un archivo que existe en disco
pero el proyecto no lo compila, o que se compila dos veces.

## 1. Identifica el estilo del proyecto

| Estilo | Cómo se reconoce | Inclusión de archivos |
|---|---|---|
| **.NET Framework clásico** | `<Project ToolsVersion=...>` sin `<Sdk>` | Explícita: cada archivo necesita su nodo |
| **SDK-style** | `<Project Sdk="Microsoft.NET.Sdk">` | Automática: todo lo que esté bajo el directorio, salvo `EnableDefaultCompileItems=false` |

No asumas. Abre el `.csproj` primero.

## 2. Formato clásico: inclusión explícita

```xml
<ItemGroup>
  <Compile Include="Forms\MainForm.cs">
    <SubType>Form</SubType>
  </Compile>
  <Compile Include="Forms\MainForm.Designer.cs">
    <DependentUpon>MainForm.cs</DependentUpon>
  </Compile>
  <EmbeddedResource Include="Forms\MainForm.resx">
    <DependentUpon>MainForm.cs</DependentUpon>
  </EmbeddedResource>
</ItemGroup>
```

Reglas:

- El `.cs` principal **no** lleva `DependentUpon`.
- El `Designer.cs` y el `.resx` **sí** llevan `DependentUpon` apuntando al `.cs`.
- Sin `DependentUpon`, Visual Studio muestra los tres archivos sueltos y el
  diseñador no los trata como un formulario.
- El `SubType` de un formulario es `Form`; en UserControl es `UserControl`.

## 3. SDK-style: inclusión automática

Todo `.cs` bajo el directorio se compila sin declararlo. Solo declaras excepciones:

```xml
<ItemGroup>
  <Compile Remove="Legacy\**" />
  <EmbeddedResource Remove="Legacy\**" />
</ItemGroup>
```

Si el proyecto tiene `EnableDefaultCompileItems=false`, se comporta como el clásico
y necesitas inclusión explícita.

## 4. Checklist de archivos no incluidos

Cuando el síntoma es "el tipo existe pero no compila" o "no aparece en el diseñador":

1. ¿El archivo está en disco? → `glob`
2. ¿El `.csproj` lo incluye de la forma correcta para su estilo?
3. ¿Está incluido dos veces? (`Compile Include` + inclusión automática) → duplica
   la clase y da CS0101.
4. ¿El namespace del archivo coincide con su carpeta y con el `RootNamespace`?
5. ¿El `.resx` está como `EmbeddedResource` y no como `None`?

## 5. Referencias

| Tipo | Nodo | Cuándo |
|---|---|---|
| Proyecto | `<ProjectReference Include="...">` | Otro proyecto de la misma solución |
| Ensamblado | `<Reference Include="System.X">` | Framework clásico, GAC |
| Paquete | `<PackageReference Include="..." Version="...">` | NuGet, moderno |

En clásico, un paquete NuGet puede requerir además el `HintPath` del ensamblado en
`packages.config`. Si migras de `packages.config` a `PackageReference`, hazlo en un
cambio separado.
