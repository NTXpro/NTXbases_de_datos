CREATE PROCEDURE [Maestro].[Usp_Upd_Origen]
@ID INT,
@Abreviatura varchar(10),
@Nombre varchar(255),
@UsuarioModifico varchar(250),
@FechaModificado datetime,
@FlagOrigenAutomatico bit,
@FlagSistema bit,
@FlagBorrador bit,
@Flag bit
AS
BEGIN
	DECLARE @EXISTE INT = (SELECT COUNT(*) FROM [Maestro].[Origen] WHERE LTRIM(RTRIM(Nombre)) = LTRIM(RTRIM(@Nombre)) AND ID != @ID)
	DECLARE @EXISTE_ABREVIATURA INT = (SELECT COUNT(*) FROM [Maestro].[Origen] WHERE LTRIM(RTRIM(Abreviatura)) = LTRIM(RTRIM(@Abreviatura)) AND ID != @ID)

	IF(@EXISTE = 0)
	BEGIN
		IF(@EXISTE_ABREVIATURA = 0)
		BEGIN
			UPDATE [Maestro].[Origen] SET 
				[Abreviatura] = @Abreviatura,
				[Nombre] = @Nombre,
				[UsuarioModifico] = @UsuarioModifico,
				[FechaModificado] = @FechaModificado,
				[FlagOrigenAutomatico] = @FlagOrigenAutomatico,
				[FlagSistema] = @FlagSistema,
				[FlagBorrador] = @FlagBorrador,
				[Flag] = @Flag
			WHERE ID = @ID
			SELECT @ID;
		END
		ELSE
		BEGIN
			SELECT -2;
		END
	END
	ELSE
	BEGIN
		SELECT -1;
	END
END