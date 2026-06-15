# Agente del proyecto

## Especializacion principal

Para tareas de examenes matematicos, documentos LaTeX, TikZ, PGFPlots, solucionarios o conversion de ejercicios a formato de examen, usar la skill local:

`.codex/skills/latex-matematica/SKILL.md`

Para crear la version interactiva HTML de una prueba, usar la skill local:

`.codex/skills/html-prueba-interactiva/SKILL.md`

Para crear una Practica Nacional Estandarizada de Matematica secundaria de 60 items basada en el marco de especificaciones 2026, usar la skill local:

`.codex/skills/constructor-pruebas-nacionales-secundaria/SKILL.md`

Para crear, corregir o verificar graficas matematicas y estadisticas en LaTeX/TikZ/PGFPlots y su reproduccion HTML/SVG, usar la skill local:

`.codex/skills/graficas-latex-estadistica/SKILL.md`

Preferencias de formato para pruebas estandarizadas:

- Usar puntos TikZ pequenos y discretos en diagramas: preferir una macro como `\puntografico` con valor cercano a `0.09` en coordenadas TikZ escaladas. Evitar puntos grandes para marcar ubicaciones; los puntos deben servir solo como marcas sutiles, no dominar la figura.
- Si un item pide que el estudiante determine si puntos dados pertenecen a una circunferencia o region, no dibujar esos puntos en la grafica salvo que el enunciado solicite explicitamente mostrarlos; dejar que el estudiante deduzca su ubicacion a partir de las coordenadas.
- Alinear las etiquetas numericas con sus lineas punteadas de proyeccion. En el eje `x`, centrar los digitos bajo la proyeccion vertical; si el valor es negativo, dejar el signo menos hacia la izquierda usando una forma como `$\llap{-}12$`. En el eje `y`, centrarlo al lado de la proyeccion horizontal.
- En planos cartesianos, colocar flechas en ambos extremos de los ejes `x` y `y`. Si el contexto usa coordenadas negativas, extender el eje correspondiente hacia la parte negativa para que la ubicacion quede representada con claridad.
- En planos cartesianos, las etiquetas `x` y `y` que nombran los ejes deben quedar ancladas visualmente cerca de la punta o flecha del eje correspondiente, tanto en LaTeX/PDF como en los SVG/HTML renderizados. Evitar etiquetas alejadas de la flecha porque dificultan la lectura del eje.
- Cuando un plano cartesiano contextualizado use etiquetas direccionales como `$y$ (norte)` y `$x$ (este)`, colocarlas alineadas con la flecha del eje respectivo: `$y$ (norte)` debe quedar sobre la punta superior de la flecha del eje `y`, centrada con respecto al eje vertical, y `$x$ (este)` debe quedar junto a la punta derecha del eje horizontal. En HTML/SVG, verificar que esas palabras completas no se pierdan ni queden recortadas; si se convierten a texto SVG literal, usar alineacion centrada (`text-anchor="middle"` o equivalente) para `y (norte)` sobre la punta superior del eje `y` y mantener `x (este)` junto a la flecha del eje `x`.
- Evitar que un item quede partido entre paginas. Si el bloque de enunciado, grafico, pregunta y opciones no cabe en el espacio restante, moverlo completo a la pagina siguiente usando `needspace` u otra tecnica equivalente.
- Si dos items completos caben en una misma pagina, colocarlos juntos en esa pagina. Ajustar `\Needspace{...}` al tamano real del item para evitar saltos artificiales que dejen espacios grandes en blanco.
- Cuando dos o tres items se relacionen con una misma figura, mantener en la misma hoja el encabezado, la figura y todos los items relacionados. El encabezado de la figura no debe llevar numero de item; el numero debe iniciar en el texto de la primera pregunta relacionada.
- En expresiones con radical, el signo de raiz debe abarcar visualmente todo el subradical.
- Las etiquetas que nombran puntos en una grafica (W, H, A, B, etc.) deben colocarse lo mas cerca posible del punto sin tocarlo, eligiendo la posicion (arriba, abajo, izquierda o derecha) que no quede sobre una linea punteada de proyeccion hacia los ejes. Si todas las direcciones tienen punteadas, preferir arriba o abajo con separacion minima. Por ejemplo, escribir en LaTeX `\sqrt{t+4}` y verificar que en HTML la barra del radical cubra completo `(t+4)` o la expresion que corresponda.
- En la portada de pruebas, practicas y proyectos nuevos, incluir una autoria discreta y elegante, con tamano reducido y jerarquia visual sobria: "Elaborado por: Alberto Jiménez Ruiz", "Asesor Regional de Matemática", "DRE-Cartago 2026 | DAP". Primero colocarla en LaTeX, compilar el PDF y luego reproducirla en la portada o pantalla inicial del HTML.

