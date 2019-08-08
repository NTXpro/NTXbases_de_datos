CREATE PROC [ERP].[Usp_Upd_Salud]
@IdSalud INT,
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
								WHERE IdEmpresa = @IdEmpresa AND IdDatoLaboral = @IdDatoLaboral AND ID != @IdSalud
								ORDER BY ID DESC);

		UPDATE ERP.DatoLaboralSalud SET 
		IdRegimenSalud = @IdRegimenSalud,
		IdEntidadPrestadoraDeSalud = IIF(@IdPrestadoraDeSalud = 0, NULL, @IdPrestadoraDeSalud),
		FechaInicio = @FechaInicio
		WHERE ID = @IdSalud

		UPDATE ERP.DatoLaboralSalud SET
		FechaFin = DATEADD(DAY, -1, @FechaInicio)
		WHERE ID = @LAST_ID;

		SELECT @IdSalud;
	END
	ELSE
	BEGIN
		SELECT -1;
	END
END
