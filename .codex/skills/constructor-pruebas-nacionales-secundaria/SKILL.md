---
name: constructor-pruebas-nacionales-secundaria
description: Orquestar la creacion completa de practicas nacionales estandarizadas de Matematica secundaria en Costa Rica: generar 60 items desde Marco-especificaciones-Matematicas-Secundaria.pdf, construir el examen en LaTeX, compilarlo a PDF y crear la practica HTML interactiva solo en Modo Examen. Usar cuando el usuario pida crear una Practica Nacional Estandarizada 2026, una prueba de 60 items por bloques, o una practica basada en la tabla de especificaciones de secundaria.
---

# Constructor De Pruebas Nacionales Secundaria

## Proposito

Usar esta skill para crear una prueba completa de 60 items de Matematica secundaria basada en el documento `Marco-especificaciones-Matematicas-Secundaria.pdf`, con revision por lotes, salida LaTeX/PDF y version HTML interactiva solo en Modo Examen.

## Flujo Obligatorio

1. Localizar `Marco-especificaciones-Matematicas-Secundaria.pdf` en el proyecto.
2. Leer las paginas 6, 7, 8, 9 y 10 para aplicar las reglas de redaccion de items.
3. Leer desde la pagina 16 la tabla de especificaciones para la aplicacion sumativa de la Prueba Nacional Estandarizada de Matematica secundaria 2026.
4. Extraer de la tabla cada bloque, afirmacion, evidencias y cantidad de items.
5. Respetar la distribucion total:
   - Bloque 1. Geometria: 23 items.
   - Bloque 2. Relaciones y Algebra: 25 items.
   - Bloque 3. Estadistica y Probabilidades: 12 items.
6. Generar los items por afirmacion, no toda la prueba de una vez.
7. Presentar al usuario cada lote de items para aprobacion o modificacion antes de incorporarlo a la prueba final.
8. Incorporar solo items aprobados al archivo LaTeX final.
9. Al completar los 60 items aprobados, crear el `.tex`, compilar a PDF y generar el HTML interactivo.

## Seleccion De Evidencias

Para cada afirmacion, comparar la cantidad de evidencias con la cantidad de items solicitados por la tabla.

- Si la cantidad de evidencias es igual a la cantidad de items, crear un item por evidencia.
- Si hay menos evidencias que items, crear primero un item por evidencia y distribuir los items adicionales entre las evidencias de forma equilibrada. Cuando una evidencia sea integradora o de resolucion de problemas, preferirla para el item adicional.
- Si hay mas evidencias que items, mostrar las evidencias al usuario y pedir que seleccione cuales desea evaluar. No crear ese lote hasta que el usuario elija.
- Si la tabla o el PDF son ambiguos, mostrar la interpretacion y pedir confirmacion antes de generar el lote.

Ejemplo guia:

- Afirmacion: circunferencias.
- Evidencias: representacion grafica, representacion algebraica, problemas con circunferencia.
- Items solicitados: 4.
- Distribucion: 1 item para cada evidencia y 1 item adicional para la evidencia de resolucion de problemas.

## Creacion De Items

1. Usar los ejemplos de `Ejemplos de examenes de pruebas estandarizadas` como referencia de estilo, dificultad, longitud, tipo de contexto y formato de opciones.
2. Crear items nuevos, no copias literales de los ejemplos.
3. Usar la skill `latex-matematica` para escribir items en LaTeX, con TikZ/PGFPlots cuando corresponda.
4. Cada item debe incluir:
   - Enunciado claro y contextualizado cuando aplique.
   - Pregunta unica.
   - Cuatro opciones A-D.
   - Una unica respuesta correcta.
   - Distractores plausibles derivados de errores frecuentes.
   - Clave y explicacion breve para la version interactiva.
5. Seguir las reglas del marco de especificaciones leidas en las paginas 6-10.
6. Evitar que un item quede partido entre paginas usando `needspace` u otra tecnica equivalente.

## Revision Con El Usuario

Despues de generar cada lote por afirmacion:

1. Mostrar los items al usuario en formato claro.
2. Indicar bloque, afirmacion, evidencias cubiertas y cantidad de items.
3. Preguntar si aprueba el lote o desea modificaciones.
4. Si solicita cambios, editar el lote y volver a presentarlo.
5. Guardar en la prueba final solamente los items aprobados.

No avanzar a la siguiente afirmacion hasta que el lote actual este aprobado, salvo que el usuario pida saltarlo explicitamente.

## Nombres De Archivos

Guardar la prueba en `Examenes Pruebas estandarizadas` con numeracion consecutiva:

- Primera prueba: `Practica 1_Prueba Nacional Estandarizada_2026.tex`
- Segunda prueba: `Practica 2_Prueba Nacional Estandarizada_2026.tex`
- Continuar con el siguiente numero disponible.

El PDF y el HTML deben usar el mismo nombre base:

- `Practica N_Prueba Nacional Estandarizada_2026.pdf`
- `Practica N_Prueba Nacional Estandarizada_2026.html`

## Compilacion Y HTML

1. Compilar el `.tex` con el helper del proyecto:

```powershell
powershell -ExecutionPolicy Bypass -File .codex/scripts/compile-exam.ps1 "Examenes Pruebas estandarizadas/Practica N_Prueba Nacional Estandarizada_2026.tex"
```

2. Corregir errores de compilacion antes de generar el HTML.
3. Usar la skill `html-prueba-interactiva` para crear el HTML.
4. El HTML debe generar solo Modo Examen, con retroalimentacion y resultados. No generar Modo Practica.
5. Renderizar figuras TikZ desde el codigo real del `.tex` usando:

```powershell
powershell -ExecutionPolicy Bypass -File .codex/scripts/render-tikz-for-html.ps1 "<archivo.tex>" "<archivo.html>"
```

## Validacion Final

Antes de entregar:

- Confirmar que hay exactamente 60 items.
- Confirmar la distribucion 23/25/12 por bloque.
- Confirmar que cada afirmacion respeta la cantidad de items indicada en la tabla.
- Confirmar que todos los items aprobados estan en el `.tex`.
- Confirmar que el PDF compila correctamente.
- Confirmar que el HTML existe, abre sin errores y usa solo Modo Examen.
