# Skill: Testing (Pruebas)

## Trigger
Usa esta skill cuando:
- El usuario pida "tests"
- Se necesite validar que algo funciona
- Se quiera TDD (Test-Driven Development)
- Se revisen tests existentes

## Objetivo
Asegurar que el código jale bien y no se rompa con cambios.

> *"Sin tests estamos volando a ciegas, carnal. En cualquier momento se puede caer el avión."*

## Tipos de Tests

### **1. Unit Tests (Pruebas Unitarias)**
Prueban una función/clase aisladamente.

**Cuándo usar:**
- Lógica de negocio compleja
- Funciones puras (misma entrada → misma salida)
- Cálculos, validaciones, transformaciones

**Ejemplo:**
```javascript
// Función a probar
const calculateDiscount = (price, percentage) => {
  if (price < 0) throw new Error('Price cannot be negative');
  if (percentage < 0 || percentage > 100) throw new Error('Invalid percentage');
  return price * (percentage / 100);
};

// Tests
 describe('calculateDiscount', () => {
  test('calculates 10% discount correctly', () => {
    expect(calculateDiscount(100, 10)).toBe(10);
  });
  
  test('throws on negative price', () => {
    expect(() => calculateDiscount(-100, 10)).toThrow('Price cannot be negative');
  });
  
  test('throws on invalid percentage', () => {
    expect(() => calculateDiscount(100, 110)).toThrow('Invalid percentage');
  });
});
```

**Frases:**
> *"Vamos a testear esta función unitaria..."
> *"Hay que asegurarnos de que esta lógica jale bien..."

---

### **2. Integration Tests (Pruebas de Integración)**
Prueban que varias partes jalen juntas.

**Cuándo usar:**
- APIs endpoints
- Base de datos + código
- Servicios que se llaman entre sí
- Flujos completos

**Ejemplo:**
```javascript
// Test de API
describe('POST /api/users', () => {
  test('creates a new user', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ name: 'Juan', email: 'juan@test.com' });
    
    expect(response.status).toBe(201);
    expect(response.body).toHaveProperty('id');
    expect(response.body.name).toBe('Juan');
  });
  
  test('returns 400 on invalid data', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ name: '' });
    
    expect(response.status).toBe(400);
  });
});
```

**Frases:**
> *"Vamos a testear que todo el flujo jale..."
> *"Hay que verificar que la API responde bien..."

---

### **3. E2E Tests (End-to-End)**
Prueban la app como un usuario real.

**Cuándo usar:**
- Flujos críticos de usuario
- Happy paths principales
- Registro, login, checkout, etc.

**Ejemplo:**
```javascript
// Test E2E con Playwright/Cypress
test('user can complete purchase', async ({ page }) => {
  await page.goto('/products');
  await page.click('[data-testid="product-1"]');
  await page.click('[data-testid="add-to-cart"]');
  await page.click('[data-testid="checkout"]');
  await page.fill('[name="email"]', 'user@test.com');
  await page.click('[data-testid="complete-purchase"]');
  
  await expect(page.locator('[data-testid="success-message"]')).toBeVisible();
});
```

**Frases:**
> *"Vamos a hacer un test end-to-end del flujo completo..."
> *"Hay que probar esto como si fuéramos usuarios reales..."

---

## TDD - Test-Driven Development

**El ciclo:**
1. **RED**: Escribe el test (va a fallar)
2. **GREEN**: Escribe el código mínimo para que pase
3. **REFACTOR**: Mejora el código manteniendo tests verdes

**Frases:**
> *"A darle con TDD: primero el test, luego el código."
> *"Primero definimos qué queremos que haga, luego lo hacemos."

**Ejemplo TDD:**
```javascript
// PASO 1: Escribir test (RED)
test('sum function adds two numbers', () => {
  expect(sum(2, 3)).toBe(5);
});
// → FAIL: sum is not defined

// PASO 2: Código mínimo (GREEN)
const sum = (a, b) => a + b;
// → PASS

// PASO 3: Refactor (si es necesario)
// Ya está limpio, no necesita refactor
```

---

## Coverage (Cobertura)

**Qué es:** Qué porcentaje del código está testeado.

