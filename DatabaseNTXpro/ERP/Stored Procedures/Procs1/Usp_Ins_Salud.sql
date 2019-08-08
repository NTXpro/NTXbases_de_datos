CREATE PROC [ERP].[Usp_Ins_Salud]
@IdSalud INT OUT,
@IdDatoLaboral INT,
@IdEmpresa INT,
@IdRegimenSalud INT,
@IdPrestadoraDeSalud INT,
@FechaInicio DATETIME
AS
BEGIN
	DECLARE @FECHA_INICIO_LABORAL DATETIME = (SELECT FechaInicio FROM ERP.DatoLaboral WHERE ID = @IdDatoLaboral);

	IF(@FechaInicio >= @FECHA_INICIO_LABORAL)
	BEGIN
		DECLARE @LAST_ID INT = (SELECT TOP 1 ID FROM ERP.DatoLaboralSalud
			WHERE IdEmpresa = @IdEmpresa AND IdDatoLaboral = @IdDatoLaboral
			ORDER BY ID DESC);

		INSERT INTO ERP.DatoLaboralSalud(
			IdDatoLaboral,
			IdEmpresa,
			IdRegimenSalud,
			IdEntidadPrestadoraDeSalud,
			FechaInicio)
		VALUES(
			@IdDatoLaboral,
			@IdEmpresa,
			@IdRegimenSalud,
			IIF(@IdPrestadoraDeSalud = 0, NULL, @IdPrestadoraDeSalud),
			@FechaInicio)

		SET @IdSalud = SCOPE_IDENTITY();
	
		UPDATE ERP.DatoLaboralSalud SET
		FechaFin = DATEADD(DAY, -1, @FechaInicio)
		WHERE ID = @LAST_ID;

		SELECT @IdSalud
	END
	ELSE
	BEGIN
		SET @IdSalud = -1;
		SELECT @IdSalud;
	END
END
