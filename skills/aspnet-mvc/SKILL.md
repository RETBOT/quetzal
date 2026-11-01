---
name: aspnet-mvc
description: ASP.NET MVC y Razor: controllers, routing, view models, validación y seguridad de requests. Úsala cuando el usuario pida crear controladores o vistas, configurar rutas, validar formularios, o revisar autorización, CSRF y manejo de errores en una app MVC.
---

# ASP.NET MVC (Razor)

> **Scaffold v2.1** — Reconstruida a partir de `docs/v2.1/SKILLS-REGISTRY.md`. El paquete
> original no incluía esta skill. Sustitúyela cuando llegue la versión de referencia.

## Objetivo

MVC se degrada solo. Sin disciplina, el controlador se vuelve un archivo de 800 líneas
con SQL, reglas de negocio y HTML concatenado.

> *"Si tu controller tiene más de 15 líneas por acción, ya no es un controller: es un servicio disfrazado."*

## Regla principal

**El controller orquesta; no decide ni calcula.** Recibe, delega, responde.

```
Request → Routing → Controller.Action → Servicio/Caso de uso → View/JSON
```

| Responsabilidad | Vive en |
|---|---|
| Validar forma del input | ViewModel + `ModelState` |
| Reglas de negocio | Servicio o caso de uso |
| Persistencia | Repositorio / `DbContext` |
| Formato de salida | Vista Razor o resultado JSON |
| Autorización | Filtros / atributos, no `if` en el body |

## Controllers

```csharp
[Authorize]
public class PedidosController : Controller
{
    private readonly IPedidoService _svc;
    public PedidosController(IPedidoService svc) => _svc = svc;

    [HttpGet]
    public async Task<IActionResult> Details(int id, CancellationToken ct)
    {
        var pedido = await _svc.ObtenerAsync(id, ct);
        if (pedido is null) return NotFound();
        return View(pedido);
    }
}
```

- Acciones asíncronas con `CancellationToken` de punta a punta.
- `IActionResult` explícito: `NotFound()`, `BadRequest()`, `Forbid()`. No devuelvas 200
  con un mensaje de error adentro.
- **IDOR:** un `id` que viene del usuario **no** autoriza nada. Verifica ownership
  contra el usuario autenticado, siempre.

## ViewModels, no entidades

- Nunca expongas la entidad de EF en la vista: filtra columnas, evita over-posting y
  desacopla el esquema de la UI.
- `[Bind]` explícito o ViewModel dedicado. Un `Bind` de entidad completa permite que el
  cliente escriba `Rol = "Admin"` en el form.
- Sin `ViewBag`/`ViewData` para datos tipados: usa el ViewModel.

## Validación

```csharp
public class CrearPedidoVm
{
    [Required, StringLength(100)]
    public string Cliente { get; set; } = "";

    [Range(1, 1000)]
    public int Cantidad { get; set; }
}
```

- `ModelState.IsValid` antes de tocar el servicio. Y vuelve a validar en el servidor
  aunque el JS ya lo hizo: el JS es del cliente.
- Data annotations para forma; reglas de negocio en el servicio, con errores propios.
- `ModelState.AddModelError` con mensajes que el usuario entienda.

## Seguridad del request

| Riesgo | Control |
|---|---|
| CSRF | `@Html.AntiForgeryToken()` + `[ValidateAntiForgeryToken]` en todo POST |
| XSS | Razor escapa por defecto. `@Html.Raw()` solo con contenido propio y sanitizado |
| Inyección SQL | Parámetros siempre; nunca concatenes input en SQL |
| Mass assignment | ViewModel dedicado, nunca la entidad |
| Open redirect | Valida `returnUrl` contra rutas locales antes de redirigir |
| Clickjacking | `X-Frame-Options` / CSP con `frame-ancestors` |
| HTTPS | `[RequireHttps]` o `UseHttpsRedirection` |
| IDOR | Verificación de ownership en cada acceso por id |

- `[Authorize]` a nivel de controller por defecto; `[AllowAnonymous]` explícito donde
  deba ser público. Es más seguro olvidar abrir que olvidar cerrar.
- Autoriza por **política o rol**, no por nombre de rol hardcodeado repetido en 40 acciones.

## Routing

- Rutas por atributo (`[Route]`) en apps nuevas: explícitas y fáciles de auditar.
- `{id:int}` con constraint evita que `details/abc` llegue al action.
- Una ruta por recurso. Si necesitas cinco rutas para "rellenar" un CRUD, sobra una.

## Errores y logging

- `customErrors` / `UseExceptionHandler`: el usuario nunca ve el stack trace.
- Log con contexto (`usuario`, `id`, `correlación`), sin datos sensibles.
- 404 ≠ 500 ≠ 400. Cada uno con su página y su log.

## Límites

- No pongas SQL directo en el controller. Ni "rapidito".
- No devuelvas la entidad de EF y luego filtres en la vista.
- No declares seguro un formulario sin verificar el token antiforgery.
- No asumas que una ruta está protegida porque "el link no aparece en el menú".