**Metas:**
- Unit tests: 80%+ coverage
- Integration: Cubrir los flujos críticos
- E2E: Happy paths principales

**Frases:**
> *"Tenemos 85% de coverage. Está chingón."
> *"Aquí nos falta coverage. Hay que agregar tests."
> *"El coverage no lo es todo, pero da una idea."

---

## Buenas Prácticas de Testing

### ✅ **DO**
- Testear comportamiento, no implementación
- Un concepto por test
- Nombres descriptivos
- Preparar datos, actuar, verificar (Arrange-Act-Assert)
- Tests independientes (no dependan entre sí)
- Mocks para dependencias externas

### ❌ **DON'T**
- Tests que dependen del orden
- Tests que tocan la base de datos real (usa test DB)
- Tests muy lentos
- Testear getters/setters triviales
- Tests frágiles (que se rompen con cambios mínimos)

**Frases:**
> *"Este test está muy acoplado a la implementación. Hay que testear el qué, no el cómo."
> *"Los tests deben ser independientes. Este depende del anterior."

---

## Estructura de un Test

```javascript
describe('Componente/Función a testear', () => {
  // Setup (si es necesario)
  beforeEach(() => {
    // Preparar estado
  });
  
  // Tests individuales
  test('debería hacer X cuando Y', () => {
    // Arrange: Preparar
    const input = ...;
    
    // Act: Ejecutar
    const result = functionToTest(input);
    
    // Assert: Verificar
    expect(result).toBe(expected);
  });
  
  test('debería lanzar error cuando Z', () => {
    // Arrange
    const invalidInput = ...;
    
    // Act & Assert
    expect(() => functionToTest(invalidInput)).toThrow('error message');
  });
  
  // Cleanup (si es necesario)
  afterEach(() => {
    // Limpiar estado
  });
});
```

---

## Testing en Diferentes Escenarios

### **APIs**
```javascript
describe('User API', () => {
  test('GET /users returns list', async () => {
    const res = await request(app).get('/users');
    expect(res.status).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });
});
```

### **Frontend Components**
```javascript
describe('LoginForm', () => {
  test('submits form with valid data', () => {
    render(<LoginForm onSubmit={mockSubmit} />);
    fireEvent.change(screen.getByLabelText('Email'), { target: { value: 'test@test.com' } });
    fireEvent.change(screen.getByLabelText('Password'), { target: { value: 'password123' } });
    fireEvent.click(screen.getByText('Login'));
    
    expect(mockSubmit).toHaveBeenCalledWith({
      email: 'test@test.com',
      password: 'password123'
    });
  });
});
```

### **Database**
```javascript
describe('UserRepository', () => {
  test('saves user to database', async () => {
    const user = { name: 'Juan', email: 'juan@test.com' };
    const saved = await repository.save(user);
    
    expect(saved.id).toBeDefined();
    expect(saved.name).toBe('Juan');
    
    // Verificar en DB
    const fromDb = await db.query('SELECT * FROM users WHERE id = $1', [saved.id]);
    expect(fromDb.rows[0].name).toBe('Juan');
  });
});
```

---

## Frases para Testing

**Empezar:**
- "Vamos a testear esto bien..."
- "A darle con TDD..."
- "Primero definimos qué debe hacer, luego lo hacemos..."

**Durante:**
- "Este test cubre el caso feliz..."
- "Falta testear el caso de error..."
- "Aquí deberíamos mockear la API..."

**Revisando tests:**
- "Este test está chingón, cubre bien el caso..."
- "Aquí el test está muy frágil..."
- "Falta coverage en esta función..."

**Problemas:**
- "Este test está roto..."
- "Hay que fixear este test antes de seguir..."
- "Los tests están muy lentos..."

---

## Regla de Oro del Testing

> **"Tests que no corren son mentiras. Tests que no se entienden son inútiles."**
>
> *"Los tests deben ser confiables y legibles. Si no, no sirven de nada, carnal."*

---

## Cuándo NO testear

- Prototipos/experimentos (van a cambiar mucho)
- Código que se va a tirar
- Tests de tests
- Configuración trivial

**Frase:**
> *"Para este spike no le busquemos ruido al chicharrón con tests. Cuando se estabilice, ahí sí."
