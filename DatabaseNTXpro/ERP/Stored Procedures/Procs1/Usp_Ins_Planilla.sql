CREATE PROC [ERP].[Usp_Ins_Planilla]
@IdEmpresa INT,
@Nombre VARCHAR(250),
@Codigo VARCHAR(20),
@IdTipoPlanilla INT,
@Dia INT,
@FlagDiaMes BIT,
@UsuarioRegistro varchar(250),
@FechaRegistro datetime,
@FlagBorrador bit,
@Flag bit
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000

	DECLARE @EXISTE INT = (SELECT COUNT(*) FROM [Maestro].[Planilla] WHERE LTRIM(RTRIM(Nombre)) = LTRIM(RTRIM(@Nombre)) AND IdEmpresa = @IdEmpresa)
	DECLARE @ID_PLANILLLA INT;

	IF(@EXISTE = 0)
	BEGIN
		INSERT INTO [Maestro].[Planilla]
			   ([Nombre]
			   ,[Codigo]
			   ,[IdTipoPlanilla]
			   ,[IdEmpresa]
			   ,[Dia]
			   ,[FlagDiaMes]
			   ,[UsuarioRegistro]
			   ,[FechaRegistro]
			   ,[FlagBorrador]
			   ,[Flag])
		VALUES
			   (@Nombre,
			   @Codigo,
			   (CASE @IdTipoPlanilla WHEN 0 THEN NULL ELSE @IdTipoPlanilla END),
			   @IdEmpresa,
			   @Dia,
			   @FlagDiaMes,
			   @UsuarioRegistro,
			   @FechaRegistro,
			   @FlagBorrador,
			   @Flag)
		SELECT CAST(SCOPE_IDENTITY() AS INT)
	END
	ELSE
	BEGIN
		SELECT -1
	END
END