## Flujo de creacion de items

### Paso 0 — Consultar el Marco de Especificaciones

Antes de crear cualquier item, leer `Marco-especificaciones-Matematicas-Secundaria.pdf` (raiz del proyecto) para obtener:

1. La **posicion exacta** de los items en el examen de 60 items segun la afirmacion indicada.
2. La **lista de evidencias** asociadas a esa afirmacion.
3. Los **contextos** permitidos (pagina 6): Personal, Ocupacional y Productivo, Comunitario, Cientifico.

Mapa de afirmaciones → posiciones (resumido):

**Bloque 1: Geometria**
- Afirmacion 1 (circunferencias): items 1-4 | 3 evidencias
- Afirmacion 2 (traslaciones circunferencias): items 5-7 | 2 evidencias
- Afirmacion 3 (posicion relativa rectas/circ.): items 8-11 | 5 evidencias
- Afirmacion 4 (area/perimetro figuras planas): items 12-15 | 3 evidencias
- Afirmacion 5 (secciones figuras 3D): items 16-18 | 7 evidencias
- Afirmacion 6 (simetrias): items 19-20 | 2 evidencias
- Afirmacion 7 (transformaciones en el plano): items 21-23 | 4 evidencias

**Bloque 2: Relaciones y Algebra**
- Afirmacion 1 (funciones y composicion): items 24-28 | 4 evidencias
- Afirmacion 2 (funcion inversa): items 29-32 | 6 evidencias
- Afirmacion 3 (f(x)=a*sqrt(x+b)+c): items 33-35 | 3 evidencias
- Afirmacion 4 (logaritmos): items 36-41 | 12 evidencias
- Afirmacion 5 (sistemas 2x2): items 42-44 | 2 evidencias
- Afirmacion 6 (modelos matematicos): items 45-48 | 5 evidencias

**Bloque 3: Estadistica y Probabilidad**
- Afirmacion 1 (medidas de posicion): items 49-52 | 5 evidencias
- Afirmacion 2 (probabilidad eventos): items 53-56 | 5 evidencias
- Afirmacion 3 (variabilidad comparada): items 57-60 | 3 evidencias

### Paso 1 — Seleccion de evidencias

**Si items_requeridos <= evidencias_disponibles:** crear un item por evidencia seleccionada; si sobran evidencias, elegir cuales cubrir (o preguntar al usuario si quiere indicarlas).

**Si items_requeridos > evidencias_disponibles:** usar evidencias distintas para los items extra (diferentes contextos o representaciones); no repetir la misma evidencia con el mismo contexto.

**Prueba completa (60 items):** crear todos siguiendo la tabla; seleccionar libremente las evidencias de cada afirmacion aplicando las reglas anteriores.

Si el usuario indica que evidencias usar: respetar siempre su seleccion.

### Paso 2 — Pregunta de referencia

Cuando el usuario indique una afirmacion y/o bloque (sin pegar items directamente), preguntar obligatoriamente:

> "¿Tienes un item o items de referencia que quieras que emule, o procedo a crearlos analizando los documentos del proyecto?"

**Si el usuario proporciona items de referencia:** emular estructura, nivel de dificultad, tipo de contexto y redaccion, adaptando el contenido matematico a la afirmacion.

**Si el usuario no tiene items de referencia:** consultar `Ejemplos de examenes de pruebas estandarizadas/` para calibrar tipo de item, dificultad y redaccion.

**Excepcion:** Si el usuario ya pego un item directamente en el mensaje, no preguntar — proceder en modo emulacion de inmediato.

Cuando el usuario diga "mejore el folleto" o indique que actualizo `Folleto Prueba Estandarizada Sumativa Secundaria 2026.docx`, releer ese archivo antes de crear cualquier item nuevo.

## Compilacion LaTeX

Este proyecto tiene MiKTeX Portable instalado localmente. Usar este ejecutable para compilar con `pdflatex`:

`.codex/tools/miktex-portable/texmfs/install/miktex/bin/x64/pdflatex.exe`

Para compilar una prueba, preferir el helper:

`.codex/scripts/compile-exam.ps1`

Ejemplo:

`powershell -ExecutionPolicy Bypass -File .codex/scripts/compile-exam.ps1 "Examenes Pruebas estandarizadas/1PruebaEstandarizadaSecundaria2026.tex"`

Despues de compilar, eliminar los auxiliares generados (`.aux`, `.log`) directamente con `Remove-Item`.

