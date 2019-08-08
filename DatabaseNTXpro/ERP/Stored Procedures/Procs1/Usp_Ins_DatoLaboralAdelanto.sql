
CREATE PROC [ERP].[Usp_Ins_DatoLaboralAdelanto]
@IdAdelanto INT OUT,
@IdDatoLaboral INT,
@IdEmpresa INT,
@Fecha DATETIME,
@Motivo VARCHAR(250),
@Monto DECIMAL(14,5)
AS
BEGIN
	DECLARE @FECHA_INICIO_LABORAL DATETIME = (SELECT FechaInicio FROM ERP.DatoLaboral WHERE ID = @IdDatoLaboral);

	IF(@Fecha >= @FECHA_INICIO_LABORAL)
	BEGIN
			INSERT INTO ERP.DatoLaboralAdelanto(
										IdDatoLaboral,
										IdEmpresa,
										Fecha,
										Motivo,
										Monto,
										FlagCancelado
									)
									VALUES(
											@IdDatoLaboral,
											@IdEmpresa,
											@Fecha,
											@Motivo,
											@Monto,
											CAST(0 AS BIT)
											)
				SET @IdAdelanto = SCOPE_IDENTITY();

				SELECT @IdAdelanto
	END
	ELSE
	BEGIN
		SET @IdAdelanto = -1;
		SELECT @IdAdelanto;
	END
END
