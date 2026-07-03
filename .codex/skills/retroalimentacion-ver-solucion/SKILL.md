---
name: retroalimentacion-ver-solucion
description: Guia para escribir y editar el campo `e` (retroalimentacion) de cada item dentro del arreglo `const ITEMS=[...]` de las pruebas HTML interactivas de este proyecto (ej. 2PruebaEstandarizadaSecundaria2026.html), es decir, el contenido que aparece en la pestana "ver solucion" de cada item. Usar esta skill SIEMPRE que el usuario pida: agregar, mejorar, detallar o corregir la retroalimentacion/solucion de uno o varios items; incluir una figura, tabla o grafica en la solucion; mostrar el despeje o procedimiento paso a paso de un ejercicio; explicar por que las otras opciones estan mal; o revisar si la clave de un item es correcta. Tambien aplica si el usuario dice cosas como "revisa el item X", "la solucion del item X deberia ser la opcion Y", "agrega la imagen del enunciado a la solucion", "hazlo mas detallado" o "no se ve bien la figura de la solucion", incluso si no mencionan la palabra "retroalimentacion" explicitamente.
---

# Retroalimentacion y pestana "Ver solucion"

## Por que esto importa

Estas pruebas HTML son lo unico que el estudiante ve despues de responder: si la
retroalimentacion salta pasos, el estudiante no aprende nada nuevo con respecto a
simplemente saber si acerto o no. El objetivo de esta skill es que cada solucion
funcione como una mini-clase autocontenida: el estudiante deberia poder tapar la
pregunta, leer solo la retroalimentacion, y entender de principio a fin por que la
respuesta es la que es, sin tener que adivinar un paso que se omitio.

La segunda razon de ser de esta skill es puramente tecnica: el campo `e` vive dentro
de un archivo `.html` gigante como una sola linea de JavaScript por item, y es muy
facil romper el archivo entero con una comilla mal puesta. La seccion de reglas de
sintaxis existe porque eso paso varias veces durante el desarrollo de este proyecto.

## Como esta armado un item

Cada item es un objeto dentro de `const ITEMS=[...]` (busca `const ITEMS=` en el
archivo). Campos relevantes para esta skill:

- `q`: el enunciado (pregunta), casi siempre un *template literal* (comillas
  invertidas `` ` ``) porque necesita interpolar figuras con `${FIG.iXX}`.
- `A`, `B`, `C`, `D`: las cuatro opciones.
- `k` (items 1-32 aprox.) o `r` (items 33+ aprox.): la clave de respuesta correcta.
  Ambos nombres funcionan — el visor JS hace `const key = it.k || it.r`. No asumas
  cual usa un item sin revisarlo primero.
- `e`: el HTML de retroalimentacion, mostrado en `#retro-view` cuando el estudiante
  pulsa "Ver solucion". Se renderiza con MathJax. **Este es el campo que edita esta
  skill.**

El contenido de `e` se arma con bloques `<span class="paso">`, normalmente en este
orden (ver "Estructura de una buena solucion" mas abajo para el detalle de cada
uno): contexto/formula → figura o tabla del item → pasos del procedimiento con el
despeje completo → verificacion → nota sobre las opciones incorrectas → conclusion.

## Regla de sintaxis critica: tipo de comilla

Esta es la causa mas comun de que el archivo deje de cargar despues de una edicion.

`e` casi siempre empieza como un string de comillas simples: `e:'<span>...</span>'`.
Eso funciona perfecto si el contenido es HTML/texto plano. El problema aparece en
dos casos:

1. **Vas a interpolar algo con `${...}`** (por ejemplo `${FIG.i18}` para insertar
   una figura, o `${FIG.i04C}` para la grafica de una opcion). Los strings de
   comilla simple en JavaScript **no interpolan** `${...}` — si lo dejas ahi tal
   cual, el estudiante vera literalmente el texto `${FIG.i18}` en pantalla en vez
   de la figura. Para interpolar, todo el valor de `e` tiene que ser un *template
   literal*: cambia **tanto la comilla de apertura (`e:'` → `` e:` ``) como la de
   cierre (`'}` → `` `}``)**. Es facil cambiar solo una de las dos y dejar el
   archivo con una comilla suelta — despues de este cambio, siempre valida (ver
   seccion de validacion) antes de seguir.
2. **Vas a escribir el texto de un punto "primado"** como *A′* (la imagen de un
   punto A bajo una transformacion) o *P′*. Si escribes el apostrofo normal `A'`
   dentro de un string de comilla simple, cierras el string a la mitad de la
   palabra y rompes todo el resto de la linea. Usa el caracter Unicode prima
   `′` (U+2032) en su lugar — visualmente es indistinguible y no rompe nada. Si de
   verdad necesitas un apostrofo recto en el texto, esa es otra senal de que
   conviene convertir el string a template literal.

Si en cambio solo vas a insertar HTML literal sin `${...}` (por ejemplo una
`<table class="rotulo">...</table>` copiada tal cual del enunciado), **no hace
falta convertir nada** — las comillas dobles de los atributos HTML conviven sin
problema dentro de un string de comilla simple de JS.

Los delimitadores de matematica de MathJax van con doble backslash porque estan
dentro de un string de JS: `\\(...\\)` para linea (inline) y `\\[...\\]` para
bloque (display). Un solo backslash no compila. Los numeros usan la convencion de
Costa Rica: coma decimal (`2{,}5`, `12{,}4`) y separador de miles con espacio fino
LaTeX (`54\\,500`).

## Regla de contenido: siempre mostrar el material visual del item

Si el enunciado (`q`) muestra una figura (`${FIG.iXX}`), una tabla
(`<table class="rotulo">`) o una grafica, la solucion casi siempre se beneficia de
mostrar eso mismo otra vez, justo en el paso donde el estudiante necesita leer un
dato de ahi — no lo obligues a scrollear hacia arriba a la pregunta para recordar
un numero.

- **Figura ya existente (`FIG.iXX`)**: insertala con
  `<div class="fig">${FIG.iXX}</div>` en el punto del paso correspondiente. Esto
  requiere que `e` sea un template literal (ver regla de comillas arriba).
- **Tabla ya existente**: copia el `<table class="rotulo">...</table>` tal cual
  aparece en `q` — no necesita conversion de comillas porque no usa `${...}`.
- **La solucion es una opcion grafica especifica** (items estilo "cual grafica
  corresponde a...", donde `A`, `B`, `C`, `D` son ellas mismas `FIG.iXXA/B/C/D`):
  no repitas las cuatro, inserta solo la de la respuesta correcta en el paso de
  verificacion, para que el estudiante vea la grafica ganadora sin tener que volver
  a comparar las cuatro.

## Cuando no existe una figura pero ayudaria muchisimo

Algunos items son puramente algebraicos o dan la informacion en el enunciado sin
graficarla (por ejemplo, "el radio mide 3.5 cm y la altura 8 cm" sin dibujo). Si un
dibujo simple ayudaria a visualizar la relacion (semejanza de triangulos,
reflexion, rotacion, homotecia, una recta y su perpendicular, una funcion y su
inversa, etc.), construye un SVG propio en vez de dejarlo solo en palabras.

El archivo `references/svg-cookbook.md` tiene ejemplos completos y funcionando
(copiados de items reales de este proyecto: reflexion sobre una recta, rotacion
90°, homotecia con rayos desde el foco, funcion vs. su inversa, cono con triangulos
semejantes). Leelo antes de construir un SVG desde cero — es mucho mas rapido
adaptar uno de esos que empezar de la nada, y mantiene el mismo lenguaje visual en
todo el archivo. Resumen de las convenciones:

- **Mapeo de coordenadas**: convierte las coordenadas reales del problema (las que
  usa el `tikzpicture` de origen, si existe) a pixeles con dos formulas lineales,
  `px(x) = a + escala*x` y `py(y) = b - escala*y` (el signo negativo porque en SVG
  el eje `y` crece hacia abajo). Calcula `a`, `b` y `escala` una vez, y luego usa
  esas mismas formulas para *todos* los puntos del dibujo — asi garantizas que
  todo quede geometricamente consistente entre si. Verifica mentalmente al menos
  dos puntos conocidos antes de dar el SVG por terminado.
- **Estilo de linea**: minimalista, tipo diagrama de geometria — trazos negros o
  grises fill:none, sin gradientes ni fotorrealismo (los SVG con gradiente/3D de
  algunos items antiguos del bloque de solidos son la excepcion historica, no el
  patron a seguir para figuras nuevas).
- **Color con significado, no decorativo**: usa color solo cuando distingue algo
  conceptualmente — verde para un objeto/altura, morado o magenta para su imagen
  bajo una transformacion o su inversa, rojo para una distancia o segmento que hay
  que resaltar, azul para las coordenadas o puntos dados. Todo lo demas (ejes,
  figura base, lineas guia) va en negro o gris.
- **Lineas discontinuas** (`stroke-dasharray`) para lineas auxiliares/de
  proyeccion que no son parte de la figura real (radios punteados, perpendiculares
  de referencia, lineas que bajan a los ejes).
- **Flechas simples**: un `<polygon>` triangular pequeno es mas facil de controlar
  y de orientar correctamente que un `<marker>` de SVG, sobre todo en flechas
  dobles o curvas.
- Ajusta el `viewBox` con margen suficiente para que las etiquetas de texto mas
  largas (`x+8`, `(-6, 2)`, `3,5 cm`) no se corten en el borde; es preferible un
  poco de espacio de mas a que se vea un texto cortado a la mitad.

## El despeje algebraico no debe saltarse pasos

Esta es la diferencia entre una solucion mediocre y una buena en este proyecto.
Antes de esta skill, una solucion tipica escribia algo como:

> Despejar: `2√(v-1) = 8` ⟹ `√(v-1) = 4` ⟹ `v - 1 = 16` ⟹ `v = 17`

Eso es correcto pero opaco: el estudiante que no domina el tema no ve *que
operacion* se aplico entre un paso y el siguiente, solo ve el resultado. La version
que si ensena algo muestra, para cada paso, dos lineas de matematica en bloque
(`\\[...\\]`): la ecuacion con la operacion aplicada literalmente **a ambos
lados**, y despues la version ya simplificada — mas una frase corta que nombra la
operacion inversa y por que se usa. Por ejemplo:

```
Paso 2. Aislar el radical. Para eliminar el +4, se aplica la operacion inversa:
restar 4 en ambos lados de la igualdad:
\[2\sqrt{v-1} + 4 - 4 = 12 - 4\]
\[2\sqrt{v-1} = 8\]

Paso 3. Dejar sola la raiz. El 2 esta multiplicando a la raiz, asi que se aplica
la operacion inversa: dividir ambos lados entre 2:
\[\frac{2\sqrt{v-1}}{2} = \frac{8}{2}\]
\[\sqrt{v-1} = 4\]
```

Aplica este patron a cualquier ecuacion que el estudiante tenga que despejar
(lineales, con radicales, cuadraticas, funciones inversas, proporciones). No hace
falta en pasos que no son despejes (leer un dato de una grafica, sumar un area,
contar puntos muestrales) — ahi el detalle util es otro (ver siguiente seccion).

## Estructura de una buena solucion (checklist por item)

No todos los items necesitan los siete puntos — usa criterio segun el tipo de
ejercicio — pero revisa esta lista antes de dar una solucion por terminada:

1. **Contexto/formula**: si hace falta recordar una formula o definicion antes de
   usarla (formula de la circunferencia, condicion de perpendicularidad, que es un
   diagrama de caja, etc.), dilo en un paso aparte antes de aplicarla a ciegas.
2. **Figura, tabla o grafica del item**: incluida donde se necesita el dato (ver
   seccion de arriba). Si no existe y ayudaria, construye una (ver
   `references/svg-cookbook.md`).
3. **Procedimiento paso a paso**: cada paso hace *una* cosa. Si es un despeje,
   sigue la regla de "ambos lados" de la seccion anterior. Si es lectura de datos,
   cita los valores exactos ("la grafica muestra los puntos (6,5), (10,25)...").
4. **Verificacion**: sustituye la respuesta de vuelta en la ecuacion, formula o
   condicion original y confirma que cumple. Esto no es opcional — es lo que le
   ensena al estudiante a autocorregirse en el examen real.
5. **Nota sobre las opciones incorrectas** (cuando se pueda identificar el error
   tipico con confianza, sin inventar numeros): que operacion faltante o error de
   signo llevaria a cada distractor. Si no puedes verificar el error exacto de una
   opcion con los datos que tienes, no inventes una explicacion — omite la nota o
   se generica ("las demas opciones no cumplen la condicion X").
6. **Conclusion**: una linea final, `Respuesta: X`, sin ambiguedad.
7. Si mientras escribes la solucion notas que la clave (`k`/`r`) actual no
   corresponde a lo que da el procedimiento correcto, dilo explicitamente y
   corrige la clave — no lo dejes pasar en silencio (esto paso al menos una vez en
   este proyecto: un item tenia un despeje con un error algebraico que llevaba a
   la clave equivocada).

## Validar despues de cada edicion

Como todo vive en una sola linea de JS por item dentro de un archivo `.html`
gigante, un `Edit` con una comilla o un backtick de mas no siempre se nota a
simple vista. Despues de editar uno o varios items, corre el script de validacion
incluido en esta skill:

```bash
node ".codex/skills/retroalimentacion-ver-solucion/scripts/validate-items.js" "ruta/al/archivo.html" 18 19 20
```

(los numeros de item al final son opcionales; sin ellos solo confirma que el
archivo entero carga). El script carga el arreglo `ITEMS` con `new Function` y un
`Proxy` que simula `FIG`, y reporta si el archivo sigue siendo JavaScript valido,
cuantos items tiene en total, y para los numeros de item pedidos, su clave
(`k`/`r`), cuantos `<span class="paso">` tiene y si incluye un `<svg>` o
`<table>`. Si el script truena con un error de sintaxis, la ubicacion del error
casi siempre es el ultimo item que editaste — revisa ahi primero el balance de
comillas.

No le muestres al usuario un item como terminado sin haber corrido este chequeo al
menos una vez sobre ese item.