## Version interactiva HTML

Cada prueba estandarizada creada en este proyecto debe poder tener una version HTML interactiva en la misma carpeta y con el mismo nombre base del PDF origen.

Ejemplo:

- PDF: `Examenes Pruebas estandarizadas/1PruebaEstandarizadaSecundaria2026.pdf`
- HTML: `Examenes Pruebas estandarizadas/1PruebaEstandarizadaSecundaria2026.html`

La version HTML debe reproducir los mismos items, opciones, notacion matematica y graficos. Debe generar unicamente el Modo Examen, con retroalimentacion y resultados. No generar, mostrar ni mencionar Modo Practica.

El texto del HTML no debe recortarse, resumirse ni parafrasearse respecto al `.tex`/PDF. Los enunciados, datos contextuales, preguntas y opciones deben coincidir en contenido con la fuente LaTeX, porque omitir texto puede cambiar la interpretacion del item. Solo adaptar la marcacion HTML necesaria para formato matematico o listas, sin eliminar informacion.

La secuencia de trabajo para pruebas debe ser siempre: primero crear o corregir el documento LaTeX, despues compilar y verificar el PDF, y por ultimo trasladar esos cambios al HTML con base en el `.tex` ya corregido. El HTML no debe adelantarse ni definir un orden distinto al documento LaTeX/PDF.

Si una expresion matematica con radicales, fracciones u otra notacion no se puede reproducir en HTML/CSS con la misma apariencia del PDF, renderizar esa expresion desde LaTeX a SVG e incrustarla o referenciarla en el HTML. Esto aplica especialmente a opciones de respuesta: el radical debe salir de `\sqrt{...}` y abarcar exactamente todo el subradical igual que en el PDF.

Cuando exista el `.tex`, usarlo como fuente principal para el HTML. Las figuras TikZ deben renderizarse desde el codigo `tikzpicture` real; no reconstruirlas manualmente en SVG/JavaScript salvo que no haya bloque TikZ disponible, que el renderizador falle despues de intentar corregirlo, o que el usuario pida una simplificacion explicita. La meta es que PDF y HTML compartan la misma fuente visual para evitar diferencias de escala, recortes, etiquetas movidas o flechas distintas.

Para crear o actualizar un HTML desde un `.tex`, primero generar/incrustar las figuras con:

`powershell -ExecutionPolicy Bypass -File .codex/scripts/render-tikz-for-html.ps1 "<archivo.tex>" "<archivo.html>"`

Si se necesita generar archivos SVG independientes desde una macro, un fragmento TikZ o todos los `tikzpicture` de un `.tex`, usar el renderizador flexible incorporado desde el proyecto de mini pruebas:

`powershell -ExecutionPolicy Bypass -File .codex/scripts/render-tikz-svg.ps1 "<archivo.tex>" -AllTikz`

Tambien admite `-Macro <nombre>`, `-Snippet "<codigo TikZ>"`, `-OutputDir`, `-OutputName`, `-KeepText` y `-KeepTemp`.

Si una figura TikZ se repite en varias opciones o se crea mediante una macro del `.tex`, renderizar esa macro o un fragmento TikZ equivalente con el mismo codigo y parametros del PDF. Si por excepcion se usa SVG manual, dejarlo lo mas simple posible, documentar mentalmente el motivo en la respuesta y verificar visualmente contra el PDF.

El PDF se usa como verificacion visual, no como fuente principal para reconstruir graficos. Despues de generar el HTML, revisar al menos los items con graficas para confirmar que no haya recortes, etiquetas perdidas, cambios de escala o diferencias visibles respecto al PDF.

## GitHub y publicacion

Cuando se realicen cambios en este proyecto, subirlos tambien al repositorio GitHub configurado (`origin/main`) mediante commit y push. Si el cambio afecta la version HTML publicada, verificar que GitHub Pages quede actualizado para que el enlace compartible por celular siga mostrando la version mas reciente:

`https://hoja1304-sudo.github.io/editor-examenes-latex/`

## Skills desde GitHub

Cuando el usuario indique una skill publicada en GitHub para este proyecto:

1. Descargar o copiar la skill dentro de `.codex/skills/<nombre-de-skill>/`.
2. Verificar que exista `SKILL.md` con frontmatter valido (`name` y `description`).
3. Conservar solo recursos necesarios: `scripts/`, `references/`, `assets/` y `agents/`.
4. Validar la skill con el verificador oficial cuando `PyYAML` este disponible.
5. Si falta una URL de GitHub, pedirla antes de intentar descargar.

No instalar skills globalmente salvo que el usuario lo pida de forma explicita.
