-- ////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////          MODULOS         ///////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////


-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 1 - Sistema @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     1.1 Mantenimiento de usuarios @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         1.1.1 Crear usuarios @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-----------------------------------------------------------
-- Autor: Daniela Mora Barquero
-- Date: 05/26/2022
-- Description: Create a new user in the system 
-- The stored procedure is using transactions to keep data consistency since two dependent inserts are happening at the same time
DROP PROCEDURE IF EXISTS [dbo].[sp_insertar_responsable];
GO

CREATE PROCEDURE [dbo].[sp_insertar_responsable] @p_cedula varchar(20),
@p_nombre varchar(20),
@p_ape1 varchar(15),
@p_ape2 varchar(15),
@p_direccion varchar(100),
@p_tipo int,
@p_usu_ag varchar(20),
@p_usuario varchar(150),
@p_password varchar(150)
AS
BEGIN
  SET XACT_ABORT ON;

  BEGIN TRY
    BEGIN TRANSACTION;
      INSERT INTO [dbo].[tb_responsables] (cedula, nombre, ape1, ape2, direccion, tipo, usu_ag, fecha_ag, estado)
        VALUES (@p_cedula, @p_nombre, @p_ape1, @p_ape2, @p_direccion, @p_tipo, @p_usu_ag, CURRENT_TIMESTAMP, 1)

      INSERT INTO [dbo].[tb_seguridad]
        VALUES (@p_cedula, @p_usuario, @p_password, 1)

    COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH
    IF (XACT_STATE()) = -1
    BEGIN
      ROLLBACK TRANSACTION;


      DECLARE @ERROR_SEVERITY int,
              @ERROR_STATE int,
              @ERROR_NUMBER int,
              @ERROR_LINE int,
              @ERROR_MESSAGE nvarchar(4000);

      SELECT
        @ERROR_SEVERITY = ERROR_SEVERITY(),
        @ERROR_STATE = ERROR_STATE(),
        @ERROR_NUMBER = ERROR_NUMBER(),
        @ERROR_LINE = ERROR_LINE(),
        @ERROR_MESSAGE = ERROR_MESSAGE();

      RAISERROR ('Msg %d, Line %d, :%s', @ERROR_SEVERITY, @ERROR_STATE, @ERROR_NUMBER, @ERROR_LINE, @ERROR_MESSAGE);
      RETURN -1

    END;

    IF (XACT_STATE()) = 1
    BEGIN
      COMMIT TRANSACTION;
    END;
  END CATCH;
  RETURN 0
END
GO

EXEC [dbo].[sp_insertar_responsable] '114130273', 'Daniela', 'Mora', 'Barquero', 'Heredia', 1, '114130273', "daniela.mora", "Dnlmora98";
GO


-----------------------------------------------------------
-- Autor: Daniela Mora Barquero
-- Date: 05/26/2022
-- Description: Validate to avoid duplicate information
-- The stored procedure validate if a user is duplicated checking their id and username
-----------------------------------------------------------
DROP PROCEDURE IF EXISTS [dbo].[sp_validar_usuarios_duplicados];
GO

CREATE PROCEDURE [dbo].[sp_validar_usuarios_duplicados] @p_usuario varchar(150),
@p_cedula varchar(20)
AS
  SELECT
    [dbo].[tb_responsables].[cedula],
    [dbo].[tb_seguridad].[usuario]
  FROM [dbo].[tb_responsables]
  INNER JOIN [dbo].[tb_seguridad]
    ON [dbo].[tb_seguridad].[cedula] = [dbo].[tb_responsables].[cedula]
  WHERE [dbo].[tb_responsables].[cedula] = @p_cedula
  OR [dbo].[tb_seguridad].[usuario] = @p_usuario
GO

