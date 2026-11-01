---
name: dotnet-efcore
description: EF Core con LINQ, SQL Server, migraciones, tracking y rendimiento. Úsala cuando el usuario pida modelar entidades, escribir consultas LINQ, crear o revisar migraciones, diagnosticar consultas lentas o resolver problemas de tracking y concurrencia.
---

# EF Core

> **Scaffold v2.1** — Reconstruida a partir de `docs/v2.1/SKILLS-REGISTRY.md`. El paquete
> original no incluía esta skill. Sustitúyela cuando llegue la versión de referencia.

## Objetivo

Que EF Core genere el SQL que crees que genera.

> *"El ORM no es magia, es un generador de SQL con opiniones. Si no sabes qué SQL sale, no sabes qué está pasando."*

## Regla principal

**Lee la consulta que se ejecuta, no la que escribiste.** Toda sospecha de rendimiento
se resuelve mirando el SQL real, no leyendo el LINQ.

## Ciclo de vida del `DbContext`

| Host | Registro | Vida |
|---|---|---|
| ASP.NET Core | `AddDbContext<T>()` | Scoped (uno por request) |
| WinForms / MAUI / consola | `AddDbContextFactory<T>()` | Factory, uno por operación |

- **Nunca** un `DbContext` estático ni singleton: no es thread-safe.
- En app de escritorio, un contexto por unidad de trabajo — no uno abierto toda la sesión.
- Si el contexto vive mucho, el change tracker crece sin control y las consultas se degradan.

## Tracking

```csharp
// Solo lectura → siempre
var lista = await ctx.Pedidos.AsNoTracking().Where(...).ToListAsync();

// Proyección → ni siquiera materializas la entidad
var dto = await ctx.Pedidos
    .AsNoTracking()
    .Select(p => new PedidoDto { Id = p.Id, Total = p.Total })
    .ToListAsync();
```

- `AsNoTracking()` para lectura. Es la diferencia más grande y la más barata.
- `AsNoTrackingWithIdentityResolution()` solo si el grafo repite entidades y necesitas
  una sola instancia.
- Actualizar sin traer: `ExecuteUpdate` / `ExecuteDelete` (EF Core 7+). Un `UPDATE`
  masivo no debería pasar por memoria.

## N+1: el asesino silencioso

```csharp
// MAL: una consulta por pedido
foreach (var p in pedidos)
    var items = p.Items;   // lazy loading → N consultas

// BIEN: una consulta con join
var pedidos = await ctx.Pedidos
    .AsNoTracking()
    .Include(p => p.Items)
    .ToListAsync();
```

- `Include` sin `AsSplitQuery` en colecciones grandes puede multiplicar filas. Mide.
- `Include` de más es tan malo como N+1: trae columnas que no usas.
- Considera `AsSplitQuery()` cuando hay dos o más colecciones incluidas.

## Migraciones

| Regla | Por qué |
|---|---|
| Una migración = un cambio coherente | Revertir una migración con cinco cambios mezclados es imposible |
| Revisa el `Up`/`Down` generado | EF adivina; a veces borra y recrea en lugar de renombrar |
| No edites migraciones ya aplicadas en producción | El historial queda inconsistente |
| Migración y modelo se commitean juntos | Si no, el próximo `migrate` no reproduce el esquema |
| `dotnet ef migrations script` antes de producción | Un `update` ciego en prod es una apuesta |

Operaciones destructivas (drop column, drop table, cambio de tipo con pérdida):
**pide confirmación explícita antes de generarlas.**

## Concurrencia

- `[Timestamp]` / `IsRowVersion()` para token de concurrencia → `DbUpdateConcurrencyException`.
- No lo resuelvas con `catch` vacío. Decide: recargar, ganar el último, o informar al usuario.
- Sin token de concurrencia, el último que escribe gana y nadie se enteró.

## SQL Server: detalles que muerden

| Síntoma | Causa típica |
|---|---|
| Consulta lenta de repente | Plan cacheado malo, o falta índice en la columna del `Where` |
| Deadlock intermitente | Orden de acceso inconsistente entre transacciones |
| `String` sin límite | `nvarchar(max)` impide índices y duele en memoria |
| Decimal con redondeo | `float` en lugar de `decimal` para dinero |
| Fechas desfasadas | `DateTime` sin `DateTimeKind`; usa `DateTimeOffset` si cruza zonas |

- Declara `HasMaxLength` y precisión de decimal explícitamente.
- Revisa `ctx.Database.Log` o logging de EF para ver el SQL cuando investigues.
- Un índice faltante se detecta con el plan de ejecución de SQL Server, no adivinando.

## Límites

- No desactives el tracking globalmente "para que vaya más rápido" sin medir.
- No uses `FromSqlRaw` con interpolación de strings → inyección SQL. Usa parámetros.
- No pongas lógica de negocio en `OnModelCreating` más allá de configuración.
- No declares éxito de rendimiento sin una medición antes/después.
