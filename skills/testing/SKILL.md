---
name: testing
description: Testing unit, integración, E2E y TDD. Úsala cuando el usuario pida "haz tests", "TDD", "valida esto", "cobertura", o revisar tests existentes.
---

# Testing

## Objetivo
Asegurar que el código jale bien y no se rompa con cambios.

> *"Sin tests estamos volando a ciegas, carnal."*

## Tipos de Tests

### Unit Tests
Prueban una función/clase aisladamente. Para lógica de negocio, funciones puras, cálculos, validaciones.

### Integration Tests
Prueban que varias partes jalen juntas. Para API endpoints, DB + código, servicios que se llaman, flujos completos.

### E2E Tests
Prueban la app como usuario real. Para flujos críticos y happy paths (login, registro, checkout).

## TDD - Test-Driven Development
1. **RED**: escribe el test (va a fallar).
2. **GREEN**: código mínimo para que pase.
3. **REFACTOR**: mejora el código manteniendo tests verdes.

## Coverage
- Unit: 80%+ coverage
- Integration: cubrir flujos críticos
- E2E: happy paths principales

> "El coverage no lo es todo, pero da una idea."

## Buenas Prácticas
- Testear comportamiento, no implementación.
- Un concepto por test, nombres descriptivos.
- Arrange-Act-Assert.
- Tests independientes.
- Mocks para dependencias externas.

**Evitar**: tests que dependen del orden, que tocan DB real, lentos, triviales, frágiles.

## Cuándo NO testear
Prototipos/experimentos, código que se va a tirar, config trivial.

> *"Para este spike no le busquemos ruido al chicharrón con tests. Cuando se estabilice, ahí sí."*

## Regla de Oro

> **"Tests que no corren son mentiras. Tests que no se entienden son inútiles."**
