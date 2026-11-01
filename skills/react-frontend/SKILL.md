---
name: react-frontend
description: React moderno: componentes, hooks, estado, rendering y rendimiento. Úsala cuando el usuario pida crear componentes, arreglar re-renders innecesarios, depurar efectos que se disparan de más, o decidir dónde vive el estado.
---

# React

> **Scaffold v2.1** — Reconstruida a partir de `docs/v2.1/SKILLS-REGISTRY.md`. El paquete
> original no incluía esta skill. Sustitúyela cuando llegue la versión de referencia.

## Objetivo

Escribir componentes que hagan lo obvio. React no es difícil; lo difícil es no pelear
contra el flujo de datos.

> *"Si estás sincronizando estado con useEffect, el estado está en el lugar equivocado."*

## Reglas que evitan el 80% de los bugs

1. **El estado derivado no se guarda.** Si se puede calcular de props o de otro estado,
   se calcula.
2. **`useEffect` es para sincronizar con el exterior** (red, DOM, suscripciones). No para
   recalcular valores.
3. **La `key` identifica, no indexa.** `key={index}` rompe listas reordenables.
4. **Actualiza con función** si dependes del valor previo: `setN(n => n + 1)`.
5. **El estado se levanta, no se duplica.** Una fuente de verdad por dato.

## Estado: dónde vive

| Necesidad | Solución |
|---|---|
| Solo ese componente | `useState` / `useReducer` |
| Padre e hijos | Levantar al ancestro común |
| Muchos componentes lejanos | Context (para baja frecuencia) |
| Servidor / caché | Librería de datos (React Query, SWR) |
| Global complejo | Store externo (Zustand, Redux Toolkit) |

Context no es un reemplazo de gestor de estado: cada cambio re-renderiza a todos los
consumidores. Para datos que cambian rápido, no es la herramienta.

## Efectos

```jsx
// MAL: efecto que calcula estado derivado
const [total, setTotal] = useState(0);
useEffect(() => { setTotal(items.reduce((a, b) => a + b.price, 0)); }, [items]);

// BIEN: derivado en render
const total = useMemo(
  () => items.reduce((a, b) => a + b.price, 0),
  [items]
);
```

- Arregla las dependencias, no las silencies. `// eslint-disable-next-line` en deps es
  deuda con interés.
- Toda suscripción o temporizador se limpia en el `return`.
- Si un efecto actualiza estado que dispara el mismo efecto, tienes un ciclo: el diseño
  está mal.

### Closures obsoletos

Un efecto captura el valor del render en que corrió. Si necesitas el valor actual sin
re-suscribirte, usa un `ref` espejo o `useEffectEvent` según la versión. **No lo
arregles agregando el valor a las deps si eso re-suscribe en cada cambio.**

## Rendimiento

Mide antes de optimizar. En orden de impacto real:

| Técnica | Nota |
|---|---|
| Mover estado hacia abajo | Casi siempre el mejor arreglo |
| `key` estable | Evita remontar subárboles |
| Dividir componentes | Aísla el re-render |
| `React.memo` | Solo si el profiler lo señala |
| `useMemo` / `useCallback` | Cuesta; úsalo donde importa |
| Virtualizar listas largas | > ~100 filas visibles |

`React.memo` con props de objeto literal `{ }` no sirve: creas uno nuevo cada render.
Ahí es donde `useMemo` sí gana.

## Formularios

- Controlado para validación en vivo, no controlado para formularios simples y grandes.
- No sincronices campo por campo con estado global; envía al guardar.
- `onSubmit` con `preventDefault()` y validación antes de la petición.

## Accesibilidad y HTML

- `button` es un botón; `div` con `onClick` necesita `role`, `tabIndex` y teclado.
- `label` con `htmlFor` y `id`. Sin eso el formulario es inmanejable con teclado.
- Alt en imágenes informativas; vacío en decorativas.

## Límites

- No agregues una librería de estado para un `boolean`.
- No declares "está optimizado" sin el profiler.
- No uses `dangerouslySetInnerHTML` con input del usuario. Nunca.
- No mandes props a diez niveles: si pasa por componentes que no la usan, es Context o
  composición.
