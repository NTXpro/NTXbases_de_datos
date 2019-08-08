CREATE PROCEDURE [ERP].[Usp_Ins_Ubicacion]
@Codigo varchar(20),
@Nombre varchar(100),
@IdAlmacen int,
@UsuarioRegistro varchar(250),
@FechaRegistro datetime,
@FlagBorrador bit,
@Flag bit
AS
BEGIN

	DECLARE @CODIGO_EXISTENTE INT = (SELECT COUNT(*) FROM ERP.Ubicacion 
									 WHERE 
									 Codigo = @Codigo AND
									 IdAlmacen = @IdAlmacen AND
									 FlagBorrador = 0)
	IF(@CODIGO_EXISTENTE = 0)
	BEGIN
		INSERT INTO [ERP].[Ubicacion]
           ([Codigo]
           ,[Nombre]
           ,[IdAlmacen]
           ,[UsuarioRegistro]
           ,[FechaRegistro]
           ,[FlagBorrador]
           ,[Flag])
		VALUES
           (@Codigo,
            @Nombre,
			CASE @IdAlmacen
			  WHEN 0 THEN NULL   
			  ELSE @IdAlmacen   
			END,
            @UsuarioRegistro,
            @FechaRegistro,
            @FlagBorrador,
            @Flag)
		SELECT CAST(SCOPE_IDENTITY() AS int)
	END
	ELSE
	BEGIN
		SELECT -1
	END
END

