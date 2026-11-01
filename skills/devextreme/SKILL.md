---
name: devextreme
description: DevExtreme: DataGrid, CustomStore, DataSourceLoader, virtual scrolling y componentes en jQuery, ASP.NET y React. Úsala cuando el usuario pida configurar un grid grande, conectar paginación o filtrado del lado servidor, o diagnosticar problemas de rendimiento y carga de datos en DevExtreme.
---

# DevExtreme

> **Scaffold v2.1** — Reconstruida a partir de `docs/v2.1/SKILLS-REGISTRY.md`. El paquete
> original no incluía esta skill. Sustitúyela cuando llegue la versión de referencia.

## Objetivo

DevExtreme hace mucho por ti, y también mucho a tus espaldas. El grid se siente mágico
hasta que traes 200 mil filas y el navegador se muere.

> *"El DataGrid no es lento. Es lento cuando le das todo lo que tiene la base de datos."*

## Regla principal

**Si el dataset crece, la carga es del servidor.** Virtual scrolling sin paginación en
servidor no es virtual: es un `SELECT *` con buena presentación.

| Volumen | Estrategia |
|---|---|
| < 1 000 filas | Carga completa, filtrado en cliente |
| 1 000 – 50 000 | `CustomStore` + paginación en servidor |
| > 50 000 | `CustomStore` + `DataSourceLoader` + virtual scrolling |

## `CustomStore` (la pieza central)

```js
const store = new DevExpress.data.CustomStore({
  key: "id",
  load(loadOptions) {
    return fetch("/api/pedidos/query", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(loadOptions)
    }).then(r => r.json());
  },
  byKey(id) { return fetch(`/api/pedidos/${id}`).then(r => r.json()); },
  insert(values) { /* ... */ },
  update(key, values) { /* ... */ },
  remove(key) { /* ... */ }
});
```

- El contrato de `load` es fijo: `skip`, `take`, `sort`, `filter`, `requireTotalCount`,
  `group`, `searchValue`. **Respétalo**; si lo reinterpretas, el grid pierde la cuenta.
- Devuelve `{ data, totalCount }`. Sin `totalCount`, el paginador miente.
- `searchValue` llega como string libre: no lo concatenes en SQL. Parámetros, siempre.

## `DataSourceLoader` (servidor .NET)

```csharp
public IActionResult Query([FromBody] DataSourceLoadOptions loadOptions)
{
    var query = _db.Pedidos.AsNoTracking().AsQueryable();
    var resultado = DataSourceLoader.Load(query, loadOptions);
    return Ok(resultado);
}
```

- `DataSourceLoadOptions` interpreta filtros, orden y agrupación. Es potente y peligroso:
  **valida qué campos entran**, porque controla el árbol de expresión.
- `AsNoTracking()` antes de `Load`. Sin eso materializas entidades tracked para nada.
- Proyecta a DTO **antes** del `Load` si el grid no necesita todo: menos columnas, menos
  payload, menos memoria.

### Riesgo de seguridad

`DataSourceLoader` construye expresiones desde el cliente. Si expones una entidad con
navegación amplia, un filtro puede tocar tablas que no querías. Proyecta a un DTO con
solo los campos visibles y **nunca** dejes que el cliente ordene o filtre por columnas
sensibles.

## Virtual scrolling

```js
$("#grid").dxDataGrid({
  dataSource: store,
  scrolling: { mode: "virtual", rowRenderingMode: "virtual" },
  paging: { pageSize: 100 },
  remoteOperations: { paging: true, sorting: true, filtering: true, grouping: true },
  height: 600
});
```

- `remoteOperations` activado en todo lo que el servidor soporte. Si lo dejas en
  cliente con `CustomStore`, el grid pagina pero filtra mal.
- Altura fija. Virtual scrolling sin altura definida no calcula nada.
- `rowRenderingMode: "virtual"` solo si el DOM es el cuello de botella.
- `paging.pageSize` bajo (50–100) con virtual: menos peticiones, scroll fluido.

## Integración con frameworks

| Entorno | Enfoque |
|---|---|
| jQuery / ASP.NET MVC | Widget sobre `$("#el").dxDataGrid(...)`, DevExtreme ASP.NET MVC helpers |
| React | Wrappers `devextreme-react`; no mezclar jQuery y React en el mismo árbol |
| Angular | `devextreme-angular` |

- En React, **no re-inicialices** el widget en cada render. Usa el wrapper y deja que él
  controle el ciclo de vida.
- Mezclar jQuery para manipular un nodo que React controla produce bugs fantasma.
- Un solo sistema de estado por pantalla.

## Problemas frecuentes

| Síntoma | Causa probable |
|---|---|
| Paginador dice "0 de 0" | Falta `totalCount` en la respuesta |
| Filtra solo la página actual | `remoteOperations.filtering` en `false` |
| Scroll salta al inicio | `key` inestable o índice en lugar de id |
| El grid parpadea al ordenar | `dataSource` recreado en cada render |
| Lento con 10 mil filas | Carga completa; falta `CustomStore` |
| Filtro no encuentra nada | Tipo de dato distinto entre cliente y servidor (string vs date) |

## Límites

- No hagas `load` que devuelva todo y pagine en el cliente "porque así ya jala".
- No expongas `DataSourceLoadOptions` sobre una entidad completa.
- No declares que un grid es rápido sin probarlo con el volumen real de producción.
- No mezcles manejo de DOM de jQuery con React en el mismo componente.
