
create PROC [ERP].[Usp_Ins_DatoLaboralSuspension]
@IdSuspension INT OUT,
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

			INSERT INTO ERP.DatoLaboralSuspension(
										IdDatoLaboral,
										IdEmpresa,
										IdTipoSuspension,
										CITT,
										FechaInicio,
										FechaFin
									)
									VALUES(
											@IdDatoLaboral,
											@IdEmpresa,
											@IdTipoSuspension,
											@CITT,
											@FechaInicio,
											@FechaFin
											)
				SET @IdSuspension = SCOPE_IDENTITY();

				SELECT @IdSuspension
	END
	ELSE
	BEGIN
		SET @IdSuspension = -1;
		SELECT @IdSuspension;
	END
END
