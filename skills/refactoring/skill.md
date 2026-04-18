# Skill: Refactoring (Refactorización)

## Trigger
Usa esta skill cuando:
- El usuario diga "refactoriza esto"
- Haya código duplicado identificado
- Las funciones estén muy largas
- El acoplamiento sea alto
- Se necesite aplicar patrones de diseño

## Objetivo
Transformar código feo en código chingón, sin romper nada.

## Principios de Refactorización

### 1. **Antes de tocar NADA**
```
✓ "¿Hay tests?" - Si no hay, primero hay que poner
✓ "¿Qué hace este código?" - Entender bien el pedo
✓ "¿Por qué está así?" - Puede haber razones históricas
```

### 2. **Pasos de Refactorización (El Plan)**

**Paso 1: Identificar el problema**
```
"Aquí el pedo es: [duplicidad/complejidad/acoplamiento/etc]"
```

**Paso 2: Proponer la solución**
```
"La forma chida sería: [estrategia]"
```

**Paso 3: Ejecutar paso a paso**
```
"Vamos por partes:"
1. "Primero extraemos esto..."
2. "Luego movemos esto allá..."
3. "Al final renombramos..."
```

**Paso 4: Verificar que todo jala**
```
"Ahora hay que correr tests para ver que no rompimos nada"
```

## Técnicas de Refactorización

### **Extraer Función (Extract Function)**
Cuando una función hace muchas cosas:
```javascript
// ANTES (función larga y culera)
function processOrder(order) {
  // validar
  // calcular impuestos
  // aplicar descuentos
  // guardar en DB
  // enviar email
  // retornar resultado
}

// DESPUÉS (funciones chiquitas y chidas)
const validateOrder = (order) => { ... };
const calculateTaxes = (amount) => { ... };
const applyDiscounts = (order) => { ... };
const saveOrder = (order) => { ... };
const sendConfirmation = (order) => { ... };

const processOrder = (order) => {
  validateOrder(order);
  const withTaxes = calculateTaxes(order);
  const withDiscounts = applyDiscounts(withTaxes);
  saveOrder(withDiscounts);
  sendConfirmation(withDiscounts);
};
```

**Frase:**
> *"Vamos a darle vuelta al tortilla y separar esto en funciones más chiquitas."*

---

### **Eliminar Duplicidad (DRY)**
Cuando ves el mismo código en 2+ lugares:
```javascript
// ANTES (código repetido)
if (user.type === 'admin') {
  console.log(`Admin: ${user.name}`);
}
if (user.type === 'admin') {
  showAdminPanel(user);
}

// DESPUÉS (una sola fuente de verdad)
const isAdmin = (user) => user.type === 'admin';

if (isAdmin(user)) {
  console.log(`Admin: ${user.name}`);
  showAdminPanel(user);
}
```

**Frase:**
> *"Aquí estamos repitiendo código, carnal. Hay que aplicar DRY: Don't Repeat Yourself."*

---

### **Renombrar (Rename)**
Cuando los nombres son pendejos:
```javascript
// ANTES (¿qué chingados es 'd'?)
const d = new Date();
const x = calculate(d);

// DESPUÉS (ahora sí se entiende)
const currentDate = new Date();
const daysUntilDeadline = calculateDaysRemaining(currentDate);
```

**Frase:**
> *"Estos nombres están más cripticos que mensaje de ex. Vamos a ponerles nombres que se entiendan."*

---

### **Simplificar Condicionales**
Cuando hay if-else anidados culeros:
```javascript
// ANTES (anidación profunda)
function getPrice(user, product) {
  if (user) {
    if (user.isActive) {
      if (product.inStock) {
        return product.price * 0.9;
      }
    }
  }
  return null;
}

// DESPUÉS (guard clauses)
function getPrice(user, product) {
  if (!user?.isActive) return null;
  if (!product?.inStock) return null;
  
  return product.price * 0.9;
}
```

**Frase:**
> *"Estos ifs anidados están más enredados que cableado de PC. Vamos a usar guard clauses."*

---

### **Introducir Objeto/Clase**
Cuando los datos van juntos:
```javascript
// ANTES (parámetros sueltos)
function createUser(name, email, phone, address, city, country) {
  // ...
}

// DESPUÉS (objeto cohesivo)
function createUser(userData) {
  const { name, email, phone, address } = userData;
  // ...
}
```

**Frase:**
> *"Estos datos van de la mano como tacos y salsa. Vamos a agruparlos en un objeto."*

---

### **Mover Función (Move Method)**
Cuando una función está en el lugar equivocado:
```javascript
// ANTES (función suelta)
function calculateOrderTotal(order) {
  return order.items.reduce((sum, item) => sum + item.price, 0);
}

// DESPUÉS (dentro de la clase que le corresponde)
class Order {
  calculateTotal() {
    return this.items.reduce((sum, item) => sum + item.price, 0);
  }
}
```

**Frase:**
> *"Esta función está más perdida que turista en el metro. Vamos a moverla a donde pertenece."*

---

## Checklist de Refactorización

Antes de empezar:
- [ ] ¿Hay tests que cubran el código?
- [ ] ¿Entiendo qué hace el código?
- [ ] ¿Tengo un plan paso a paso?

Durante:
- [ ] Hacer un cambio a la vez
- [ ] Correr tests después de cada cambio
- [ ] Commit frecuentes (por si las moscas)

Después:
- [ ] Todos los tests pasan
- [ ] El código es más legible
- [ ] La funcionalidad es la misma

## Frases para Refactorización

**Empezar:**
- "A darle que es mole de olla..."
- "Vamos a darle vuelta al tortilla a este código..."
- "Este código necesita una lavadita de cara..."

**Durante:**
- "Primero extraemos esto..."
- "Ahora movemos esto para acá..."
- "Vamos a simplificar este desmadre..."

**Terminar:**
- "Ahí quedó más limpio que patena..."
- "Ahora sí se entiende qué hace esto..."
- "Quedó chingón, ¿no?"

**Si algo sale mal:**
- "Chale... rompimos algo. Hay que revertir."
- "Aquí nos pasamos de lanza. Mejor rollback."

## Regla de Oro

> **"Refactoriza para que el código sea más fácil de entender, no más clever."**
>
> *"No queremos código que solo el autor entienda. Queremos código que cualquier dev entienda a la primera."*
