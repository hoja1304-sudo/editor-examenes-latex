---
name: graficas-latex-estadistica
description: Crear, corregir y verificar graficas matematicas y estadisticas para examenes en LaTeX/TikZ/PGFPlots y su version HTML/SVG, especialmente ejes, funciones por tramos, graficas escalonadas, lineas punteadas, puntos, histogramas, diagramas de caja, tablas y notacion estadistica.
---

# Graficas LaTeX Y Estadistica

## Proposito

Usar esta skill cuando un examen, item o version HTML necesite graficas matematicas o estadisticas precisas y visualmente fieles al PDF: funciones, funciones por tramos, graficas escalonadas, puntos en plano cartesiano, diagramas de barras, histogramas, poligonos de frecuencia, ojivas, diagramas de caja, dispersion, tablas de frecuencia o notacion estadistica.

## Flujo Recomendado

1. Identificar la fuente maestra:
   - Si existe `.tex`, tratar TikZ/PGFPlots como fuente principal.
   - Usar el PDF solo para verificacion visual.
   - Para HTML, usar SVG renderizado desde TikZ/PGFPlots real cuando exista codigo fuente en el `.tex`; no recrear a mano la figura en SVG/JavaScript salvo excepcion justificada.
2. Determinar el tipo de grafica:
   - TikZ puro: ejes simples, puntos, segmentos, lineas punteadas, graficas escalonadas, regiones y diagramas escolares.
   - PGFPlots: funciones continuas, datos tabulares, barras, histogramas, dispersion, poligonos y graficas con escala numerica formal.
   - SVG manual en HTML: solo para ajustes puntuales o figuras pequenas; debe replicar la semantica del TikZ.
3. Definir escala y sistema de coordenadas antes de dibujar.
4. Dibujar primero ejes y referencias, despues funcion/datos, despues puntos y etiquetas.
5. Verificar que las lineas punteadas sean guias, no cuadriculas innecesarias.
6. En HTML/SVG, revisar que ningun `path` se rellene accidentalmente: usar `fill="none"` en grupos y trazos abiertos.
7. Comparar PDF y HTML en los items con graficas compartidas; si el HTML muestra un item por pantalla, repetir la figura en cada item dependiente.

## Reglas Para Examenes Estandarizados

- Puntos discretos: usar puntos pequenos; en TikZ preferir `\puntografico` cercano a `0.09` en coordenadas escaladas. En SVG, evitar radios dominantes salvo que el PDF los use.
- Lineas punteadas: deben conectar el punto con su eje o con el salto relevante. No convertirlas en cuadricula completa si el PDF solo muestra proyecciones.
- Ejes: usar flechas claras y margen para etiquetas. Si hay coordenadas negativas, extender el eje hacia la region negativa.
- Etiquetas numericas: alinear cada etiqueta con su guia punteada. En negativos del eje `x`, centrar los digitos y desplazar el signo con una forma como `\llap{-}`.
- Rotulos direccionales: si un plano cartesiano usa `y (norte)` y `x (este)`, esos rotulos deben quedar asociados visualmente a sus flechas. Colocar `y (norte)` centrado sobre el eje vertical cerca de la flecha superior y `x (este)` junto a la flecha derecha del eje horizontal; en SVG/HTML comprobar que las palabras completas se rendericen, no se recorten y no queden alejadas del eje.
- Graficas compartidas: si dos o tres items dependen de una figura, mantener encabezado, figura y preguntas juntos en PDF. En HTML, repetir o mantener visible la figura en cada item relacionado.
- No dibujar puntos que el estudiante debe inferir a partir de coordenadas, salvo que el enunciado diga que se muestran en la grafica.

## Patrones TikZ

Para ejes escolares con proyecciones:

```tex
\newcommand{\puntografico}{0.09}
\begin{tikzpicture}[x=0.45cm,y=0.45cm,>=stealth]
  \draw[->,thick] (0,0) -- (11,0) node[right] {$x$};
  \draw[->,thick] (0,0) -- (0,7) node[above] {$y$};
  \draw[dashed,gray] (5,0) -- (5,4) -- (0,4);
  \draw[thick] (1,2) -- (5,4) -- (9,3);
  \fill (5,4) circle (\puntografico);
  \node[below] at (5,0) {$5$};
  \node[left] at (0,4) {$4$};
\end{tikzpicture}
```

Para funciones escalonadas, representar extremos abiertos/cerrados de forma consistente:

```tex
\draw[thick] (0,1) -- (2,1);
\fill (2,1) circle (\puntografico);
\draw[fill=white,thick] (2,2) circle (\puntografico);
\draw[thick] (2,2) -- (5,2);
\draw[dashed,gray] (2,1) -- (2,2);
```

## Patrones PGFPlots

Usar `pgfplots` cuando haya datos estadisticos o escala numerica formal:

```tex
\begin{tikzpicture}
\begin{axis}[
  width=9cm,
  height=6cm,
  axis lines=left,
  xlabel={Tiempo},
  ylabel={Frecuencia},
  ymin=0,
  grid=none,
  tick align=outside,
  major tick length=2pt,
]
\addplot+[ybar,bar width=10pt] coordinates {
  (1,8) (2,12) (3,7) (4,15)
};
\end{axis}
\end{tikzpicture}
```

Para notacion estadistica, usar macros consistentes:

```tex
\newcommand{\media}{\bar{x}}
\newcommand{\desv}{s}
\newcommand{\varianza}{s^2}
\newcommand{\frecuencia}{f_i}
\newcommand{\frecuenciarel}{h_i}
\newcommand{\frecuenciaacum}{F_i}
```

## Reglas Para HTML/SVG

- En todo `path`, `polyline` o grupo de lineas abiertas, declarar `fill="none"`.
- Si se usan marcadores de flecha en varias figuras, dar IDs unicos o prefijados para evitar choques.
- Aplicar CSS a figuras incrustadas:

```css
.fig,
.choice-fig {
  display: block;
  max-width: 100%;
  height: auto;
  overflow: visible;
}
```

- No reconstruir a mano una figura TikZ compleja si el proyecto tiene renderizador TikZ a SVG disponible.
- Para figuras creadas por macros del `.tex`, renderizar la macro o un fragmento TikZ con los mismos parametros usados en el PDF.
- Si se reconstruye manualmente porque no hay otra opcion, conservar orden de capas: guias punteadas, funcion/datos, puntos, etiquetas; luego comparar visualmente contra el PDF y corregir recortes, escalas distintas y etiquetas perdidas.

## Validacion

Antes de entregar:

1. Compilar el `.tex` con el helper del proyecto cuando aplique.
2. Renderizar o abrir el HTML y comparar contra el PDF.
3. Revisar puntos, lineas punteadas, etiquetas de ejes y extremos abiertos/cerrados.
4. Buscar rellenos accidentales en SVG:

```powershell
rg -n "<path|<polyline|fill=\"none\"|stroke-dasharray" archivo.html
```

5. Confirmar que los items relacionados con una misma grafica no queden sin referente visual.
