-----------------------------------------------------------
-- Autor: template
-- Fecha: 12/12/0000
-- Descripcion: dsklfjlksdjflksdjflksdjflksd
-- Otros detalles de los parametros
-----------------------------------------------------------
CREATE PROCEDURE [dbo].[XXXXXXSP_VerboEntidad] @Param1 nvarchar(35),
@Param2 bigint
AS
BEGIN

  -- SET XACT_ABORT ON will render the transaction uncommittable  
  -- when the constraint violation occurs.  
  SET XACT_ABORT ON;

  BEGIN TRY
    BEGIN TRANSACTION;
      -- A FOREIGN KEY constraint exists on this table. This   
      -- statement will generate a constraint violation error.  
      DELETE FROM Production.Product
      WHERE ProductID = 980;

    -- If the delete operation succeeds, commit the transaction. The CATCH  
    -- block will not execute.  
    COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH
    -- Test XACT_STATE for 0, 1, or -1.  
    -- If 1, the transaction is committable.  
    -- If -1, the transaction is uncommittable and should   
    --     be rolled back.  
    -- XACT_STATE = 0 means there is no transaction and  
    --     a commit or rollback operation would generate an error.  

    -- Test whether the transaction is uncommittable.  
    IF (XACT_STATE()) = -1
    BEGIN
      PRINT 'The transaction is in an uncommittable state.' +
      ' Rolling back transaction.'
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

    -- Test whether the transaction is active and valid.  
    IF (XACT_STATE()) = 1
    BEGIN
      COMMIT TRANSACTION;
    END;
  END CATCH;
  RETURN 0
END
GO


-- Como buscar los procedures
-- 1 buscar por palabras claves como 
--   - insert into
--   - select
--   - update
-- 2 ordenarlo por el relative path de los files
-- 3 dentro de cada relative path poner el codigo de cada store procedure que se tiene que crear (En el paso 4 que sera realizado al final se va a cambiar el codigo por los stored procedure)
-- 4 creacion de los stored procedure (Esto es al final)
-- NOTA: hacer estas busquedas en visual studio code es muy facil lo recomiendo 
-- Ejemplo de como debe quedar

-- //////////////// INICIO DEL EJEMPLO ///////////////

-- Declaracion/Formularios/Form1.vb
-- ====== 1 ====== 
-- select max(consecutivo) from tb_consecutivo 
-- ====== 2 ====== 
-- insert into tb_consecutivo values( " & num_boletaDOC & " )"

-- Declaracion/Formularios/frm_agua_frac_urba.vb
-- ====== 1 ====== 
-- select max(consecutivo) from tb_consecutivo
-- ====== 2 ====== 
-- "insert into tb_consecutivo values( " & num_boletaDOC & " )"
-- ====== 3 ====== 
-- cadena.CommandText = " INSERT INTO [dbo].[tb_agua_frac_urba] "
-- cadena.CommandText += " ([boleta],[plano],[literal],[fot_ced],[desc_proy],[croquis],[n_pajas],[cedula],[nombre],[gis],[folio],[num_plano],[direccion],[resid],[comer],[medio],[fecha],[responsable]) "
-- cadena.CommandText += " VALUES( " & num_boletaDOC & ", '" & reporte.asignar(Me.chk1_plano) & "' , '" & reporte.asignar(chk2_literal) & "' , '"
-- cadena.CommandText += reporte.asignar(chk3_fot_ced) & "' , '" & reporte.asignar(Me.chk4_des_proy) & "' , '" & reporte.asignar(Me.Chk5_croquis) & "','" & Me.txt_n_pajas.Text & "','" & Me.txt_cedula.Text & "' , '" & Me.txt_nombre.Text & "' , '"
-- cadena.CommandText += Me.txt_GIS.Text & "', '" & Me.txt_folio.Text & "','" & Me.txt_plano.Text & "' ,'" & Me.txt_dir.Text & "' ,'" & reporte.asignar(Me.chk_residen) & "' ,'" & reporte.asignar(Me.chk_comer) & "' ,'" & Me.txt_medio.Text & "' , CURRENT_TIMESTAMP,'" & ID_USUARIO & "')"

-- ////////////////   FIN DEL EJEMPLO  ///////////////




