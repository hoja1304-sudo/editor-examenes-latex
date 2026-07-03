# Recetario de SVG para soluciones

Ejemplos reales, ya probados y validados, tomados de items de este proyecto. Cada
uno esta pensado para copiarse y adaptarse (cambiar coordenadas, etiquetas y
colores) en vez de escribirse desde cero. Todos siguen el mismo metodo:

1. Identifica las coordenadas reales del problema (del `tikzpicture` de origen en
   el `.tex`, si existe, o de los datos del enunciado).
2. Define `px(x) = a + escala*x` y `py(y) = b - escala*y` con una `escala` y unos
   margenes (`a`, `b`) que quepan comodos en un `viewBox` razonable (200-400 de
   ancho/alto suele bastar).
3. Convierte cada punto relevante con esas dos formulas — nunca coordenadas "a
   ojo" sueltas, o el dibujo queda inconsistente consigo mismo.
4. Verifica un par de puntos conocidos antes de darlo por bueno (por ejemplo, que
   la distancia entre dos puntos convertidos corresponda proporcionalmente a la
   distancia real).

## Indice

- [Reflexion sobre una recta (item 21)](#reflexion-sobre-una-recta)
- [Rotacion 90° alrededor del origen (item 23)](#rotacion-90)
- [Homotecia con rayos desde el foco (item 22)](#homotecia-con-rayos-desde-el-foco)
- [Funcion y su inversa, mismo par de ejes (item 29)](#funcion-y-su-inversa)
- [Cono/semejanza de triangulos con medidas (item 18)](#cono-semejanza-de-triangulos)
- [Plantilla de flecha simple sin `<marker>`](#plantilla-de-flecha-simple)

---

## Reflexion sobre una recta

Caso: reflejar el punto `A(-2, 6)` respecto a la recta `y = -x` para obtener
`A′(-6, 2)`. Muestra la recta espejo, el punto original, su imagen, el segmento
perpendicular que los une (rojo punteado) y una marca de angulo recto donde ese
segmento cruza la recta espejo.

Colores: recta espejo en verde (`#1a7d2b`), punto original en azul (`#1a3fcc`),
punto imagen en morado (`#7a1aa8`), segmento de union en rojo (`#c0392b`).

```html
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 430 340" style="display:block;margin:10px auto;max-width:340px">
  <line x1="20" y1="260" x2="410" y2="260" stroke="#333" stroke-width="1.6"/>
  <polygon points="410,260 402,256 402,264" fill="#333"/>
  <line x1="290" y1="320" x2="290" y2="20" stroke="#333" stroke-width="1.6"/>
  <polygon points="290,20 286,28 294,28" fill="#333"/>
  <text x="415" y="264" font-size="13" fill="#333">x</text>
  <text x="278" y="16" font-size="13" fill="#333">y</text>
  <line x1="50" y1="20" x2="350" y2="320" stroke="#1a7d2b" stroke-width="2.2"/>
  <text x="300" y="330" font-size="14" fill="#1a7d2b" font-weight="bold">y = -x</text>
  <line x1="230" y1="80" x2="110" y2="200" stroke="#c0392b" stroke-width="1.8" stroke-dasharray="5,3"/>
  <rect x="163" y="133" width="12" height="12" fill="none" stroke="#333" stroke-width="1.2" transform="rotate(45 170 140)"/>
  <circle cx="230" cy="80" r="5" fill="#1a3fcc"/>
  <circle cx="110" cy="200" r="5" fill="#7a1aa8"/>
  <circle cx="290" cy="260" r="3.5" fill="#111"/>
  <text x="238" y="72" font-size="14" fill="#1a3fcc" font-weight="bold">A(-2, 6)</text>
  <text x="10" y="216" font-size="14" fill="#7a1aa8" font-weight="bold">A&#8242;(-6, 2)</text>
  <text x="296" y="274" font-size="12" fill="#111">O</text>
</svg>
```

Nota de sintaxis: el caracter `′` (prima) se escribe como entidad HTML `&#8242;`
dentro del SVG para evitar cualquier ambiguedad con las comillas del string de JS
que envuelve todo esto.

---

## Rotacion 90°

Caso: rotar `P(3, -2)` 90° en sentido antihorario alrededor del origen para
obtener `P′(2, 3)`. Muestra los radios punteados (misma longitud, porque una
rotacion preserva la distancia al centro) y una flecha curva que indica el sentido
del giro. La curva se aproxima con una polilinea de 4-5 puntos calculados en
coordenadas polares (no con un arco SVG real, para evitar pelearse con los flags
`large-arc`/`sweep`):

```html
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 270 270" style="display:block;margin:10px auto;max-width:280px">
  <line x1="20" y1="150" x2="250" y2="150" stroke="#333" stroke-width="1.4"/>
  <polygon points="250,150 243,146 243,154" fill="#333"/>
  <line x1="120" y1="250" x2="120" y2="20" stroke="#333" stroke-width="1.4"/>
  <polygon points="120,20 116,28 124,28" fill="#333"/>
  <text x="252" y="154" font-size="12" fill="#333">x</text>
  <text x="108" y="16" font-size="12" fill="#333">y</text>
  <line x1="120" y1="150" x2="210" y2="210" stroke="#555" stroke-width="1.2" stroke-dasharray="4,3"/>
  <line x1="120" y1="150" x2="180" y2="60" stroke="#555" stroke-width="1.2" stroke-dasharray="4,3"/>
  <polyline points="210,210 226,169 226,131 214,96 180,60" fill="none" stroke="#e08020" stroke-width="2.2"/>
  <polygon points="180,60 192,65 185,72" fill="#e08020"/>
  <circle cx="120" cy="150" r="3.5" fill="#111"/>
  <circle cx="210" cy="210" r="5" fill="#1a3fcc"/>
  <circle cx="180" cy="60" r="5" fill="#7a1aa8"/>
  <text x="126" y="164" font-size="12" fill="#111">O</text>
  <text x="185" y="228" font-size="14" fill="#1a3fcc" font-weight="bold">P(3, -2)</text>
  <text x="140" y="52" font-size="14" fill="#7a1aa8" font-weight="bold">P&#8242;(2, 3)</text>
  <text x="165" y="130" font-size="13" fill="#e08020" font-weight="bold">90°</text>
</svg>
```

Como generar la polilinea de la curva para otro angulo: calcula el angulo de
inicio y fin en coordenadas matematicas (`atan2(y,x)`), muestrea 3-5 angulos
intermedios yendo en la direccion correcta (creciente para antihorario), y
convierte cada `(r*cos(theta), r*sin(theta))` con las mismas formulas `px`/`py`
del resto del dibujo.

---

## Homotecia con rayos desde el foco

Caso: un cuadrilatero `ABCD` y su imagen `EFGH` bajo una homotecia de razon 2 con
foco `P`. Muestra ambas figuras (una en azul, la otra en verde) y rayos punteados
desde `P` que pasan por cada vertice y su correspondiente — la prueba visual de
que la razon es constante es que `P`, cada vertice y su imagen quedan alineados.

```html
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 340 170" style="display:block;margin:10px auto;max-width:340px">
  <line x1="20" y1="125" x2="320" y2="125" stroke="#333" stroke-width="1.4"/>
  <polygon points="320,125 313,121 313,129" fill="#333"/>
  <line x1="30" y1="150" x2="30" y2="15" stroke="#333" stroke-width="1.4"/>
  <polygon points="30,15 26,23 34,23" fill="#333"/>
  <line x1="30" y1="125" x2="180" y2="65" stroke="#999" stroke-width="1.2" stroke-dasharray="4,3"/>
  <line x1="30" y1="125" x2="240" y2="35" stroke="#999" stroke-width="1.2" stroke-dasharray="4,3"/>
  <polygon points="120,125 105,95 135,80 165,125" fill="rgba(26,63,204,0.12)" stroke="#1a3fcc" stroke-width="1.8"/>
  <polygon points="210,125 180,65 240,35 300,125" fill="rgba(26,125,43,0.12)" stroke="#1a7d2b" stroke-width="1.8"/>
  <circle cx="30" cy="125" r="3.5" fill="#111"/>
  <circle cx="120" cy="125" r="3.5" fill="#1a3fcc"/>
  <circle cx="210" cy="125" r="3.5" fill="#1a7d2b"/>
  <text x="22" y="140" font-size="12" fill="#111" font-weight="bold">P</text>
  <text x="118" y="140" font-size="12" fill="#1a3fcc" font-weight="bold">A</text>
  <text x="208" y="140" font-size="12" fill="#1a7d2b" font-weight="bold">E</text>
</svg>
```

(version resumida — en la practica se etiquetan los ocho vertices, ver item 22 del
archivo `2PruebaEstandarizadaSecundaria2026.html` para la version completa con
`B`, `C`, `D`, `F`, `G`, `H`).

---

## Funcion y su inversa

Caso: mostrar por separado la grafica de una funcion lineal `f` y la de su
inversa `f⁻¹`, cada una en su propio par de ejes, con lineas punteadas que marcan
las coordenadas de los puntos extremos. Util en cualquier item de "funcion
inversa" donde el enunciado solo da la formula algebraica sin dibujar la grafica.

```html
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 340" style="display:block;margin:10px auto;max-width:220px">
  <line x1="25" y1="310" x2="175" y2="310" stroke="#333" stroke-width="1.5"/>
  <polygon points="175,310 168,306 168,314" fill="#333"/>
  <line x1="40" y1="325" x2="40" y2="35" stroke="#333" stroke-width="1.5"/>
  <polygon points="40,35 36,43 44,43" fill="#333"/>
  <text x="178" y="314" font-size="13" fill="#333">t</text>
  <text x="14" y="28" font-size="13" fill="#333">f(t)</text>
  <line x1="130" y1="70" x2="130" y2="310" stroke="#999" stroke-width="1" stroke-dasharray="4,3"/>
  <line x1="40" y1="70" x2="130" y2="70" stroke="#999" stroke-width="1" stroke-dasharray="4,3"/>
  <line x1="40" y1="250" x2="130" y2="70" stroke="#1a3fcc" stroke-width="2.4"/>
  <circle cx="40" cy="250" r="4.5" fill="#1a3fcc"/>
  <circle cx="130" cy="70" r="4.5" fill="#1a3fcc"/>
  <text x="8" y="245" font-size="11" fill="#1a3fcc">(0,2)</text>
  <text x="136" y="66" font-size="11" fill="#1a3fcc">(3,8)</text>
</svg>
```

Para la inversa, dibuja el mismo tipo de figura con los ejes/puntos
intercambiados (si `f` va de `(0,2)` a `(3,8)`, `f⁻¹` va de `(2,0)` a `(8,3)`) y
usa el color morado en vez de azul para distinguirla visualmente de la original.

---

## Cono/semejanza de triangulos

Caso general para cualquier problema de solidos con un corte que genera dos
figuras semejantes (cono truncado, piramide truncada). Muestra el solido grande
con lineas punteadas para el contorno oculto, el corte marcado, y a la derecha
flechas verticales de "altura pequena", "altura del tramo cortado" y "altura
total" en colores distintos (verde, azul, morado) con una leyenda de texto debajo
explicando que representa cada letra. Ver el item 18 de
`2PruebaEstandarizadaSecundaria2026.html` para el codigo SVG completo — es largo
(~40 elementos) pero cada elemento es una linea, circulo o texto simple; conviene
copiarlo entero y solo cambiar coordenadas y numeros.

---

## Plantilla de flecha simple

Para una flecha vertical u horizontal doble (usada en cotas de medidas), en vez de
pelear con `<marker>` y su orientacion, dibuja la linea y dos triangulos
`<polygon>` en los extremos apuntando hacia afuera:

```html
<line x1="290" y1="20" x2="290" y2="130" stroke="#1a7d2b" stroke-width="1.6"/>
<polygon points="290,20 286,28 294,28" fill="#1a7d2b"/>
<polygon points="290,130 286,122 294,122" fill="#1a7d2b"/>
<text x="300" y="78" font-size="13" fill="#1a7d2b" font-style="italic">x</text>
```

Para el otro extremo de una flecha horizontal, el mismo patron con `x`/`y`
intercambiados en los triangulos.
