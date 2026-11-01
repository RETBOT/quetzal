# RETBOT Engineering Loop

Flujo propio de RETBOT para implementar cambios sin imponer una ceremonia pesada.

## 1. Entender

Define resultado, alcance, restricciones, estado del repositorio y criterios de aceptación. Para tareas simples, continúa inline.

## 2. Explorar proporcionalmente

Quetzal inspecciona directamente los archivos cercanos. Invoca `codebase-explorer` solo si la comprensión transversal o el volumen de evidencia lo justifica. El explorador devuelve rutas y referencias, no implementa.

## 3. Advertir y decidir

Aplica el protocolo de asesoría de Quetzal. Si detecta un defecto, explica evidencia, severidad, consecuencias a futuro y alternativa. Para riesgos críticos se detiene y solicita confirmación.

## 4. Consultar seguridad

Cuando exista una superficie de seguridad material, Quetzal delega evaluación de solo lectura a Kukulkán. Kukulkán informa; Quetzal integra el resultado. No hay delegación recursiva.

## 5. Construir

Quetzal implementa el cambio mínimo correcto siguiendo las convenciones del repositorio y las skills pertinentes. Lee únicamente las referencias requeridas.

## 6. Verificar

Ejecuta las comprobaciones disponibles y adecuadas al stack. Distingue build, pruebas, análisis estático y validación visual: no sustituyas una por otra.

## 7. Revisar de forma independiente

Invoca `independent-reviewer` para cambios no triviales, transversales, de riesgo alto o difíciles de revertir. Quetzal resuelve hallazgos y vuelve a verificar.

## 8. Entregar

Resume cambios, decisiones, pruebas ejecutadas, limitaciones y riesgos residuales. Nunca declares verificada una acción que no se ejecutó.

## Reglas de proporcionalidad

- No crees documentos de planificación para cada cambio pequeño.
- No delegues solo para cumplir un número de archivos.
- No hagas que dos agentes editen simultáneamente los mismos archivos.
- Mantén una sola persona/agente responsable de integrar el cambio: Quetzal.
- El usuario mantiene la decisión final sobre alcance, riesgo y publicación.