-- Declaracion/Base Datos/cla_areas_proteccion.vb
-- TABLE: tb_areas_proteccion

DROP PROCEDURE IF EXISTS dbo.spr_obtener_areas_proteccion_por_boleta;
GO

CREATE PROCEDURE dbo.spr_obtener_areas_proteccion_por_boleta @p_boleta bigint
AS
  SELECT
    dbo.tb_areas_proteccion.boleta,
    dbo.tb_areas_proteccion.nombre,
    dbo.tb_areas_proteccion.cedula,
    dbo.tb_areas_proteccion.nombre_legal,
    dbo.tb_areas_proteccion.cedula_legal,
    dbo.tb_areas_proteccion.telefono,
    dbo.tb_areas_proteccion.nombre_esp,
    dbo.tb_areas_proteccion.cedula_esp,
    dbo.tb_areas_proteccion.telefono_esp,
    dbo.tb_areas_proteccion.direccion,
    dbo.tb_areas_proteccion.num_plano,
    dbo.tb_areas_proteccion.gis,
    dbo.tb_areas_proteccion.finca,
    dbo.tb_areas_proteccion.distrito,
    ISNULL(dbo.tb_responsables.nombre, ' ') + ' ' + ISNULL(dbo.tb_responsables.ape1, ' ') + ' ' + ISNULL(dbo.tb_responsables.ape2, ' ') AS Responsable,
    dbo.tb_areas_proteccion.fecha
  FROM dbo.tb_areas_proteccion
  INNER JOIN dbo.tb_responsables
    ON dbo.tb_areas_proteccion.responsable = dbo.tb_responsables.cedula
  WHERE dbo.tb_areas_proteccion.boleta = @p_boleta;
GO

EXEC dbo.spr_obtener_areas_proteccion_por_boleta 10;
GO

-- Declaracion/Base Datos/cla_obras_menores_o_mantenimiento.vb
-- TABLE: tb_obras_menores_o_mantenimiento

DROP PROCEDURE IF EXISTS dbo.spr_obtener_obras_menores_o_mantenimiento_por_boleta;
GO

CREATE PROCEDURE dbo.spr_obtener_obras_menores_o_mantenimiento_por_boleta @p_boleta bigint
AS
  SELECT
    dbo.tb_obras_menores_o_mantenimiento.boleta,
    dbo.tb_obras_menores_o_mantenimiento.distrito,
    dbo.tb_obras_menores_o_mantenimiento.localidad,
    dbo.tb_obras_menores_o_mantenimiento.n_plano,
    dbo.tb_obras_menores_o_mantenimiento.direccion,
    dbo.tb_obras_menores_o_mantenimiento.nombre_propietario,
    dbo.tb_obras_menores_o_mantenimiento.cedula_propietario,
    dbo.tb_obras_menores_o_mantenimiento.nombre_sol,
    dbo.tb_obras_menores_o_mantenimiento.cedula_sol,
    dbo.tb_obras_menores_o_mantenimiento.telefono_sol,
    dbo.tb_obras_menores_o_mantenimiento.medio,
    dbo.tb_obras_menores_o_mantenimiento.gis_dia,
    dbo.tb_obras_menores_o_mantenimiento.n_finca_dia,
    dbo.tb_obras_menores_o_mantenimiento.distrito_dia,
    dbo.tb_obras_menores_o_mantenimiento.servicios_dia,
    dbo.tb_obras_menores_o_mantenimiento.bienes_dia,
    dbo.tb_obras_menores_o_mantenimiento.no_contribuye_dia,
    dbo.tb_obras_menores_o_mantenimiento.croquis,
    dbo.tb_obras_menores_o_mantenimiento.plano,
    ISNULL(dbo.tb_responsables.nombre, ' ') + ' ' + ISNULL(dbo.tb_responsables.ape1, ' ') + ' ' + ISNULL(dbo.tb_responsables.ape2, ' ') AS Nombre,
    dbo.tb_obras_menores_o_mantenimiento.fecha
  FROM dbo.tb_obras_menores_o_mantenimiento
  INNER JOIN dbo.tb_responsables
    ON dbo.tb_obras_menores_o_mantenimiento.responsable = dbo.tb_responsables.cedula
  WHERE dbo.tb_obras_menores_o_mantenimiento.boleta = @p_boleta;
GO

