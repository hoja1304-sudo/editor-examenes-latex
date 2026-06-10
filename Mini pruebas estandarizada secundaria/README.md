# Mini Pruebas Estandarizada Secundaria

Proyecto de trabajo para mejorar una mini prueba estandarizada de Matematica secundaria y mantener sincronizadas sus salidas LaTeX, PDF e HTML interactiva.

## Estructura

- `latex/`: fuente principal `.tex`.
- `pdf/`: PDF compilado para revision.
- `html/`: version interactiva autocontenida.
- `borradores/`: lotes de items por afirmacion/evidencia con claves.
- `docs/`: marco de especificaciones y referencias.
- `temporales/`: archivos de trabajo generados durante conversiones o revisiones.

## Skills Especiales Disponibles

- `latex-matematica`: escritura y mejora de examenes matematicos en LaTeX/TikZ.
- `constructor-pruebas-nacionales-secundaria`: alineacion con el marco de especificaciones 2026.
- `html-prueba-interactiva`: conversion a HTML interactivo en Modo Examen.
- `tikz-to-html-svg`: apoyo para pasar TikZ a SVG preservando figuras.

## Estado Inicial

Se toma como base la prueba `1PruebaEstandarizadaSecundaria2026` del proyecto principal y el borrador `Borrador_Bloque1_Afirmacion7`.

## Pendientes Inmediatos

- Regenerar o actualizar `html/1PruebaEstandarizadaSecundaria2026.html` desde el `.tex` actual, porque la copia inicial del HTML aun no incorpora el bloque nuevo de la evidencia 7.
- Renderizar las figuras TikZ reales hacia SVG antes de validar la version interactiva.
- Verificar que el HTML conserve solo Modo Examen.
