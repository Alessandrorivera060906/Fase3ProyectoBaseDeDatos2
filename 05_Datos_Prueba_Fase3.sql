/*
============================================================
EDUGT - DATOS DE PRUEBA ESPECIFICOS PARA FASE 3
Inscripcion, progreso, evaluacion y certificados
============================================================

IMPORTANTE:
1. Primero ejecutar el DDL entregado en Fase 2.
2. Luego ejecutar 03_EduGT_Datos_Prueba.sql de Fase 2.
3. Despues ejecutar ESTE archivo.

Este archivo NO reemplaza el DML de Fase 2.
Solo agrega escenarios comunes para que todo el grupo pueda
desarrollar y probar Fase 3 con los mismos IDs.

Si ya se hicieron pruebas y quieren volver al estado inicial:
- ejecutar otra vez el DML completo de Fase 2;
- luego ejecutar otra vez este archivo.

============================================================
*/

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- ============================================================
    -- 0. VALIDAR QUE SE EJECUTO PRIMERO EL DML BASE DE FASE 2
    -- ============================================================

    IF NOT EXISTS (SELECT 1 FROM USUARIO WHERE UsuarioID = 12)
       OR NOT EXISTS (SELECT 1 FROM CURSO WHERE CursoID = 7)
       OR NOT EXISTS (SELECT 1 FROM INSCRIPCION WHERE InscripcionID = 9)
    BEGIN
        THROW 52000, 'Primero debe ejecutar el DML base entregado en Fase 2.', 1;
    END;

    IF EXISTS (SELECT 1 FROM CURSO WHERE CursoID IN (8, 9, 10))
       OR EXISTS (SELECT 1 FROM USUARIO WHERE UsuarioID BETWEEN 13 AND 18)
    BEGIN
        THROW 52001, 'Los datos de Fase 3 ya existen. Reejecute primero el DML base de Fase 2 para reiniciar.', 1;
    END;


    -- ============================================================
    -- 1. ESTUDIANTES ADICIONALES
    --
    -- 13 = tiene requisito aprobado y saldo suficiente
    -- 14 = saldo suficiente, pero NO tiene requisito aprobado
    -- 15 = saldo insuficiente
    -- 16 = misma billetera para prueba de dos compras simultaneas
    -- 17 y 18 = competencia por el ultimo cupo
    -- ============================================================

    SET IDENTITY_INSERT USUARIO ON;

    INSERT INTO USUARIO
        (UsuarioID, Nombre, Apellido, Correo, FechaRegistro, TipoUsuario)
    VALUES
    (13, N'Paula', N'Vasquez', 'paula@gmail.com', '2026-09-01T09:00:00', 'ESTUDIANTE'),
    (14, N'Mario', N'Juarez', 'mario@gmail.com', '2026-09-02T09:00:00', 'ESTUDIANTE'),
    (15, N'Elena', N'Flores', 'elena@gmail.com', '2026-09-03T09:00:00', 'ESTUDIANTE'),
    (16, N'Gabriela', N'Ortiz', 'gabriela@gmail.com', '2026-09-04T09:00:00', 'ESTUDIANTE'),
    (17, N'Ricardo', N'Soto', 'ricardo@gmail.com', '2026-09-05T09:00:00', 'ESTUDIANTE'),
    (18, N'Valeria', N'Campos', 'valeria@gmail.com', '2026-09-06T09:00:00', 'ESTUDIANTE');

    SET IDENTITY_INSERT USUARIO OFF;


    -- ============================================================
    -- 2. BILLETERAS ADICIONALES
    --
    -- Usuario 16 tiene Q350:
    -- Curso 9 cuesta Q200 y Curso 10 cuesta Q250.
    -- Cada compra individual es posible, pero ambas juntas no.
    -- ============================================================

    SET IDENTITY_INSERT BILLETERA ON;

    INSERT INTO BILLETERA
        (BilleteraID, UsuarioID, Saldo, FechaActualizacion)
    VALUES
    (10, 13, 750.00, '2026-10-01T08:00:00'),
    (11, 14, 1000.00, '2026-10-01T08:00:00'),
    (12, 15, 30.00, '2026-10-01T08:00:00'),
    (13, 16, 350.00, '2026-10-01T08:00:00'),
    (14, 17, 1000.00, '2026-10-01T08:00:00'),
    (15, 18, 1000.00, '2026-10-01T08:00:00');

    SET IDENTITY_INSERT BILLETERA OFF;


    -- ============================================================
    -- 3. CURSOS PARA FASE 3
    --
    -- Curso 8:
    -- DISPONIBLE, requiere evaluacion, requisito Curso 1.
    -- Instructor principal 2, quien tiene comision especial 18%.
    --
    -- Curso 9:
    -- DISPONIBLE, NO requiere evaluacion, sin requisito.
    -- Instructor principal 1, usa comision base de categoria (25%).
    -- Tiene cohortes para probar cupo.
    --
    -- Curso 10:
    -- DISPONIBLE, requiere evaluacion, sin requisito.
    -- Instructor principal 3, usa comision base de categoria (25%).
    -- ============================================================

    SET IDENTITY_INSERT CURSO ON;

    INSERT INTO CURSO
    (
        CursoID, CodigoCurso, Descripcion, CategoriaID, Precio,
        ImagenPortada, Estado, FechaCreacion, FechaPublicacion,
        Destacado, RequiereEval, Titulo
    )
    VALUES
    (8, 'EDU-2026-0008',
     N'Integracion de aplicaciones Node.js con SQL Server y consultas parametrizadas.',
     1, 300.00, '/img/node-sql.jpg', 'DISPONIBLE',
     '2026-09-10T09:00:00', '2026-09-15T10:00:00',
     0, 1, N'Node.js con SQL Server'),

    (9, 'EDU-2026-0009',
     N'Control de versiones con Git y trabajo colaborativo con repositorios.',
     1, 200.00, '/img/git.jpg', 'DISPONIBLE',
     '2026-09-12T09:00:00', '2026-09-18T10:00:00',
     0, 0, N'Git y GitHub desde Cero'),

    (10, 'EDU-2026-0010',
     N'Fundamentos de seguridad para aplicaciones web y buenas practicas.',
     1, 250.00, '/img/seguridad-web.jpg', 'DISPONIBLE',
     '2026-09-14T09:00:00', '2026-09-20T10:00:00',
     0, 1, N'Seguridad Web');

    SET IDENTITY_INSERT CURSO OFF;


    -- ============================================================
    -- 4. EQUIPOS DE CURSO
    -- ============================================================

    INSERT INTO EQUIPOCURSO
        (CursoID, InstructorID, PorcentajeParticipacion, EsPrincipal)
    VALUES
    (8, 2, 100.00, 1),
    (9, 1, 100.00, 1),
    (10, 3, 100.00, 1);


    -- ============================================================
    -- 5. REQUISITO DEL CURSO 8
    -- ============================================================

    INSERT INTO CURSOREQUISITO (CursoID, CursoRequisitoID)
    VALUES (8, 1);


    -- ============================================================
    -- 6. MODULOS DE LOS CURSOS DE FASE 3
    -- Curso 8  -> 21, 22, 23
    -- Curso 9  -> 24, 25, 26
    -- Curso 10 -> 27, 28, 29
    -- ============================================================

    SET IDENTITY_INSERT MODULO ON;

    INSERT INTO MODULO (ModuloID, CursoID, NombreModulo, NoOrden)
    VALUES
    (21, 8, N'Conexion de Node.js con SQL Server', 1),
    (22, 8, N'Consultas y parametros', 2),
    (23, 8, N'API y persistencia', 3),

    (24, 9, N'Fundamentos de Git', 1),
    (25, 9, N'Ramas y cambios', 2),
    (26, 9, N'Trabajo colaborativo', 3),

    (27, 10, N'Principios de seguridad web', 1),
    (28, 10, N'Autenticacion y autorizacion', 2),
    (29, 10, N'Proteccion de datos', 3);

    SET IDENTITY_INSERT MODULO OFF;


    -- ============================================================
    -- 7. LECCIONES
    --
    -- Duracion total aproximada:
    -- Curso 8  = 135 minutos
    -- Curso 9  = 105 minutos
    -- Curso 10 = 160 minutos
    --
    -- Estos tiempos sirven para la regla de finalizacion sospechosa.
    -- ============================================================

    SET IDENTITY_INSERT LECCION ON;

    INSERT INTO LECCION
        (LeccionID, ModuloID, NombreLeccion, Contenido, NoOrden, DuracionMinutos)
    VALUES
    (24, 21, N'Configuracion de mssql',
     N'Conexion de Node.js con SQL Server utilizando una configuracion segura.', 1, 40),

    (25, 22, N'Consultas parametrizadas',
     N'Uso de parametros para ejecutar consultas y evitar concatenacion insegura.', 1, 45),

    (26, 23, N'Persistencia desde una API',
     N'Lectura y escritura de datos desde servicios REST.', 1, 50),

    (27, 24, N'Repositorios y commits',
     N'Conceptos basicos de repositorios, commits y seguimiento de cambios.', 1, 30),

    (28, 25, N'Ramas',
     N'Creacion, cambio y combinacion de ramas de trabajo.', 1, 35),

    (29, 26, N'Pull requests',
     N'Flujo de colaboracion y revision de cambios.', 1, 40),

    (30, 27, N'Riesgos comunes',
     N'Principales riesgos en aplicaciones web y formas de mitigarlos.', 1, 50),

    (31, 28, N'Control de acceso',
     N'Autenticacion, autorizacion y manejo de sesiones.', 1, 50),

    (32, 29, N'Proteccion de informacion',
     N'Buenas practicas para proteger datos sensibles en una aplicacion.', 1, 60);

    SET IDENTITY_INSERT LECCION OFF;


    -- ============================================================
    -- 8. COHORTES
    --
    -- Cohorte 4 = vacia, cupo 1.
    --              Se usa para la prueba simultanea del ULTIMO CUPO.
    --
    -- Cohorte 5 = cupo 1 y quedara ocupada por InscripcionID 10.
    --              Se usa para probar el error "cohorte llena".
    -- ============================================================

    SET IDENTITY_INSERT COHORTE ON;

    INSERT INTO COHORTE (CohorteID, CursoID, FechaInicio, CupoMax)
    VALUES
    (4, 9, '2026-10-20', 1),
    (5, 9, '2026-10-25', 1);

    SET IDENTITY_INSERT COHORTE OFF;


    -- ============================================================
    -- 9. INSCRIPCIONES PREPARADAS PARA QUE CADA PERSONA
    --    PUEDA TRABAJAR SIN ESPERAR A LOS DEMAS
    --
    -- 10 = progreso: ACTIVA, Curso 9, sin avances.
    --      Ademas llena la Cohorte 5.
    --
    -- 11 = certificado con evaluacion: 100% + nota aprobada.
    -- 12 = evaluacion: tiene 2 intentos reprobados.
    -- 13 = certificado sin evaluacion: 100% en Curso 9.
    -- 14 = evaluacion automatica: 100%, sin intentos aun.
    -- 15 = certificado debe fallar: progreso incompleto.
    -- 16 = certificado debe fallar: evaluacion reprobada.
    -- 17 = certificado sospechoso: Curso 9 terminado demasiado rapido.
    -- 18 = requisito aprobado para Usuario 13.
    --
    -- NOTA:
    -- Las inscripciones 10-17 son fixtures directos para que Personas
    -- 2, 3 y 4 puedan desarrollar sin depender de usp_InscribirEstudiante.
    -- ============================================================

    SET IDENTITY_INSERT INSCRIPCION ON;

    INSERT INTO INSCRIPCION
    (
        InscripcionID, UsuarioID, CursoID, CohorteID, PoliticaID,
        FechaInscripcion, PrecioPagado, PorcentajeComiAplicado,
        Estado, FechaCompletado, Liquidada
    )
    VALUES
    (10, 8, 9, 5, 2,
     '2026-10-01T09:00:00', 200.00, 25.00,
     'ACTIVA', NULL, 0),

    (11, 12, 8, NULL, 2,
     '2026-09-20T09:00:00', 300.00, 18.00,
     'ACTIVA', NULL, 0),

    (12, 10, 10, NULL, 2,
     '2026-09-20T09:00:00', 250.00, 25.00,
     'ACTIVA', NULL, 0),

    (13, 11, 9, NULL, 2,
     '2026-09-20T09:00:00', 200.00, 25.00,
     'ACTIVA', NULL, 0),

    (14, 9, 10, NULL, 2,
     '2026-09-20T09:00:00', 250.00, 25.00,
     'ACTIVA', NULL, 0),

    (15, 7, 10, NULL, 2,
     '2026-09-20T09:00:00', 250.00, 25.00,
     'ACTIVA', NULL, 0),

    (16, 12, 10, NULL, 2,
     '2026-09-20T09:00:00', 250.00, 25.00,
     'ACTIVA', NULL, 0),

    (17, 10, 9, NULL, 2,
     '2026-10-01T10:00:00', 200.00, 25.00,
     'ACTIVA', NULL, 0),

    (18, 13, 1, NULL, 2,
     '2026-08-15T09:00:00', 250.00, 25.00,
     'COMPLETADA', '2026-08-20T18:00:00', 0);

    SET IDENTITY_INSERT INSCRIPCION OFF;


    -- ============================================================
    -- 10. AVANCES PREPARADOS
    -- ============================================================

    INSERT INTO AVANCEMODULO
        (InscripcionID, ModuloID, FechaCompletado)
    VALUES
    -- Inscripcion 11: Curso 8, 100%
    (11, 21, '2026-09-23T18:00:00'),
    (11, 22, '2026-09-25T18:00:00'),
    (11, 23, '2026-09-27T18:00:00'),

    -- Inscripcion 12: Curso 10, 100%
    (12, 27, '2026-09-23T18:00:00'),
    (12, 28, '2026-09-25T18:00:00'),
    (12, 29, '2026-09-28T18:00:00'),

    -- Inscripcion 13: Curso 9, 100%
    (13, 24, '2026-09-23T18:00:00'),
    (13, 25, '2026-09-25T18:00:00'),
    (13, 26, '2026-09-27T18:00:00'),

    -- Inscripcion 14: Curso 10, 100%, aun sin evaluacion
    (14, 27, '2026-09-24T18:00:00'),
    (14, 28, '2026-09-27T18:00:00'),
    (14, 29, '2026-10-01T18:00:00'),

    -- Inscripcion 15: Curso 10, incompleta
    (15, 27, '2026-09-25T18:00:00'),

    -- Inscripcion 16: Curso 10, 100%, pero evaluacion reprobada
    (16, 27, '2026-09-23T18:00:00'),
    (16, 28, '2026-09-25T18:00:00'),
    (16, 29, '2026-09-28T18:00:00'),

    -- Inscripcion 17: Curso 9 completado en solo 15 minutos
    (17, 24, '2026-10-01T10:05:00'),
    (17, 25, '2026-10-01T10:10:00'),
    (17, 26, '2026-10-01T10:15:00'),

    -- Inscripcion 18: Curso 1 completado, sirve como requisito
    (18, 1, '2026-08-17T18:00:00'),
    (18, 2, '2026-08-19T18:00:00'),
    (18, 3, '2026-08-20T17:00:00');


    -- ============================================================
    -- 11. INTENTOS DE EVALUACION PREPARADOS
    -- ============================================================

    SET IDENTITY_INSERT INTENTOEVALUACION ON;

    INSERT INTO INTENTOEVALUACION
        (IntentoID, InscripcionID, NumeroIntento, Nota, FechaIntento)
    VALUES
    -- Inscripcion 11: ya aprobada, lista para emitir certificado
    (4, 11, 1, 85.00, '2026-09-27T18:30:00'),

    -- Inscripcion 12: ya gasto dos intentos y ambos fueron reprobados
    (5, 12, 1, 55.00, '2026-09-29T18:00:00'),
    (6, 12, 2, 65.00, '2026-09-30T18:00:00'),

    -- Inscripcion 16: progreso completo, pero no ha aprobado
    (7, 16, 1, 60.00, '2026-09-29T18:00:00'),

    -- Inscripcion 18: evaluacion aprobada del curso requisito
    (8, 18, 1, 80.00, '2026-08-20T17:30:00');

    SET IDENTITY_INSERT INTENTOEVALUACION OFF;


    -- ============================================================
    -- 12. CERTIFICADO DEL REQUISITO DEL USUARIO 13
    --
    -- Los certificados 1, 2 y 3 ya vienen de Fase 2.
    -- Se agrega el 4 para que el siguiente correlativo de las
    -- pruebas de Fase 3 deba comenzar en 5.
    -- ============================================================

    INSERT INTO CERTIFICADO
        (Anio, Correlativo, InscripcionID, CodigoCertificado,
         FechaEmision, Estado, MotivoRevision)
    VALUES
    (2026, 4, 18, 'CERT-2026-0004',
     '2026-08-20T18:05:00', 'VALIDO', NULL);


    COMMIT TRANSACTION;

    PRINT 'Datos especificos de Fase 3 cargados correctamente.';