EXEC dbo.spr_obtener_obras_menores_o_mantenimiento_por_boleta 10;
GO

-- Declaracion/Base Datos/cla_quejas_ambiental.vb
-- TABLE: tb_queja_ambiental
DROP PROCEDURE IF EXISTS dbo.spr_obtener_queja_ambiental_por_boleta;
GO

CREATE PROCEDURE dbo.spr_obtener_queja_ambiental_por_boleta @p_boleta bigint
AS
  SELECT
    dbo.tb_queja_ambiental.boleta,
    dbo.tb_queja_ambiental.fecha,
    dbo.tb_queja_ambiental.propietario,
    dbo.tb_queja_ambiental.cedula_prop,
    dbo.tb_queja_ambiental.nombre_soli,
    dbo.tb_queja_ambiental.cedula_soli,
    dbo.tb_queja_ambiental.direccion,
    dbo.tb_queja_ambiental.gis,
    dbo.tb_queja_ambiental.tel_fax,
    dbo.tb_queja_ambiental.correo,
    dbo.tb_queja_ambiental.distrito,
    dbo.tb_queja_ambiental.servicio,
    dbo.tb_queja_ambiental.queja,
    dbo.tb_queja_ambiental.anonino,
    dbo.tb_queja_ambiental.copia,
    ISNULL(dbo.tb_responsables.nombre, ' ') + ' ' + ISNULL(dbo.tb_responsables.ape1, ' ') + ' ' + ISNULL(dbo.tb_responsables.ape2, ' ') AS Nombre
  FROM dbo.tb_queja_ambiental
  INNER JOIN dbo.tb_responsables
    ON dbo.tb_queja_ambiental.responsable = dbo.tb_responsables.cedula
  WHERE dbo.tb_queja_ambiental.boleta = @p_boleta;
GO

EXEC dbo.spr_obtener_queja_ambiental_por_boleta 10;
GO


-- Declaracion/Base Datos/cla_tramite.vb
-- TABLA: tb_urbano1
DROP PROCEDURE IF EXISTS dbo.spr_obtener_urbano1_por_boleta;
GO

CREATE PROCEDURE dbo.spr_obtener_urbano1_por_boleta @p_boleta bigint
AS
  SELECT
    dbo.tb_urbano1.boleta,
    dbo.tb_urbano1.uso_suelo,
    dbo.tb_urbano1.uso_suelo_mod,
    dbo.tb_urbano1.ubicacion,
    dbo.tb_urbano1.catastro,
    dbo.tb_urbano1.municipal,
    dbo.tb_urbano1.denuncia,
    dbo.tb_urbano1.nombre,
    dbo.tb_urbano1.cedula,
    dbo.tb_urbano1.tel,
    dbo.tb_urbano1.fax,
    dbo.tb_urbano1.distrito,
    dbo.tb_urbano1.direccion,
    dbo.tb_urbano1.estado,
    dbo.tb_urbano1.fecha,
    dbo.tb_urbano1.medio,
    dbo.tb_urbano1.quejas_ambientales,
    dbo.tb_urbano1.quejas,
    dbo.tb_urbano1.dispo_agua,
    dbo.tb_urbano1.mov_tierra,
    dbo.tb_urbano1.txt_denuncia,
    dbo.tb_urbano1.correspondencia,
    dbo.tb_urbano1.txt_correspondencia,
    dbo.tb_urbano1.otros,
    dbo.tb_urbano1.txt_otros,
    dbo.tb_urbano1.usu_suelo_pat,
    dbo.tb_urbano1.tram_pat,
    dbo.tb_urbano1.solic_pat,
    dbo.tb_urbano1.solic_pat_lic,
    dbo.tb_urbano1.solic_t_t_c_nom,
    dbo.tb_urbano1.ren_pat,
    ISNULL(dbo.tb_responsables.nombre, ' ') + ' ' + ISNULL(dbo.tb_responsables.ape1, ' ')
    + ' ' + ISNULL(dbo.tb_responsables.ape2, ' ') AS Nombre1
  FROM dbo.tb_urbano1
  INNER JOIN dbo.tb_responsables
    ON dbo.tb_urbano1.responsable = dbo.tb_responsables.cedula
  WHERE dbo.tb_urbano1.boleta = @p_boleta;
GO

