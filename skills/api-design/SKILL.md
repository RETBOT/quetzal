---
name: api-design
description: Diseño de APIs REST: contratos, códigos de estado, errores, versionado, idempotencia y resiliencia. Úsala cuando el usuario pida diseñar endpoints, definir el contrato de una API, decidir cómo versionar, o revisar paginación, reintentos y manejo de errores.
---

# API Design (REST)

> **Scaffold v2.1** — Reconstruida a partir de `docs/v2.1/SKILLS-REGISTRY.md`. El paquete
> original no incluía esta skill. Sustitúyela cuando llegue la versión de referencia.

## Objetivo

Una API es un contrato con gente que no conoces y que no puede preguntarte. Diseña para
el consumidor que llega en dos años sin contexto.

> *"El endpoint que expones hoy no lo puedes cambiar mañana. Diseña como si no existiera el deploy."*

## Regla principal

**Recursos, no acciones.** `POST /pedidos/42/cancelar` es aceptable cuando la operación
no es un CRUD; `GET /obtenerPedidoPorId` no lo es nunca.

## Recursos y verbos

| Verbo | Semántica | Idempotente |
|---|---|---|
| `GET` | Leer, sin efectos | ✅ |
| `POST` | Crear, o acción no idempotente | ❌ |
| `PUT` | Reemplazar completo | ✅ |
| `PATCH` | Modificar parcial | ⚠️ según diseño |
| `DELETE` | Eliminar | ✅ |

```
GET    /pedidos?estado=abierto&page=2&size=50
GET    /pedidos/42
POST   /pedidos
PUT    /pedidos/42
PATCH  /pedidos/42
DELETE /pedidos/42
POST   /pedidos/42/cancelar     # acción de negocio explícita
```

- Sustantivos en plural, en minúsculas, con guiones.
- Sin verbos en la ruta para CRUD.
- Anidamiento máximo dos niveles: `/clientes/7/pedidos` sí, `/clientes/7/pedidos/3/items/9/...` no.

## Códigos de estado

| Código | Cuándo |
|---|---|
| `200` | Éxito con cuerpo |
| `201` | Recurso creado + header `Location` |
| `204` | Éxito sin cuerpo (`DELETE`, `PUT` sin respuesta) |
| `400` | Request malformado o inválido |
| `401` | No autenticado |
| `403` | Autenticado sin permiso |
| `404` | No existe **o no es tuyo** (no filtres si existe) |
| `409` | Conflicto de estado o concurrencia |
| `422` | Validación semántica fallida |
| `429` | Rate limit + `Retry-After` |
| `500` | Error del servidor, sin detalles internos |
| `503` | Dependencia caída + `Retry-After` |

**Nunca devuelvas `200` con `{ "error": ... }`.** Rompe clientes, métricas y proxies.

## Contrato de errores

Un solo formato en toda la API:

```json
{
  "error": {
    "code": "VALIDACION_FALLIDA",
    "message": "El campo 'cantidad' debe ser mayor a cero.",
    "details": [
      { "field": "cantidad", "issue": "min", "value": 0 }
    ],
    "traceId": "0HN7..."
  }
}
```

- `code` estable y legible por máquina; `message` para humanos.
- `traceId` para correlacionar con logs. Sin él, debuggear producción es adivinar.
- **Nunca** stack traces, rutas internas ni nombres de tabla en la respuesta.

## Paginación

| Estrategia | Cuándo |
|---|---|
| Offset (`page`/`size`) | Datasets estables, UI con salto de página |
| Cursor | Datasets que cambian, scroll infinito |
| Sin paginar | Solo si garantizas un límite duro |

```json
{
  "data": [ ... ],
  "page": 2,
  "size": 50,
  "total": 1340
}
```

- `size` con máximo duro en servidor. Sin límite, alguien pide `size=1000000`.
- Offset se degrada con páginas profundas: pasado cierto punto, cursor.

## Versionado

| Estrategia | Cuándo |
|---|---|
| En la ruta (`/v1/`) | Simple, visible, fácil de enrutar |
| Por header (`Accept-Version`) | URLs limpias, cliente menos evidente |
| Sin versión, aditivo | Solo si nunca rompes nada |

- Regla: agrega campos libremente; rompe solo con versión mayor.
- Un campo que desaparece es un rompimiento, aunque nadie lo estuviera usando.
- Deprecación anunciada con `Deprecation` y `Sunset` en headers, y ventana real de vida.

## Idempotencia y reintentos

- `Idempotency-Key` en cabecera para `POST` críticos (pagos, creación de pedidos). El
  servidor guarda la clave y devuelve la misma respuesta.
- Reintentos del cliente con backoff exponencial y jitter. Sin jitter, todos reintentan
  al mismo tiempo.
- Reintenta solo lo reintentable: `GET`, `PUT`, `DELETE`, y `5xx`/timeout. Un `400` no
  se arregla reintentando.

## Resiliencia

| Patrón | Para |
|---|---|
| Timeout explícito | Toda llamada externa |
| Retry con backoff | Fallos transitorios |
| Circuit breaker | Dependencia caída que no debe arrastrar todo |
| Bulkhead | Aislar un consumidor lento |

- Todo `HttpClient` con timeout. Sin timeout, el default es infinito y tu thread se cuelga.
- Propaga `CancellationToken` en .NET: si el cliente se fue, no sigas trabajando.

## Seguridad del contrato

- Autenticación en cada endpoint, salvo lista blanca explícita.
- Autorización por recurso: **verifica ownership**, no solo "está autenticado" (IDOR).
- Rate limit por identidad y por IP.
- CORS restringido a orígenes conocidos; nunca `*` con credenciales.
- Datos sensibles nunca en query string: van en logs y en historial.

## Límites

- No diseñes el contrato desde la entidad de base de datos; diseña desde el caso de uso.
- No expongas ids internos si no aportan (o usa opacos).
- No declares estable una API sin contrato escrito y versionado.
- No agregues un campo `password` "solo para probar".