-- EXEC [dbo].[sp_validar_usuarios_duplicados] 'usuario', 'cedula';
-- GO

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         1.1.2 Actualizar usuarios @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-----------------------------------------------------------
-- Autor: Daniela Mora Barquero
-- Date: 05/26/2022
-- Description: Update User
-- The stored procedure update a user
-----------------------------------------------------------
DROP PROCEDURE IF EXISTS [dbo].[sp_actualizar_responsable];
GO

CREATE PROCEDURE [dbo].[sp_actualizar_responsable] @p_cedula varchar(20),
@p_nombre varchar(20),
@p_ape1 varchar(15),
@p_ape2 varchar(15),
@p_direccion varchar(100),
@p_tipo int,
@p_usu_edi varchar(20)
AS
  UPDATE [dbo].[tb_responsables]
  SET nombre = @p_nombre,
      ape1 = @p_ape1,
      ape2 = @p_ape2,
      direccion = @p_direccion,
      tipo = @p_tipo,
      usu_edi = @p_usu_edi,
      fecha_edi = CURRENT_TIMESTAMP
  WHERE [dbo].[tb_responsables].[cedula] = @p_cedula

  IF (@@ROWCOUNT > 0)
    RETURN 0
  ELSE
    RETURN -1
GO

-- EXEC [dbo].[sp_actualizar_responsable] 'cedula', 'nombre', 'apellido1', 'apellido2', 'direccion', 1, 'usuario edita';
-- GO

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         1.1.3 Eliminar usuarios @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-----------------------------------------------------------
-- Autor: Daniela Mora Barquero
-- Date: 05/26/2022
-- Description: Delete user
-- The stored procedure delete a user
-----------------------------------------------------------
DROP PROCEDURE IF EXISTS [dbo].[sp_eliminar_usuario];
GO

CREATE PROCEDURE [dbo].[sp_eliminar_usuario] @p_cedula varchar(20), @usu_bor varchar(20)
AS
BEGIN
  SET XACT_ABORT ON;

  BEGIN TRY
    BEGIN TRANSACTION;
      UPDATE [dbo].[tb_seguridad]
      SET estado = 0
      WHERE [dbo].[tb_seguridad].[cedula] = @p_cedula

      UPDATE [dbo].[tb_responsables]
      SET estado = 0,
          usu_bor = @usu_bor,
          fecha_bor = CURRENT_TIMESTAMP
      WHERE [dbo].[tb_responsables].[cedula] = @p_cedula;

    COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH
    IF (XACT_STATE()) = -1
    BEGIN
      ROLLBACK TRANSACTION;


      DECLARE @ERROR_SEVERITY int,
              @ERROR_STATE int,
              @ERROR_NUMBER int,
              @ERROR_LINE int,
              @ERROR_MESSAGE nvarchar(4000);

      SELECT
        @ERROR_SEVERITY = ERROR_SEVERITY(),
        @ERROR_STATE = ERROR_STATE(),
        @ERROR_NUMBER = ERROR_NUMBER(),
        @ERROR_LINE = ERROR_LINE(),
        @ERROR_MESSAGE = ERROR_MESSAGE();

      RAISERROR ('Msg %d, Line %d, :%s', @ERROR_SEVERITY, @ERROR_STATE, @ERROR_NUMBER, @ERROR_LINE, @ERROR_MESSAGE);
      RETURN -1

    END;

    IF (XACT_STATE()) = 1
    BEGIN
      COMMIT TRANSACTION;
    END;
  END CATCH;
  RETURN 0
END
GO


-- EXEC [dbo].[sp_eliminar_usuario] 'cedula', 'cedula_editor';
-- GO

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         1.1.4 Buscar usuarios @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-----------------------------------------------------------
-- Autor: Daniela Mora Barquero
-- Date: 05/26/2022
-- Description: Search users by filter
-- The stored procedure search users by filters
-----------------------------------------------------------
DROP PROCEDURE IF EXISTS [dbo].[sp_buscar_usuarios];
GO

