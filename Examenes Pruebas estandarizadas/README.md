# Flujo de trabajo

## Archivos oficiales

- `1PruebaEstandarizadaSecundaria2026.tex`: fuente maestra de la prueba final.
- `1PruebaEstandarizadaSecundaria2026.pdf`: PDF generado desde el documento maestro.
- `1PruebaEstandarizadaSecundaria2026.html`: version interactiva de la prueba.

## Carpetas

- `borradores/`: archivos de trabajo por bloque o afirmacion. Se conservan como respaldo mientras se revisan items.
- `borradores/revisiones/`: versiones HTML o documentos de revision que no son la version interactiva final.
- `temporales/logs/`: archivos auxiliares de compilacion como `.aux` y `.log`.
- `temporales/previews/`: imagenes PNG usadas para revisar paginas o graficos.
- `temporales/checks/`: PDFs de verificacion generados durante revisiones puntuales.

## Regla practica

Cuando un bloque de items quede aprobado, se integra en el archivo maestro y el siguiente bloque se trabaja desde ahi. Los archivos temporales pueden regenerarse cuando haga falta, pero no deben mezclarse con los documentos oficiales.
