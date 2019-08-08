CREATE PROCEDURE [ERP].[Usp_Upd_Planilla]
@ID INT,
@IdEmpresa INT,
@Nombre VARCHAR(250),
@Codigo VARCHAR(20),
@IdTipoPlanilla INT,
@Dia INT,
@FlagDiaMes BIT,
@UsuarioModifico varchar(250),
@FechaModificado datetime,
@FlagBorrador bit,
@Flag bit
AS
BEGIN
	
	DECLARE @EXISTE INT = (SELECT COUNT(*) FROM [Maestro].[Planilla] WHERE LTRIM(RTRIM(Nombre)) = LTRIM(RTRIM(@Nombre)) AND IdEmpresa = @IdEmpresa AND ID != @ID)

	IF(@EXISTE = 0)
	BEGIN
		UPDATE [Maestro].[Planilla] SET 
			[Nombre] = @Nombre,
			[Codigo] = @Codigo,
			[IdTipoPlanilla] = (CASE @IdTipoPlanilla WHEN 0 THEN NULL ELSE @IdTipoPlanilla END),
			[Dia] = @Dia,
			[FlagDiaMes] = @FlagDiaMes,
			[UsuarioModifico] = @UsuarioModifico,
			[FechaModificado] = @FechaModificado,
			[FlagBorrador] = @FlagBorrador,
			[Flag] = @Flag
		WHERE ID = @ID
		SELECT @ID;
	END
	ELSE
	BEGIN
		SELECT -1;
	END
END
