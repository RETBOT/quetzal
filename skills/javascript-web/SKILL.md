---
name: javascript-web
description: JavaScript y jQuery en el navegador: AJAX, DOM, asincronía, eventos y seguridad del lado cliente. Úsala cuando el usuario pida manipular el DOM, migrar callbacks a async/await, arreglar peticiones AJAX, o revisar inyección de HTML y validación en cliente.
---

# JavaScript Web (con jQuery)

> **Scaffold v2.1** — Reconstruida a partir de `docs/v2.1/SKILLS-REGISTRY.md`. El paquete
> original no incluía esta skill. Sustitúyela cuando llegue la versión de referencia.

## Objetivo

JavaScript en el navegador perdona demasiado. El código funciona, y seis meses después
nadie sabe por qué se dispara cuatro veces.

> *"El navegador no te avisa. Te deja pasar y luego el usuario te avisa."*

## Asincronía

```js
// MAL: callback anidado, errores sin manejar
$.get("/api/a", function (a) {
  $.get("/api/b", function (b) {
    render(a, b);
  });
});

// BIEN: promesas, errores explícitos
async function cargar() {
  try {
    const [a, b] = await Promise.all([
      fetchJson("/api/a"),
      fetchJson("/api/b")
    ]);
    render(a, b);
  } catch (err) {
    mostrarError("No se pudieron cargar los datos");
    console.error(err);
  }
}
```

- `Promise.all` para llamadas independientes: en serie duplicas la latencia.
- `fetch` **no** rechaza en 4xx/5xx. Verifica `response.ok` o vas a renderizar errores
  como si fueran datos.
- Un `catch` que solo hace `console.log` no maneja nada: el usuario ve pantalla en blanco.

## Validación en cliente

- **Nunca** es seguridad. Es usabilidad. El servidor valida otra vez, siempre.
- Un `required` en HTML o un `if` en JS no impide que alguien mande el request a mano.
- Validación de forma en cliente; reglas de negocio en servidor.

## DOM: cuándo sí y cuándo no

| Necesidad | Enfoque |
|---|---|
| Construir nodos con datos del usuario | `textContent`, `createElement` |
| Inyectar HTML de confianza (plantilla propia) | `innerHTML` con contenido estático |
| Inyectar HTML con datos de usuario | **Nunca** `innerHTML` |

```js
// XSS: si nombre viene del usuario, esto ejecuta cualquier cosa
lista.innerHTML += `<li>${nombre}</li>`;

// Seguro: escaping automático
const li = document.createElement("li");
li.textContent = nombre;
lista.appendChild(li);
```

jQuery: `.text()` escapa, `.html()` no. Trata `.html()` con la misma desconfianza que
`eval`.

## Eventos

```js
// MAL: un handler por elemento y bindings duplicados
$(".item").on("click", handler);   // se duplica cada vez que se re-renderiza

// BIEN: delegación, un solo handler
$("#lista").on("click", ".item", handler);
```

- Delegación para listas dinámicas.
- `.off()` antes de `.on()` si un componente se monta varias veces.
- `$(document).ready()` no es necesario si el script va al final con `defer`.
- `event.preventDefault()` cuando el elemento es un enlace que no debe navegar.

## Peticiones AJAX con jQuery

```js
$.ajax({
  url: "/api/pedidos",
  method: "POST",
  contentType: "application/json",
  data: JSON.stringify(payload),
  headers: { "RequestVerificationToken": token }
})
  .done(res => onSuccess(res))
  .fail(xhr => {
    if (xhr.status === 401) return redirigirLogin();
    if (xhr.status === 403) return mostrarSinPermiso();
    mostrarError(xhr.status);
  });
```

- Envía el token antiforgery en POST/PUT/DELETE si el backend lo exige.
- No filtres secretos en el JS "porque el usuario no lo va a ver": está en el navegador.
- `Authorization` con token en `localStorage` es vulnerable a XSS. Cookie `HttpOnly` es
  preferible cuando el backend lo permite.

## Utilidades que evitan bugs

| Problema | Solución |
|---|---|
| Handler que corre en cada tecla | `debounce` (~300 ms) |
| Carrera entre dos peticiones | `AbortController` o token de secuencia |
| `this` perdido en callback | `bind` o arrow function |
| Comparar `0`, `""`, `null` | `===` y validación explícita |
| Fecha desfasada un día | ISO 8601 con zona horaria explícita |

## Límites

- No uses `var`. `const` por defecto, `let` si mutas.
- No manejes errores con `catch (e) {}` vacío.
- No metas lógica de negocio en el JS del navegador.
- No declares seguro un formulario porque el botón dice "validado".
