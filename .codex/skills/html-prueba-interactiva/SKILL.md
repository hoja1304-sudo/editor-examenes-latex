---
name: html-prueba-interactiva
description: Crear versiones HTML interactivas de pruebas estandarizadas a partir de examenes LaTeX o PDF. Usar cuando Codex deba generar una pagina HTML con los mismos items, opciones, notacion matematica, figuras, Modo Examen, retroalimentacion y resultados, sin Modo Practica.
---

# HTML Prueba Interactiva

## Proposito

Usar esta skill para convertir una prueba creada en LaTeX/PDF en una version HTML interactiva que reproduzca los mismos items, simbolos matematicos, graficos y opciones de respuesta.

## Procedimiento

1. Identificar el archivo origen de la prueba, preferiblemente el `.tex`; si solo existe PDF, usarlo como referencia visual.
2. Crear el HTML en la misma carpeta del examen y con el mismo nombre base del PDF o `.tex`.
3. Reproducir todos los items:
   - Mantener el enunciado, contexto, pregunta y cuatro opciones A-D.
   - Mantener notacion matematica con HTML semantico, superindices, subindices o MathML cuando sea suficiente.
   - Si el origen es `.tex`, extraer/renderizar los bloques `tikzpicture`, macros TikZ o fragmentos TikZ equivalentes con el codigo real del `.tex`; convertirlos a SVG con `.codex/scripts/render-tikz-for-html.ps1` o `.codex/scripts/render-tikz-svg.ps1`; usar esos SVG como fuente visual principal.
   - No reconstruir a mano figuras TikZ en SVG/JavaScript cuando existe codigo TikZ en el `.tex`. Solo hacerlo como excepcion si no hay bloque/macro TikZ disponible, si el renderizador falla despues de intentar corregir el TikZ, o si el usuario pide una version simplificada. En esos casos, verificar contra el PDF y explicar brevemente la excepcion.
4. Incluir unicamente Modo Examen: temporizador, navegacion entre items, marcado para revisar, envio final, retroalimentacion y resultados al final.
   - No generar, mostrar ni mencionar Modo Practica.
5. Incluir barra de progreso, selector de item, resumen de resultados y boton para reiniciar.
6. Guardar todo en un solo archivo `.html` autocontenido, sin dependencias externas, salvo que el usuario pida lo contrario.
7. Verificar que el HTML abra en navegador y que las opciones, navegacion y resultados funcionen.

## Reglas Visuales

- Usar una estructura similar a la practica HTML de referencia del proyecto: pantalla inicial, cabecera azul, tarjeta por item, opciones como botones, feedback coloreado y resumen final.
- Mantener un ancho maximo cercano a 820 px para lectura comoda.
- Para matematicas de opciones, preferir expresiones HTML claras como `(x − 25)<sup>2</sup> + (y − 18)<sup>2</sup> = 100`.
- Para graficos tipo plano cartesiano, usar SVG con:
  - Ejes con flechas.
  - Lineas punteadas de proyeccion.
  - Puntos pequenos.
  - Etiquetas numericas alineadas con sus guias, siguiendo las reglas de la skill `latex-matematica`.
- Para valores negativos sobre el eje `x`, centrar los digitos bajo la guia y dejar el signo menos hacia la izquierda.
- Cuando exista una figura TikZ en el `.tex`, usar la figura renderizada desde LaTeX sobre un SVG recreado manualmente. El PDF solo debe servir como verificacion visual.
- Al convertir TikZ a SVG con `dvisvgm`, evitar fuentes bitmap o codificaciones que hagan desaparecer texto normal como `(este)` y `(norte)`. En los documentos temporales de conversion, usar fuentes vectoriales compatibles o la codificacion predeterminada OT1; verificar que etiquetas de ejes completas sobrevivan en el SVG.
- Para opciones graficas generadas por macros en el `.tex`, renderizar cada llamada de macro o un fragmento TikZ con los mismos parametros del PDF; no reemplazarlas por una funcion SVG aproximada si el renderizador del proyecto puede producir el SVG desde TikZ.

## Datos De Items

Representar los items como un arreglo `ITEMS` en JavaScript con esta forma minima:

```js
{
  numero: 1,
  bloque: "Geometria",
  enunciado: "<p>...</p><svg>...</svg>",
  A: "...",
  B: "...",
  C: "...",
  D: "...",
  clave: "C",
  exp_correcta: "...",
  exp_A: "...",
  exp_B: "...",
  exp_C: "...",
  exp_D: "..."
}
```

Si no se ha solicitado solucionario detallado, escribir explicaciones breves pero utiles para la clave y los distractores.

## Validacion

Antes de entregar, revisar que:

- El archivo HTML exista junto al PDF origen.
- El titulo y nombre base coincidan con la prueba.
- Todos los items del origen aparezcan en el HTML.
- Cada item tenga cuatro opciones y una clave.
- Las figuras reproduzcan la ubicacion, etiquetas y notacion de la prueba.
- Si el origen tiene TikZ, confirmar que el HTML usa SVG generado desde ese TikZ o registrar la excepcion puntual si una figura fue reconstruida manualmente.
- Comparar visualmente los items con graficas contra el PDF y corregir recortes, etiquetas perdidas, escalas distintas, flechas incompletas o diferencias de ubicacion.
- El Modo Examen pueda iniciarse, navegarse, enviarse y reiniciarse sin errores de JavaScript.