END TRY
BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;

END CATCH;
GO


-- ============================================================
-- 13. CONSULTAS RAPIDAS DE VERIFICACION
-- ============================================================

SELECT * FROM USUARIO WHERE UsuarioID BETWEEN 13 AND 18;
SELECT * FROM BILLETERA WHERE UsuarioID BETWEEN 13 AND 18;
SELECT * FROM CURSO WHERE CursoID BETWEEN 8 AND 10;
SELECT * FROM COHORTE WHERE CohorteID IN (4, 5);
SELECT * FROM INSCRIPCION WHERE InscripcionID BETWEEN 10 AND 18;
SELECT * FROM AVANCEMODULO WHERE InscripcionID BETWEEN 10 AND 18;
SELECT * FROM INTENTOEVALUACION WHERE InscripcionID BETWEEN 10 AND 18;
SELECT * FROM CERTIFICADO WHERE InscripcionID = 18;
GO


/*
============================================================
MAPA RAPIDO DE CASOS DE PRUEBAx|
============================================================

PERSONA 1 - INSCRIPCION

Usuario 13 + Curso 8
    Requisito Curso 1 COMPLETADO.
    Saldo suficiente.
    Debe poder inscribirse.
    Comision esperada: 18% porque Instructor 2 tiene comision especial.

Usuario 14 + Curso 8
    NO tiene Curso 1 completado.
    Debe fallar por requisito previo.

Usuario 15 + Curso 9
    Saldo Q30 y curso cuesta Q200.
    Debe fallar por saldo insuficiente.

Usuario 8 + Curso 9
    Ya tiene InscripcionID 10 ACTIVA.
    Debe fallar por inscripcion activa duplicada.

Curso 3
    Estado PENDIENTE.
    Debe fallar por curso no disponible.

Cohorte 4
    Curso 9, cupo 1, inicialmente VACIA.
    Usuarios 17 y 18 pueden competir por el ultimo cupo.

Cohorte 5
    Curso 9, cupo 1, ya ocupada por InscripcionID 10.
    Debe fallar por cohorte llena.

Usuario 16
    Saldo Q350.
    Curso 9 cuesta Q200 y Curso 10 cuesta Q250.
    Dos inscripciones simultaneas no pueden dejar saldo negativo.


PERSONA 2 - PROGRESO

InscripcionID 10
    ACTIVA, Curso 9, sin avances.
    Modulos correctos: 24, 25 y 26.
    Modulo de otro curso para error: 27.
    Ideal para prueba de dos sesiones sobre el mismo modulo.


PERSONA 3 - EVALUACION

InscripcionID 12
    Curso 10 requiere evaluacion.
    Ya tiene intentos 1 y 2 reprobados.
    Sirve para tercer intento y rechazo del cuarto.

InscripcionID 14
    Curso 10 requiere evaluacion.
    Tiene 100% de progreso y no tiene intentos.
    Una nota >= 70 debe permitir la emision automatica del certificado.

InscripcionID 10
    Curso 9 NO requiere evaluacion.
    Debe rechazarse un intento de evaluacion.


PERSONA 4 - CERTIFICADOS

InscripcionID 11
    100% de progreso + evaluacion aprobada.
    Debe emitir certificado VALIDO.

InscripcionID 13
    100% de progreso y curso sin evaluacion.
    Debe emitir certificado VALIDO.

InscripcionID 15
    Progreso incompleto.
    Debe rechazar la emision.

InscripcionID 16
    100% de progreso, pero evaluacion reprobada.
    Debe rechazar la emision.

InscripcionID 17
    100% de progreso en solo 15 minutos.
    Debe generar certificado PENDIENTE_VERIFICACION segun la regla acordada.

Correlativo:
    Ya existen certificados 2026 con correlativos 1, 2, 3 y 4.
    El siguiente certificado del 2026 debe usar correlativo 5.


PERSONA 5 - CONCURRENCIA E INTEGRACION

Ultimo cupo:
    Usuario 17 vs Usuario 18, Curso 9, Cohorte 4.

Misma billetera:
    Usuario 16 intenta simultaneamente Curso 9 y Curso 10.

Mismo modulo:
    Dos sesiones registran Modulo 24 para InscripcionID 10.

Siguiente intento:
    Usar una inscripcion restaurada al estado base y ejecutar
    dos sesiones al mismo tiempo.

Certificados:
    InscripcionID 11 e InscripcionID 13 son dos candidatos
    elegibles para emitir certificados simultaneamente.

============================================================
*/