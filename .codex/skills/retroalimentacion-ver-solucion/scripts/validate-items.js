#!/usr/bin/env node
/**
 * Valida que el arreglo `const ITEMS=[...]` de una prueba HTML interactiva
 * (formato de este proyecto) siga siendo JavaScript valido despues de editar
 * el campo `e` (retroalimentacion) de uno o mas items, y reporta un resumen
 * util para revisar la edicion.
 *
 * Uso:
 *   node validate-items.js <ruta-al-archivo.html> [numeroItem ...]
 *
 * Ejemplo:
 *   node validate-items.js "2PruebaEstandarizadaSecundaria2026.html" 18 19 20
 *
 * Sin numeros de item, solo confirma que el archivo carga y muestra el total.
 */

const fs = require('fs');
const path = require('path');

const [, , filePath, ...itemArgs] = process.argv;

if (!filePath) {
  console.error('Uso: node validate-items.js <ruta-al-archivo.html> [numeroItem ...]');
  process.exit(1);
}

const absPath = path.resolve(filePath);
if (!fs.existsSync(absPath)) {
  console.error(`No existe el archivo: ${absPath}`);
  process.exit(1);
}

const html = fs.readFileSync(absPath, 'utf8');
const match = html.match(/const ITEMS=\[[\s\S]*?\];\s*\n/);

if (!match) {
  console.error('No se encontro "const ITEMS=[...]" en el archivo.');
  process.exit(1);
}

// FIG se simula con un Proxy: cualquier propiedad que se pida (FIG.i18,
// FIG.i04C, etc.) devuelve un string identificable, para poder confirmar que
// una figura fue referenciada dentro de `e` sin necesitar el SVG real.
const FIG = new Proxy({}, { get: (_target, prop) => `__FIG_${String(prop)}__` });

let items;
try {
  const buildItems = new Function('FIG', match[0].replace('const ITEMS=', 'return ') + ';');
  items = buildItems(FIG);
} catch (err) {
  console.error('ERROR: el arreglo ITEMS ya no es JavaScript valido.');
  console.error('Motivo:', err.message);
  console.error('\nRevisa el balance de comillas (\' vs `) del ultimo item que editaste.');
  console.error('Ver la seccion "Regla de sintaxis critica" del SKILL.md de esta skill.');
  process.exit(1);
}

console.log(`OK: el archivo es JavaScript valido. Total de items: ${items.length}.`);

const requested = itemArgs.map(Number).filter((n) => !Number.isNaN(n));

if (requested.length === 0) {
  process.exit(0);
}

console.log('');
for (const n of requested) {
  const it = items.find((i) => i.n === n);
  if (!it) {
    console.log(`Item ${n}: NO ENCONTRADO (revisa que el numero exista en el archivo).`);
    continue;
  }
  const key = it.k || it.r || '(sin clave)';
  const e = it.e || '';
  const pasos = (e.match(/class="paso"/g) || []).length;
  const tieneSvg = e.includes('<svg');
  const tieneTabla = e.includes('<table');
  const tieneFig = /__FIG_i\d+/.test(e);
  const tieneVerificacion = /verificar|verificaci[oó]n/i.test(e);
  const tieneConclusion = /conclusi[oó]n/i.test(e);
  console.log(
    `Item ${n}: clave=${key} | pasos=${pasos} | svg=${tieneSvg} | tabla=${tieneTabla} | figura_interpolada=${tieneFig} | verificacion=${tieneVerificacion} | conclusion=${tieneConclusion}`
  );
}