EXEC dbo.spr_obtener_urbano1_por_boleta 10;
GO


-- Declaracion/Base Datos/cla_uso_amiental.vb
-- TABLE: tb_uso_ambiental
DROP PROCEDURE IF EXISTS dbo.spr_obtener_uso_ambiental_por_boleta;
GO

CREATE PROCEDURE dbo.spr_obtener_uso_ambiental_por_boleta @p_boleta bigint
AS
  SELECT
    dbo.tb_uso_ambiental.boleta,
    dbo.tb_uso_ambiental.obra_nueva,
    dbo.tb_uso_ambiental.ampliacion_remodelacion,
    dbo.tb_uso_ambiental.patente,
    dbo.tb_uso_ambiental.renov_patente,
    dbo.tb_uso_ambiental.informacion,
    dbo.tb_uso_ambiental.unifamiliar,
    dbo.tb_uso_ambiental.apartamentos,
    dbo.tb_uso_ambiental.condominio,
    dbo.tb_uso_ambiental.urbanizacion,
    dbo.tb_uso_ambiental.area_constru,
    dbo.tb_uso_ambiental.movi_suelo,
    dbo.tb_uso_ambiental.niveles,
    dbo.tb_uso_ambiental.acti_economica,
    dbo.tb_uso_ambiental.industrial,
    dbo.tb_uso_ambiental.avicola,
    dbo.tb_uso_ambiental.porcina,
    dbo.tb_uso_ambiental.otra,
    dbo.tb_uso_ambiental.otra_texto,
    dbo.tb_uso_ambiental.otros_usos,
    dbo.tb_uso_ambiental.uso_actual,
    dbo.tb_uso_ambiental.lote_vacio,
    dbo.tb_uso_ambiental.distrito_prop,
    dbo.tb_uso_ambiental.localidad_prop,
    dbo.tb_uso_ambiental.nu_plano_prop,
    dbo.tb_uso_ambiental.direccion_prop,
    dbo.tb_uso_ambiental.propietario,
    dbo.tb_uso_ambiental.cedula_prop,
    dbo.tb_uso_ambiental.nombre_soli,
    dbo.tb_uso_ambiental.cedula_soli,
    dbo.tb_uso_ambiental.telefono_soli,
    dbo.tb_uso_ambiental.gis,
    dbo.tb_uso_ambiental.finca,
    dbo.tb_uso_ambiental.distrito,
    dbo.tb_uso_ambiental.servicios,
    dbo.tb_uso_ambiental.bienes_inmuebles,
    dbo.tb_uso_ambiental.no_contribuye,
    dbo.tb_uso_ambiental.copias_plano,
    dbo.tb_uso_ambiental.timbre,
    dbo.tb_uso_ambiental.eval_ambiental,
    ISNULL(dbo.tb_responsables.nombre, ' ') + ' ' + ISNULL(dbo.tb_responsables.ape1, ' ') + ' ' + ISNULL(dbo.tb_responsables.ape2, ' ') AS Nombre,
    dbo.tb_uso_ambiental.fecha
  FROM dbo.tb_uso_ambiental
  INNER JOIN dbo.tb_responsables
    ON dbo.tb_uso_ambiental.responsable = dbo.tb_responsables.cedula
  WHERE dbo.tb_uso_ambiental.boleta = @p_boleta;
GO

EXEC dbo.spr_obtener_uso_ambiental_por_boleta 10;
GO


-- Declaracion/Base Datos/cla_uso_suelo.vb
-- TABLE: tb_uso_suelo
DROP PROCEDURE IF EXISTS dbo.spr_obtener_uso_suelo_por_boleta;
GO

