-- ////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////       USERS MANAGE       ///////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     CREATE A NEW USER        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

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

-- EXEC [dbo].[sp_insertar_responsable] '114130273', 'Daniela', 'Mora', 'Barquero', 'Heredia', 1, '114130273', "daniela.mora", "Dnlmora98";
-- GO


-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     VALIDATE USER        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

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

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     VALIDATE DUPLICATE USERS        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

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
  (@p_filtro = 'cedula'
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