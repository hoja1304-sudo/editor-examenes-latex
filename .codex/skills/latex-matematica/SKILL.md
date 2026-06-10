---
name: latex-matematica
description: Crear y editar examenes matematicos en LaTeX. Usar cuando Codex necesite generar documentos .tex, plantillas de examen, ejercicios, solucionarios, figuras con TikZ, graficas con PGFPlots, o convertir ejercicios sueltos a formato de examen compilable.
---

# LaTeX Matematica

## Proposito

Usar esta skill para producir documentos matematicos en LaTeX limpios, compilables y faciles de mantener, especialmente examenes, practicas, bancos de ejercicios y solucionarios.

## Procedimiento

1. Revisar el proposito del documento: nivel, tema, cantidad de ejercicios, formato esperado, si incluye respuestas o solucionario, y si debe compilar a PDF.
2. Elegir una plantilla adecuada segun el contexto: examen, practica, solucionario, banco de ejercicios o documento mixto.
3. Escribir LaTeX limpio y consistente:
   - Usar paquetes comunes solo cuando sean necesarios.
   - Separar encabezado, instrucciones, ejercicios y soluciones.
   - Mantener nombres de comandos claros si se definen macros.
4. Crear figuras con TikZ cuando el ejercicio incluya geometria, diagramas, rectas, puntos, regiones, vectores o construcciones.
5. Crear graficas con PGFPlots cuando el ejercicio incluya funciones, curvas, datos, areas bajo la curva, sistemas de ejes o comparaciones graficas.
6. Compilar el documento cuando el entorno tenga LaTeX disponible.
7. Corregir errores de compilacion y advertencias relevantes antes de entregar.
8. Entregar el archivo `.tex` y, si el usuario lo pide o el flujo lo requiere, tambien el PDF.

## Criterios De Calidad

- Priorizar codigo LaTeX legible sobre trucos compactos.
- Evitar paquetes innecesarios o incompatibles entre si.
- Para matematicas, usar entornos semanticos como `align`, `cases`, `pmatrix`, `tikzpicture` y `axis` cuando correspondan.
- Para solucionarios, mostrar pasos suficientes para que el razonamiento sea verificable.
- Para examenes, cuidar numeracion, puntajes, instrucciones y espacio de respuesta.
- En figuras TikZ, usar puntos pequenos y discretos para ubicaciones: preferir una macro como `\puntografico` con valor cercano a `0.09` en coordenadas TikZ escaladas. Evitar puntos grandes; los puntos deben funcionar como marcas sutiles y no dominar la figura.
- Si un item evalua que el estudiante determine si puntos dados pertenecen a una circunferencia o region, no dibujar esos puntos en la grafica salvo que el enunciado lo pida explicitamente; las coordenadas deben aparecer en el texto para que el estudiante deduzca la ubicacion.
- En diagramas con ejes y lineas punteadas de proyeccion, alinear las etiquetas numericas con su linea guia. Para valores sobre el eje `x`, colocar el nodo centrado bajo la proyeccion vertical usando `node[anchor=north] at (x,0) {...}` o un ajuste equivalente. Para valores negativos sobre el eje `x`, centrar los digitos bajo la guia y dejar el signo menos hacia la izquierda; usar una forma como `$\llap{-}12$` en lugar de centrar todo el texto `-12`. Para valores sobre el eje `y`, centrar la etiqueta junto a la proyeccion horizontal usando `anchor=east` o `anchor=west` segun el lado del eje.
- En planos cartesianos de pruebas estandarizadas, dibujar flechas en ambos extremos de los ejes `x` y `y` con `\draw[<->, thick] ...`. Si el grafico usa coordenadas negativas, extender el eje correspondiente hacia la parte negativa para que el punto, la proyeccion y la etiqueta numerica queden dentro de la escala visible.
- En diagramas cartesianos contextualizados, reproducir fielmente la rotulacion de ejes del modelo: `$y$ (norte)` debe quedar arriba y a la izquierda del eje vertical, y `$x$ (este)` al extremo derecho del eje horizontal, ligeramente separado de la linea. Para que la conversion a SVG no recorte ni pierda los rotulos, no poner estas etiquetas como `node` pegado al final del `\draw`; dibujar el eje, agregar una `\path[use as bounding box] ...` con margen suficiente y colocar los rotulos en nodos separados dentro de esa caja.
- Si la rotulacion contextual incluye `$y$ (norte)` y `$x$ (este)`, alinear cada rotulo con la flecha del eje correspondiente: colocar `$y$ (norte)` sobre la punta superior de la flecha del eje `y`, centrado con respecto al eje vertical, y colocar `$x$ (este)` junto a la flecha derecha del eje horizontal. Reservar margen en el bounding box para que ambos rotulos queden completos en PDF y en la conversion SVG/HTML.
- Evitar que un item quede partido entre paginas. Antes de cada item largo, reservar espacio con `\Needspace{...}` del paquete `needspace`; si no cabe el bloque formado por contexto, grafico, pregunta y opciones, mover el item completo a la pagina siguiente.
- Si se edita un `.tex` existente, preservar el estilo local del documento salvo que el usuario pida reestructurarlo.

## Plantilla Base Recomendada

Usar esta estructura como punto de partida cuando no exista una plantilla del proyecto:

```tex
\documentclass[12pt]{article}
\usepackage[spanish]{babel}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{amsmath, amssymb}
\usepackage{geometry}
\usepackage{enumitem}
\usepackage{needspace}
\usepackage{tikz}
\usepackage{pgfplots}
\pgfplotsset{compat=1.18}

\geometry{letterpaper, margin=2cm}

\begin{document}

\begin{center}
  {\Large \textbf{Examen de Matematica}}\\
  Nombre: \rule{7cm}{0.4pt}\hfill Fecha: \rule{3cm}{0.4pt}
\end{center}

\section*{Instrucciones}
Resuelva de forma ordenada. Justifique sus respuestas cuando corresponda.

\begin{enumerate}[label=\textbf{\arabic*.}]
  \Needspace{0.75\textheight}
  \item Primer ejercicio.
\end{enumerate}

\end{document}
```

## Validacion

Cuando sea posible, compilar con `pdflatex`, `xelatex` o el comando usado por el proyecto. En este proyecto, preferir MiKTeX Portable:

```powershell
powershell -ExecutionPolicy Bypass -File .codex/scripts/compile-exam.ps1 "ruta/al/archivo.tex"
```

Si la compilacion falla, leer el log, corregir el `.tex` y repetir hasta obtener salida correcta o explicar con precision que dependencia falta.