CREATE PROCEDURE dbo.spr_obtener_uso_suelo_por_boleta @p_boleta bigint
AS
  SELECT
    dbo.tb_uso_suelo.boleta,
    dbo.tb_uso_suelo.obra_nueva,
    dbo.tb_uso_suelo.ampli_remod,
    dbo.tb_uso_suelo.patente,
    dbo.tb_uso_suelo.renov_patente,
    dbo.tb_uso_suelo.informacion,
    dbo.tb_uso_suelo.tram_prime_vez,
    dbo.tb_uso_suelo.renovacion,
    dbo.tb_uso_suelo.vivien_inifam,
    dbo.tb_uso_suelo.apartamentos,
    dbo.tb_uso_suelo.condominio,
    dbo.tb_uso_suelo.urbanizacion,
    dbo.tb_uso_suelo.comercial,
    dbo.tb_uso_suelo.industrial,
    dbo.tb_uso_suelo.avicola,
    dbo.tb_uso_suelo.porcina,
    dbo.tb_uso_suelo.otra,
    dbo.tb_uso_suelo.otros_usos,
    dbo.tb_uso_suelo.uso_actual,
    dbo.tb_uso_suelo.lote_vacio,
    dbo.tb_uso_suelo.area_constru,
    dbo.tb_uso_suelo.mov_suelo,
    dbo.tb_uso_suelo.altura_edifi,
    dbo.tb_uso_suelo.distrito,
    dbo.tb_uso_suelo.localidad,
    dbo.tb_uso_suelo.n_plano,
    dbo.tb_uso_suelo.direccion,
    dbo.tb_uso_suelo.nombre_propietario,
    dbo.tb_uso_suelo.cedula_propietario,
    dbo.tb_uso_suelo.nombre_sol,
    dbo.tb_uso_suelo.cedula_sol,
    dbo.tb_uso_suelo.telefono_sol,
    dbo.tb_uso_suelo.medio_plat,
    dbo.tb_uso_suelo.medio,
    dbo.tb_uso_suelo.gis_dia,
    dbo.tb_uso_suelo.n_finca_dia,
    dbo.tb_uso_suelo.distrito_dia,
    dbo.tb_uso_suelo.servicios_dia,
    dbo.tb_uso_suelo.bienes_dia,
    dbo.tb_uso_suelo.no_contribuye_dia,
    dbo.tb_uso_suelo.copia_plano,
    dbo.tb_uso_suelo.pago_cert_uso_suelo,
    dbo.tb_uso_suelo.eval_amb,
    ISNULL(dbo.tb_responsables.nombre, ' ') + ' ' + ISNULL(dbo.tb_responsables.ape1, ' ') + ' ' + ISNULL(dbo.tb_responsables.ape2, ' ') AS Nombre,
    dbo.tb_uso_suelo.fecha
  FROM dbo.tb_uso_suelo
  INNER JOIN dbo.tb_responsables
    ON dbo.tb_uso_suelo.responsable = dbo.tb_responsables.cedula
  WHERE dbo.tb_uso_suelo.boleta = @p_boleta;
GO

EXEC dbo.spr_obtener_uso_suelo_por_boleta 10;
GO

-- Declaracion/Base Datos/cla_visado_plano_catastro.vb
-- TABLE: tb_visado_plano_catastro
DROP PROCEDURE IF EXISTS dbo.spr_obtener_visado_plano_catastro_por_boleta;
GO

CREATE PROCEDURE dbo.spr_obtener_visado_plano_catastro_por_boleta @p_boleta bigint
AS
  SELECT
    tb_visado_plano_catastro.boleta,
    tb_visado_plano_catastro.visado_pri_vez,
    tb_visado_plano_catastro.resello,
    tb_visado_plano_catastro.distrito,
    tb_visado_plano_catastro.localidad,
    tb_visado_plano_catastro.n_plano,
    tb_visado_plano_catastro.direccion,
    tb_visado_plano_catastro.nombre_propietario,
    tb_visado_plano_catastro.cedula_propietario,
    tb_visado_plano_catastro.nombre_sol,
    tb_visado_plano_catastro.cedula_sol,
    tb_visado_plano_catastro.telefono_sol,
    tb_visado_plano_catastro.medio,
    tb_visado_plano_catastro.gis_dia,
    tb_visado_plano_catastro.n_finca_dia,
    tb_visado_plano_catastro.distrito_dia,
    tb_visado_plano_catastro.servicios_dia,
    tb_visado_plano_catastro.bienes_dia,
    tb_visado_plano_catastro.no_contribuye_dia,
    tb_visado_plano_catastro.plano_original,
    tb_visado_plano_catastro.plano_copia,
    ISNULL(tb_responsables.nombre, ' ') + ' ' + ISNULL(tb_responsables.ape1, ' ') + ' ' + ISNULL(tb_responsables.ape2, ' ') AS Nombre,
    tb_visado_plano_catastro.fecha
  FROM tb_visado_plano_catastro
  INNER JOIN tb_responsables
    ON tb_visado_plano_catastro.responsable = tb_responsables.cedula
  WHERE tb_visado_plano_catastro.boleta = @p_boleta;