CREATE PROCEDURE [dbo].[sp_buscar_usuarios] @p_filtro varchar(50), @p_valor varchar(50)
AS
  SELECT
    [dbo].[tb_responsables].[cedula],
    [dbo].[tb_responsables].[nombre],
    [dbo].[tb_responsables].[ape1],
    [dbo].[tb_responsables].[ape2],
    [dbo].[tb_responsables].[direccion],
    [dbo].[tb_responsables].[tipo],
    [dbo].[tb_seguridad].[pass]
  FROM [dbo].[tb_responsables]
  INNER JOIN [dbo].[tb_seguridad]
    ON [dbo].[tb_responsables].[cedula] = [dbo].[tb_seguridad].[cedula]
  WHERE [dbo].[tb_responsables].[estado] = 1
  AND [dbo].[tb_seguridad].[estado] = 1
  AND (
  (@p_filtro = 'cedula0'
  AND [dbo].[tb_responsables].[cedula] LIKE '%' + @p_valor + '%')
  OR (@p_filtro = 'nombre'
  AND [dbo].[tb_responsables].[nombre] LIKE CONCAT('%', @p_valor, '%'))
  OR (@p_filtro = 'direccion'
  AND [dbo].[tb_responsables].[direccion] LIKE CONCAT('%', @p_valor, '%'))
  OR @p_valor = ''
  )
GO

EXEC [dbo].[sp_buscar_usuarios] 'filtro', 'valor';
GO

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     1.2 Login @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-----------------------------------------------------------
-- Autor: Daniela Mora Barquero
-- Date: 05/26/2022
-- Description: Validate a user in the system by username and password
-- The stored procedure is used to verify the user information when a user wants to log in
-----------------------------------------------------------
DROP PROCEDURE IF EXISTS [dbo].[sp_validar_usuario];
GO

CREATE PROCEDURE [dbo].[sp_validar_usuario] @p_usuario varchar(150)
AS
  SELECT
    [dbo].[tb_responsables].[cedula],
    [dbo].[tb_responsables].[nombre],
    [dbo].[tb_responsables].[ape1],
    [dbo].[tb_responsables].[ape2],
    [dbo].[tb_responsables].[tipo],
    [dbo].[tb_seguridad].[pass]
  FROM [dbo].[tb_responsables]
  INNER JOIN [dbo].[tb_seguridad]
    ON [dbo].[tb_seguridad].[usuario] = @p_usuario
  WHERE [dbo].[tb_responsables].[cedula] = [dbo].[tb_seguridad].[cedula]
  AND [dbo].[tb_responsables].[estado] = 1
  AND [dbo].[tb_seguridad].[estado] = 1
GO


-- EXEC [dbo].[sp_validar_usuario] 'usuario';
-- GO

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     1.3 Cambiar contraseña @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-----------------------------------------------------------
-- Autor: Daniela Mora Barquero
-- Date: 05/26/2022
-- Description: Update password
-- The stored procedure update the user password
-----------------------------------------------------------
DROP PROCEDURE IF EXISTS [dbo].[sp_actualizar_password];
GO

CREATE PROCEDURE [dbo].[sp_actualizar_password] @p_cedula varchar(20),
@p_password varchar(150)
AS
  UPDATE [dbo].[tb_seguridad]
  SET pass = @p_password
  WHERE [dbo].[tb_seguridad].[cedula] = @p_cedula

  IF (@@ROWCOUNT > 0)
    RETURN 0
  ELSE
    RETURN -1
GO

