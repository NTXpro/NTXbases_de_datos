CREATE PROC [Maestro].[Usp_Ins_Origen]
@Abreviatura varchar(10),
@Nombre varchar(255),
@UsuarioRegistro varchar(250),
@FechaRegistro datetime,
@FlagOrigenAutomatico bit,
@FlagSistema bit,
@FlagBorrador bit,
@Flag bit
AS
BEGIN

	DECLARE @EXISTE INT = (SELECT COUNT(*) FROM [Maestro].[Origen] WHERE LTRIM(RTRIM(Nombre)) = LTRIM(RTRIM(@Nombre)))
	DECLARE @EXISTE_ABREVIATURA INT = (SELECT COUNT(*) FROM [Maestro].[Origen] WHERE LTRIM(RTRIM(Abreviatura)) = LTRIM(RTRIM(@Abreviatura)))

	IF(@EXISTE = 0)
	BEGIN

		IF(@EXISTE_ABREVIATURA = 0)
		BEGIN
			INSERT INTO [Maestro].[Origen]
			   ([Abreviatura]
			   ,[Nombre]
			   ,[UsuarioRegistro]
			   ,[FechaRegistro]
			   ,[FlagOrigenAutomatico]
			   ,[FlagSistema]
			   ,[FlagBorrador]
			   ,[Flag])
			VALUES
			   (@Abreviatura,
				@Nombre,
				@UsuarioRegistro,
				@FechaRegistro,
				@FlagOrigenAutomatico,
				@FlagSistema,
				@FlagBorrador,
				@Flag)
			SELECT CAST(SCOPE_IDENTITY() AS int)
		END
		ELSE
		BEGIN
			SELECT -2
		END
	END
	ELSE
	BEGIN
		SELECT -1
	END
END