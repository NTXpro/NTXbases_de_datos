
create PROC [ERP].[Usp_Upd_DatoLaboralSuspension]
@IdSuspension INT,
@IdDatoLaboral INT,
@IdEmpresa INT,
@IdTipoSuspension INT,
@CITT VARCHAR(20),
@FechaInicio DATETIME,
@FechaFin DATETIME
AS
BEGIN
	DECLARE @FECHA_INICIO_LABORAL DATETIME = (SELECT FechaInicio FROM ERP.DatoLaboral WHERE ID = @IdDatoLaboral);

	IF(@FechaInicio >= @FECHA_INICIO_LABORAL AND @FechaFin >= @FECHA_INICIO_LABORAL)
	BEGIN
			UPDATE ERP.DatoLaboralSuspension	SET	IdTipoSuspension = @IdTipoSuspension,
										CITT = @CITT,
										FechaInicio = @FechaInicio ,
										FechaFin = @FechaFin
									WHERE ID = @IdSuspension AND IdDatoLaboral = @IdDatoLaboral 
									AND IdEmpresa = @IdEmpresa
			SELECT @IdSuspension;
	END
	ELSE
	BEGIN
		SET @IdSuspension = -1;
		SELECT @IdSuspension;
	END
END
