# EduGT - Fase 3: Inscripción, progreso y certificados

Proyecto de Bases de Datos II, Universidad Rafael Landívar, Sección 02.

Esta fase implementa el flujo completo del estudiante en la plataforma: inscripción con cobro contra billetera, registro de avance por módulo, evaluación final y emisión automática de certificados con correlativo anual sin huecos. También incluye el manejo de concurrencia para cupos limitados y progreso simultáneo.

## Orden de ejecución

| # | Script | Qué hace |
|---|---|---|
| 1 | 01_CreacionBD.sql | Crea la base de datos EduGT y todas las tablas |
| 2 | 02_Fase2Procedimientos.sql | Crea los procedimientos y la vista de la Fase 2 |
| 3 | 03_EduGT_Datos_Prueba.sql | Borra los datos existentes, reinicia los IDs e inserta los datos base |
| 4 | 05_Datos_Prueba_Fase3.sql | Agrega los estudiantes, cursos, cohortes e inscripciones de la Fase 3 |
| 5 | Proyecto BD II - Fase III - Script Completo.sql | Crea las funciones, procedimientos, vista e índice de la Fase 3, junto con sus pruebas |

### Sobre el script 04

04_Casos_de_Prueba.sql.sql no se utiliza en esta fase. Contiene las pruebas de la Fase 2 y se incluye únicamente como evidencia de esa entrega. No debe ejecutarse antes del script 05, porque crea registros que chocan con los IDs de los datos de Fase 3.

## Objetos de la Fase 3

| Objeto | Descripción |
|---|---|
| fn_CursoPreRequisito | Valida que el estudiante tenga completados los cursos requisito |
| fn_Procentaje_Comision | Obtiene la comisión del instructor principal o la base de la categoría |
| usp_InscribirEstudiante | Inscribe al estudiante, descuenta la billetera y registra el cobro |
| usp_EmitirCertificado | Emite el certificado con correlativo anual sin huecos y detecta finalizaciones sospechosas |
| usp_RegistrarAvanceModulo | Registra un módulo completado y emite el certificado al llegar al 100% si no hay evaluación |
| usp_RegistrarIntentoEvaluacion | Registra un intento (máximo 3) y emite el certificado al aprobar con 70 o más |
| vw_HistorialProgreso | Muestra el porcentaje de avance de cada inscripción |
| UX_Inscripcion_Activa | Índice que impide dos inscripciones activas del mismo estudiante en el mismo curso |

## Notas para ejecutar las pruebas

- Restaurar los datos antes de cada sección de pruebas. Las pruebas modifican los datos y los resultados esperados dependen del estado inicial. Antes de cada sección se deben volver a ejecutar 03_EduGT_Datos_Prueba.sql y 05_Datos_Prueba_Fase3.sql.
- Pruebas de concurrencia. Necesitan dos pestañas de consulta en SSMS conectadas a EduGT. Se ejecuta el bloque de la Ventana 1 y, antes de que pasen 10 segundos, el bloque de la Ventana 2. La Ventana 2 se queda esperando hasta que la Ventana 1 termina, y eso demuestra que el bloqueo funciona.
- Si aparece el error IDENTITY_INSERT is already ON al correr los scripts de datos, es porque un intento anterior falló a la mitad. Basta con cerrar la pestaña, abrir el script de nuevo y volver a ejecutarlo.

## Integrantes

- Axel Guillermo Alvarado Taracena - 1284724
- Diego Andrés Diaz Estupiñan - 1214024
- María Ínes Leiva Casiano - 1089524
- Javier Alessandro Rivera Lemus - 1241224
- Jennifer Fernanda Turcios Estrada - 1088724