GO

EXEC dbo.spr_obtener_visado_plano_catastro_por_boleta 10;
GO



-- ///////////////////////////////////////////////////////////////
-- /////////////////////////  INSERT INTO  ///////////////////////
-- ///////////////////////////////////////////////////////////////
-- Declaracion/Formularios/frm_areas_proteccion.vb
-- TABLE: tb_areas_proteccion

DROP PROCEDURE IF EXISTS dbo.spr_insertar_areas_proteccion;
GO



CREATE PROCEDURE dbo.spr_insertar_areas_proteccion @p_responsable varchar(20),
@p_nombre varchar(50),
@p_cedula varchar(20),
@p_nombre_legal varchar(50),
@p_cedula_legal varchar(20),
@p_telefono varchar(20),
@p_nombre_esp varchar(50),
@p_cedula_esp varchar(20),
@p_telefono_esp varchar(20),
@p_direccion varchar(250),
@p_num_plano varchar(30),
@p_gis varchar(20),
@p_finca varchar(30),
@p_distrito varchar(30)
AS
  DECLARE @v_max_consecutivo bigint

  SET @v_max_consecutivo = (SELECT
    ISNULL(MAX(consecutivo), 0) + 1
  FROM tb_consecutivo)

  INSERT INTO dbo.tb_areas_proteccion (boleta,
  responsable,
  fecha,
  nombre,
  cedula,
  nombre_legal,
  cedula_legal,
  telefono,
  nombre_esp,
  cedula_esp,
  telefono_esp,
  direccion,
  num_plano,
  gis,
  finca,
  distrito,
  estado)
    VALUES (@v_max_consecutivo, @p_responsable, CURRENT_TIMESTAMP, @p_nombre, @p_cedula, @p_nombre_legal, @p_cedula_legal, @p_telefono, @p_nombre_esp, @p_cedula_esp, @p_telefono_esp, @p_direccion, @p_num_plano, @p_gis, @p_finca, @p_distrito, '1');

  IF (@@ROWCOUNT > 0)
  BEGIN
    INSERT INTO tb_consecutivo
      VALUES (@v_max_consecutivo)
  END
GO

EXEC dbo.spr_insertar_areas_proteccion 'cedula', 'nombre', 'cedula', 'nombre_legal', 'cedula_legal', 'telefono', 'nombre_esp', 'cedula_esp', 'telefono_esp', 'direccion', 'num_plano', 'gis', 'finca', 'distrito';
GO


-- Declaracion/Modulos/MantUsuarios.vb
-- TABLE: tb_responsables

-- DROP PROCEDURE IF EXISTS dbo.spr_insertar_responsables;
-- GO

-- CREATE PROCEDURE dbo.spr_insertar_responsables @p_cedula varchar(20),
-- @p_nombre varchar(20),
-- @p_ape1 varchar(15),
-- @p_ape2 varchar(15),
-- @p_direccion varchar(100),
-- @p_tipo int,
-- @p_usu_ag varchar(20)
-- AS
--   INSERT INTO tb_responsables (cedula, nombre, ape1, ape2, direccion, tipo, usu_ag, fecha_ag, estado)
--     VALUES (@p_cedula, @p_nombre, @p_ape1, @p_ape2, @p_direccion, @p_tipo, @p_usu_ag, CURRENT_TIMESTAMP, 1)
-- GO

-- EXEC dbo.spr_insertar_responsables 'cedula', 'nombre', 'ape1', 'ape2', 'direccion', 1, 'usu_ag';
-- GO

-- --------- update

DROP PROCEDURE IF EXISTS dbo.spr_actualizar_responsables;
GO

CREATE PROCEDURE dbo.spr_actualizar_responsables @p_cedula varchar(20),
@p_nombre varchar(20),
@p_ape1 varchar(15),
@p_ape2 varchar(15),
@p_direccion varchar(100),
@p_tipo int,
@p_usu_edi varchar(20)
AS
  UPDATE TB_responsables
  SET nombre = @p_nombre,
      ape1 = @p_ape1,
      ape2 = @p_ape2,
      direccion = @p_direccion,
      tipo = @p_tipo,
      usu_edi = @p_usu_edi,
      fecha_edi = CURRENT_TIMESTAMP
  WHERE cedula = @p_cedula;
