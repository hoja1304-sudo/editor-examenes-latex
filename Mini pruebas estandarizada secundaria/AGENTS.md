# Agente Del Mini Proyecto

## Objetivo

Este mini-proyecto sirve para iterar pruebas estandarizadas de Matematica secundaria en tres salidas coordinadas:

- Fuente LaTeX en `latex/`.
- PDF compilado en `pdf/`.
- Version HTML interactiva en `html/`.
- Borradores por afirmacion o evidencia en `borradores/`.
- Referencias oficiales en `docs/`.

## Skills Relevantes

Usar estas skills del proyecto principal cuando corresponda:

- `latex-matematica`: para crear o mejorar items, figuras TikZ, diagramas, opciones y compilacion PDF.
- `constructor-pruebas-nacionales-secundaria`: para mantener alineacion con el marco 2026, bloques, afirmaciones, evidencias y distribucion de items.
- `html-prueba-interactiva`: para crear o actualizar la version HTML en Modo Examen, con retroalimentacion y resultados. No generar ni mencionar Modo Practica.
- `tikz-to-html-svg`: para convertir figuras TikZ a SVG cuando haya que preservar graficos en HTML.

## Flujo De Trabajo

1. Modificar primero el archivo `.tex` en `latex/` o el borrador en `borradores/`.
2. Compilar con el helper del proyecto principal:

```powershell
powershell -ExecutionPolicy Bypass -File ..\.codex\scripts\compile-exam.ps1 "Mini pruebas estandarizada secundaria/latex/<archivo>.tex"
```

3. Copiar o mover el PDF validado a `pdf/` cuando corresponda.
4. Actualizar el HTML desde el `.tex`, renderizando las figuras TikZ reales con:

```powershell
powershell -ExecutionPolicy Bypass -File ..\.codex\scripts\render-tikz-for-html.ps1 "<archivo.tex>" "<archivo.html>"
```

5. Verificar que el HTML tenga solo Modo Examen, cuatro opciones por item, clave, explicaciones y resultados.

## Criterios Visuales

- En diagramas con puntos, usar puntos discretos y etiquetas cercanas, con `inner sep` pequeno.
- En planos cartesianos, usar flechas en ambos extremos de los ejes.
- Alinear etiquetas numericas con guias punteadas.
- Evitar partir un item entre paginas mediante `\Needspace`.
- Si el HTML incluye figuras, preferir SVG generado desde TikZ real.

