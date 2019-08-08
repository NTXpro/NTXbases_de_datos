
CREATE PROC [ERP].[Usp_Upd_DatoLaboralAdelanto]
@IdAdelanto INT,
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
		UPDATE ERP.DatoLaboralAdelanto SET Fecha = @Fecha , Motivo = @Motivo , Monto = @Monto
		WHERE ID = @IdAdelanto AND IdDatoLaboral = @IdDatoLaboral AND IdEmpresa = @IdEmpresa
		SELECT @IdAdelanto
	END
	ELSE
	BEGIN
		SET @IdAdelanto = -1;
		SELECT @IdAdelanto;
	END

END