GO

EXEC dbo.spr_actualizar_responsables 'cedula', 'nombre', 'ape1', 'ape2', 'direccion', 1, 'usu_edi';
GO

-- ----------- borrar
DROP PROCEDURE IF EXISTS dbo.spr_borrar_responsables;
GO

CREATE PROCEDURE dbo.spr_borrar_responsables @p_cedula varchar(20),
@p_usu_bor varchar(20)
AS
  UPDATE TB_responsables
  SET estado = 0,
      usu_bor = @p_usu_bor,
      fecha_bor = CURRENT_TIMESTAMP
  WHERE cedula = @p_cedula;
GO

EXEC dbo.spr_borrar_responsables 'cedula', 'usu_bor';
GO




-- ////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////       USERS MANAGE       ///////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     CREATE NEW USER        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-----------------------------------------------------------
-- Autor: Daniela Mora Barquero
-- Date: 05/26/2022
-- Description: Create a new user in the system 
-- The stored procedure is using transactions to keep data consistency since two dependent inserts are happening at the same time
-----------------------------------------------------------
DROP PROCEDURE IF EXISTS dbo.sp_insertar_responsable;
GO

CREATE PROCEDURE dbo.sp_insertar_responsable @p_cedula varchar(20),
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
      INSERT INTO dbo.tb_responsables (cedula, nombre, ape1, ape2, direccion, tipo, usu_ag, fecha_ag, estado)
        VALUES (@p_cedula, @p_nombre, @p_ape1, @p_ape2, @p_direccion, @p_tipo, @p_usu_ag, CURRENT_TIMESTAMP, 1)

      INSERT INTO dbo.tb_seguridad
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

-- EXEC dbo.sp_insertar_responsable '114130273', 'Daniela', 'Mora', 'Barquero', 'Heredia', 1, '114130273', "daniela.mora", "Dnlmora98";
-- GO


-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     VALIDATE USER        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-----------------------------------------------------------
-- Autor: Daniela Mora Barquero
-- Date: 05/26/2022
-- Description: Validate a user in the system by username and password
-- The stored procedure is used to verify the user information when a user wants to log in
-----------------------------------------------------------
DROP PROCEDURE IF EXISTS dbo.sp_validar_usuario;
GO

CREATE PROCEDURE dbo.sp_validar_usuario @p_usuario varchar(150)
AS
  SELECT
    dbo.tb_responsables.nombre,
    dbo.tb_responsables.ape1,
    dbo.tb_responsables.ape2,
    dbo.tb_responsables.tipo,
    dbo.tb_seguridad.pass
  FROM dbo.tb_responsables
  INNER JOIN dbo.tb_seguridad
    ON dbo.tb_seguridad.usuario = @p_usuario
  WHERE dbo.tb_responsables.cedula = dbo.tb_seguridad.cedula
  AND dbo.tb_responsables.estado = 1
  AND dbo.tb_seguridad.estado = 1
GO


-- EXEC dbo.sp_validar_usuario 'usuario';
-- GO

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     VALIDATE DUPLICATE USERS        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-----------------------------------------------------------
-- Autor: Daniela Mora Barquero
-- Date: 05/26/2022
-- Description: Validate to avoid duplicate information
-- The stored procedure validate if a user is duplicated checking their id and username
-----------------------------------------------------------
DROP PROCEDURE IF EXISTS dbo.sp_validar_usuarios_duplicados;
GO

CREATE PROCEDURE dbo.sp_validar_usuarios_duplicados @p_usuario varchar(150),
@p_cedula varchar(20)
AS
  SELECT
    dbo.tb_responsables.cedula,
    dbo.tb_seguridad.usuario
  FROM dbo.tb_responsables
  INNER JOIN dbo.tb_seguridad
    ON dbo.tb_seguridad.cedula = dbo.tb_responsables.cedula
  WHERE dbo.tb_responsables.cedula = @p_cedula
  OR dbo.tb_seguridad.usuario = @p_usuario
GO

-- EXEC dbo.sp_validar_usuarios_duplicados 'usuario', 'cedula';
-- GO