-- EXEC [dbo].[sp_actualizar_password] 'cedula', 'password';
-- GO

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     1.4 Cerrar sesión @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     1.5 Salir @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 2 - Plataforma @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     2.1 Realizar declaración (No funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     2.2 Exoneración @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- ///////////////////////////////////////////////////////////////
-- /////////////////////////  INSERT INTO  ///////////////////////
-- ///////////////////////////////////////////////////////////////

-----------------------------------------------------------
-- Autor: Daniela Mora Barquero
-- Date: 05/26/2022
-- Description: Save exonera
-- The stored procedure save exonera
-----------------------------------------------------------
DROP PROCEDURE IF EXISTS [dbo].[sp_guardar_exonera];
GO

CREATE PROCEDURE [dbo].[sp_guardar_exonera] @p_gis varchar(20),
@p_nombre varchar(50),
@p_cedula varchar(20),
@p_telefono varchar(20),
@p_responsable varchar(20),
@p_medio varchar(50)
AS
  DECLARE @v_consecutivo bigint

  SET @v_consecutivo = (SELECT
    ISNULL(MAX(consecutivo), 0) + 1
  FROM [dbo].[tb_consecutivo])

  INSERT INTO [dbo].[tb_exonera]
    VALUES (@v_consecutivo, CURRENT_TIMESTAMP, @p_gis, @p_nombre, @p_cedula, @p_telefono, @p_responsable, @p_medio)

  INSERT INTO [dbo].[tb_consecutivo]
    VALUES (@v_consecutivo)

  INSERT INTO [dbo].[tb_tiempos] (boleta, cedula, fecha, hora, tiempo, tipo)
    VALUES (@v_consecutivo, @p_responsable, CURRENT_TIMESTAMP, FORMAT(CURRENT_TIMESTAMP,'hh:mm:ss tt'), '0', 'Formulario para la exoneración de impuestos')
GO

-- EXEC [dbo].[sp_guardar_exonera] 'gis', 'nombre', '2222', 'telefono', '2222', 'medio';
-- GO


-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     2.3 Tramites municipales @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-----------------------------------------------------------
-- Autor: Daniela Mora Barquero
-- Date: 05/26/2022
-- Description: Save exonera
-- The stored procedure save exonera
-----------------------------------------------------------
DROP PROCEDURE IF EXISTS [dbo].[sp_guardar_urbano1];
GO

CREATE PROCEDURE [dbo].[sp_guardar_urbano1] @p_uso_suelo varchar(1),
@p_uso_suelo_mod varchar(1),
@p_ubicacion varchar(1),
@p_catastro varchar(1),
@p_municipal varchar(1),
@p_denuncia varchar(1),
@p_nombre varchar(100),
@p_cedula varchar(30),
@p_telefono varchar(30),
@p_fax varchar(30),
@p_distrito varchar(50),
@p_direccion varchar(250),
@p_responsable varchar(20),
@p_medio varchar(150),
@p_quejas_ambientales varchar(1),
@p_quejas varchar(1),
@p_dispo_agua varchar(1),
@p_txt_denuncia varchar(50),
@p_correspondencia varchar(1),
@p_txt_correspondencia varchar(50),
@p_otros varchar(1),
@p_txt_otros varchar(100),
@p_tram_pat varchar(1),
@p_solic_pat varchar(1),
@p_solic_pat_lic varchar(1),
@p_solic_t_t_c_nom varchar(1),
@p_ren_pat varchar(1)
AS
  DECLARE @v_consecutivo bigint

  SET @v_consecutivo = (SELECT
    ISNULL(MAX(consecutivo), 0) + 1
  FROM [dbo].[tb_consecutivo])

  INSERT INTO [dbo].[tb_urbano1] (boleta, uso_suelo, uso_suelo_mod, ubicacion, catastro, municipal, denuncia, nombre, cedula, tel, fax, distrito, direccion, estado, responsable, fecha, medio, quejas_ambientales,
  quejas, dispo_agua, txt_denuncia, correspondencia, txt_correspondencia, otros, txt_otros, tram_pat, solic_pat, solic_pat_lic, solic_t_t_c_nom, ren_pat)
    VALUES (@v_consecutivo, @p_uso_suelo, @p_uso_suelo_mod, @p_ubicacion, @p_catastro, @p_municipal, @p_denuncia, @p_nombre, @p_cedula, @p_telefono, @p_fax, @p_distrito, @p_direccion, '1', @p_responsable, CURRENT_TIMESTAMP, @p_medio, @p_quejas_ambientales, @p_quejas, @p_dispo_agua, @p_txt_denuncia, @p_correspondencia, @p_txt_correspondencia, @p_otros, @p_txt_otros, @p_tram_pat, @p_solic_pat, @p_solic_pat_lic, @p_solic_t_t_c_nom, @p_ren_pat)

  INSERT INTO [dbo].[tb_consecutivo]
    VALUES (@v_consecutivo)

  INSERT INTO [dbo].[tb_tiempos] (boleta, cedula, fecha, hora, tiempo, tipo)
    VALUES (@v_consecutivo, @p_responsable, CURRENT_TIMESTAMP, FORMAT(CURRENT_TIMESTAMP, 'hh:mm:ss tt'), '0', 'Formulario de Tramites Municipales')
GO

-- EXEC [dbo].[sp_guardar_urbano1]  'X', 'X', 'X', 'X', 'X', 'X', 'nombre', 'cedula', 'telefono', 'fax', 'distrito', 'direccion', 'responsable', 'medio', 'X', 'X', 'X', 'txt_denuncia', 'X', 'txt_correspondencia', 'X', 'txt_otros', 'X', 'X', 'X', 'X', 'X';
-- GO


-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     2.4 Formulario de patentes (No funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     2.5 Consulta de planos (No funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 3 - Servicios @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     3.1 Formulario pago de Servicios @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-----------------------------------------------------------
-- Autor: Daniela Mora Barquero
-- Date: 05/26/2022
-- Description: Save exonera
-- The stored procedure save exonera
-----------------------------------------------------------
DROP PROCEDURE IF EXISTS [dbo].[sp_guardar_pago_serv];
GO

CREATE PROCEDURE [dbo].[sp_guardar_pago_serv] 
@p_cedula varchar(20),
@p_gis varchar(20),
@p_nuev_serv varchar(1),
@p_inst_agua varchar(1),
@p_residen varchar(1),
@p_comer varchar(1),
@p_gob varchar(1),
@p_responsable varchar(20),
@p_nombre varchar(50),
@p_medio varchar(50)
AS
  DECLARE @v_consecutivo bigint

  SET @v_consecutivo = (SELECT
    ISNULL(MAX(consecutivo), 0) + 1
  FROM [dbo].[tb_consecutivo])

  INSERT INTO [dbo].[tb_pago_serv] (num_boleta, cedula, gis, nuev_serv, inst_agua, residen, comer, gob, tipo_comer, brind_aseo_via, espacio, brind_mant_parq,
  ml, responsable, fecha, nombre, medio, ced_rec, nom_rec)
    VALUES (@v_consecutivo, @p_cedula, @p_gis, @p_nuev_serv, @p_inst_agua, @p_residen, @p_comer, @p_gob, '', '', '', '', '', @p_responsable, CURRENT_TIMESTAMP, @p_nombre, @p_medio, '', '')

  INSERT INTO [dbo].[tb_consecutivo]
    VALUES (@v_consecutivo)

  INSERT INTO [dbo].[tb_tiempos] (boleta, cedula, fecha, hora, tiempo, tipo)
    VALUES (@v_consecutivo, @p_responsable, CURRENT_TIMESTAMP, FORMAT(CURRENT_TIMESTAMP, 'hh:mm:ss tt'), '0', 'Formulario para la exoneración de impuestos')
GO

EXEC [dbo].[sp_guardar_pago_serv]  'cedula', 'gis', 'X', 'X', 'X', 'X', 'X', 'responsable', 'nombre', 'medio';
GO


            

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     3.2 Denuncias y quejas @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         3.2.1 Registrar el Tramites @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-----------------------------------------------------------
-- Autor: Daniela Mora Barquero
-- Date: 05/26/2022
-- Description: Save exonera
-- The stored procedure save exonera
-----------------------------------------------------------
DROP PROCEDURE IF EXISTS [dbo].[sp_guardar_quejas];
GO

CREATE PROCEDURE [dbo].[sp_guardar_quejas] 
@p_cedula varchar(20),
@p_gis varchar(20),
@p_denuncia varchar(1000),
@p_resolucion varchar(1000),
@p_observaciones varchar(1000),
@p_responsable varchar(20),
@p_nombre varchar(50),
@p_medio varchar(50),
@p_finca varchar(20),
@p_derecho varchar(20)
AS
  DECLARE @v_consecutivo bigint

  SET @v_consecutivo = (SELECT
    ISNULL(MAX(consecutivo), 0) + 1
  FROM [dbo].[tb_consecutivo])

  INSERT INTO [dbo].[tb_quejas] (boleta, cedula, gis, denuncia, resolucion, observaciones, recibe, fecha, nombre, medio, finca, derecho)
    VALUES (@v_consecutivo, @p_cedula, @p_gis, @p_denuncia, @p_resolucion, @p_observaciones, @p_responsable, CURRENT_TIMESTAMP, @p_nombre, @p_medio, @p_finca, @p_derecho)

  INSERT INTO [dbo].[tb_consecutivo]
    VALUES (@v_consecutivo)

  INSERT INTO [dbo].[tb_tiempos] (boleta, cedula, fecha, hora, tiempo, tipo)
    VALUES (@v_consecutivo, @p_responsable, CURRENT_TIMESTAMP, FORMAT(CURRENT_TIMESTAMP, 'hh:mm:ss tt'), '0', 'Formulario para quejas o denuncias')
GO

-- EXEC [dbo].[sp_guardar_quejas]  'cedula', 'gis', 'denuncia', 'resolucion', 'observaciones', 'responsable', 'nombre', 'medio', 'finca', 'derecho';
-- GO



            




-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         3.2.2 Imprimir la boleta (No funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     3.3 Denuncias o quejas ambientales @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         3.3.1 Registrar el Tramites @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         3.3.2 Imprimir la boleta (No funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     3.4 Tramites de acueducto @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         3.4.1 Reinstalación de medidor @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         3.4.2 Revisión de medidor @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         3.4.3 Cambio de medidor @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     3.5 Solicitud disponibilidad de agua @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     3.6 Solicitud disponibilidad de agua - Fraccionamientos - Urbanizaciones @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     3.7 Boleta de traspaso de servicios @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     3.8 Requisitos de licencias (Modulo no funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         3.8.1 Ley 7600 (No funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         3.8.2 Ley de licores (No funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         3.8.3 declaración jurada de patentes (No funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         3.8.4 traspaso - Cambio - traslado (No funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         3.8.5 patente comercial (No funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         3.8.6 Renuncia (No funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 4 - Construcción @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     4.1 Requisitos obras generales (No funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     4.2 Requisitos Demoliciones y movimientos de tierra (No funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     4.3 Requisitos publicidad exterior (No funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     4.4 Requisitos Obras menores o de mantenimiento @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         4.4.1 Registrar el tramite @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         4.4.2 Imprimir boleta (No funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     4.5 Solicitud de visado municipal de planos de catastro @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         4.5.1 Registrar el tramite @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         4.5.2 Imprimir boleta (No funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     4.6 Solicitud de certificación de uso de suelo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         4.6.1 Registrar el tramite @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         4.6.2 Imprimir boleta (No funciona) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 5 - Administración @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     5.1 Tiempos de atención @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     5.2 Seguimiento @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         5.2.1 Buscar @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         5.2.2 Guardar @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     5.3 Tramites @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         5.3.1 Buscar @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         5.3.1 Guardar @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         5.3.1 Actualizar @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         5.3.1 Eliminar @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 6 - Acerca @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     6.1 Acerca de @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


