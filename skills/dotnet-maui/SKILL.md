---
name: dotnet-maui
description: .NET MAUI multiplataforma (Android, iOS, Windows, macOS): navegación, inyección de dependencias, ciclo de vida, XAML y rendimiento de listas. Úsala cuando el usuario pida crear pantallas, configurar navegación, resolver problemas de binding, o diagnosticar diferencias de comportamiento entre plataformas.
---

# .NET MAUI

> **Scaffold v2.1** — Reconstruida a partir de `docs/v2.1/SKILLS-REGISTRY.md`. El paquete
> original no incluía esta skill. Sustitúyela cuando llegue la versión de referencia.

## Objetivo

Una app multiplataforma no es la misma app compilada cuatro veces. Es código compartido
con comportamiento que cambia por plataforma, y eso hay que asumirlo desde el diseño.

> *"MAUI escribe una vez y depura cuatro. Si no lo planeaste, lo vas a sufrir cuatro veces."*

## Regla principal

**Distingue lo compartido de lo nativo desde el primer archivo.** Todo lo que toque
hardware, permisos o apariencia va a necesitar código por plataforma, y mientras más
tarde lo separes, más caro sale.

| Capa | Vive en | Compartible |
|---|---|---|
| Lógica de negocio | `.NET` puro | ✅ 100% |
| ViewModels | Proyecto MAUI | ✅ |
| Vistas XAML | Proyecto MAUI | ✅ con matices de estilo |
| APIs de plataforma | `Platforms/<plataforma>/` | ❌ por definición |
| Permisos y manifiestos | `Platforms/`, `.csproj` | ❌ por definición |

## Estructura de carpetas

```
Platforms/
├── Android/  AndroidManifest.xml, MainActivity, MainApplication
├── iOS/      Info.plist, AppDelegate
├── MacCatalyst/
└── Windows/  Package.appxmanifest, App.xaml
```

Código condicional en compartido, solo cuando no hay otra:

```csharp
#if ANDROID
    ...
#elif IOS
    ...
#endif
```

Si aparece tres veces, es una interfaz en compartido con implementación por plataforma.

## Inyección de dependencias

```csharp
builder.Services.AddSingleton<IServicioApi, ServicioApi>();
builder.Services.AddTransient<PaginaPedidos>();
builder.Services.AddTransient<PedidosViewModel>();
```

| Vida | Usa para |
|---|---|
| Singleton | Servicios sin estado, clientes HTTP (`HttpClient`), configuración |
| Transient | Páginas, ViewModels |
| Scoped | Poco útil en MAUI; el concepto de request no aplica igual |

- Registrar y **resolver** por DI, no instanciar `new Pagina()` en la navegación: se
  pierde todo el grafo de dependencias.
- `Shell` resuelve automáticamente si el tipo está registrado y la ruta es por tipo.

## Navegación

| Estilo | Cuándo |
|---|---|
| `Shell` con rutas | App nueva, navegación por pestañas o flyout |
| `NavigationPage` + `PushAsync` | App existente, o control fino del stack |
| Modales | Confirmaciones, formularios cortos |

- `QueryProperty` para pasar parámetros a la página destino; no guardes estado en
  estáticos para "comunicarte" entre pantallas.
- `Shell.Current.GoToAsync("..")` para retroceder.
- Un `ViewModel` no debe navegar directamente: expón un comando y deja que la vista
  decida, o inyecta un servicio de navegación.

## Ciclo de vida

| Evento | Dónde | Se usa para |
|---|---|---|
| `OnAppearing` | Página | Cargar datos al mostrarse |
| `OnDisappearing` | Página | Detener temporizadores, cancelar cargas |
| `CreateWindow` | `App` | Configuración inicial de ventana |
| `OnSleep` / `OnResume` (vía ciclo de plataforma) | Por plataforma | Pausar/reanudar |

- `OnAppearing` se dispara **cada vez** que la página aparece, no solo la primera.
  Pon la carga bajo una bandera o en el constructor si debe ser una sola vez.
- No hagas I/O bloqueante en `OnAppearing`: congela la UI antes de dibujarse.
- Cancela lo pendiente en `OnDisappearing` o vas a actualizar una vista que ya no existe.

## XAML y binding

- `x:DataType` en cada vista. Sin él pierdes compilación de bindings y los errores se
  vuelven silenciosos en runtime.
- `BindingMode` explícito. `OneWay` es el default en muchos controles y es la causa
  número uno de "escribo y no se guarda".
- `INotifyPropertyChanged` en el ViewModel (o `CommunityToolkit.Mvvm` con
  `[ObservableProperty]`). Una propiedad sin notificación no actualiza la vista.
- `ObservableCollection<T>` para listas que cambian, no `List<T>`.

## Listas y rendimiento

| Técnica | Cuándo |
|---|---|
| `CollectionView` (no `ListView`) | Siempre en MAUI moderno |
| `ItemsUpdatingScrollMode` | Cargas incrementales |
| Plantillas simples | Cada capa de XAML cuesta en scroll |
| `x:DataType` + binding compilado | Siempre |
| Paginación en servidor | Más de ~200 elementos |

Una lista que va bien en Windows puede ir a tirones en Android de gama media. **Prueba
en hardware real, no solo en el emulador.**

## Permisos y manifiestos

- Android: `AndroidManifest.xml` + `Permissions` en `Platforms/Android/`.
- iOS: `Info.plist` con la clave de descripción de uso; sin ella la app truena al pedir.
- Windows: capacidades en `Package.appxmanifest`.
- `Permissions.RequestAsync<T>()` en MAUI con manejo del caso denegado. Un permiso no
  se asume concedido.

## Límites

- No declares "funciona en Android" sin correrlo en Android.
- No metas lógica de negocio en `code-behind` porque es más rápido hoy.
- No uses `Device.OnPlatform` en todas partes: si aparece mucho, el diseño está mal.
- No prometas Windows Forms y MAUI como equivalentes: son modelos distintos.
