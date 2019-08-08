CREATE PROCEDURE [ERP].[Usp_Upd_Ubicacion]-- 1, '001', 'asd', 1, null, '12-12-12', 0, 1
@IdUbicacion INT,
@Codigo varchar(20),
@Nombre varchar(100),
@IdAlmacen int,
@UsuarioModifico varchar(250),
@FechaModificado datetime,
@FlagBorrador bit,
@Flag bit
AS
BEGIN
	DECLARE @CODIGO_EXISTENTE INT = (SELECT COUNT(*) FROM ERP.Ubicacion 
									 WHERE 
									 Codigo = @Codigo AND
									 IdAlmacen = @IdAlmacen AND
									 FlagBorrador = 0 AND
									 ID != @IdUbicacion)
	IF(@CODIGO_EXISTENTE = 0)
	BEGIN
		UPDATE [ERP].[Ubicacion] SET 
		   [Codigo] = @Codigo
		  ,[Nombre] = @Nombre
		  ,[IdAlmacen] = CASE @IdAlmacen
			  WHEN 0 THEN NULL   
			  ELSE @IdAlmacen   
			END
		  ,[UsuarioModifico] = @UsuarioModifico
		  ,[FechaModificado] = @FechaModificado
		  ,[FlagBorrador] = @FlagBorrador
		  ,[Flag] = @Flag
		WHERE ID = @IdUbicacion
		SELECT @IdUbicacion;
	END
	ELSE
	BEGIN
		SELECT -1
	END
END

