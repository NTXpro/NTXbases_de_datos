
CREATE PROC [ERP].[Usp_Upd_DatoLaboralPrestamo]
@IdPrestamo INT,
@IdDatoLaboral INT,
@IdEmpresa INT,
@IdConcepto INT,
@Cuotas DECIMAL(14,5),
@Monto DECIMAL(14,5),
@Descuento DECIMAL(14,5),
@FechaPrestamo DATETIME,
@FechaDescuento DATETIME
AS
BEGIN
	DECLARE @FECHA_INICIO_LABORAL DATETIME = (SELECT FechaInicio FROM ERP.DatoLaboral WHERE ID = @IdDatoLaboral);

	IF(@FechaPrestamo >= @FECHA_INICIO_LABORAL AND @FechaDescuento >= @FECHA_INICIO_LABORAL)
	BEGIN
		UPDATE ERP.DatoLaboralPrestamo 
		SET FechaPrestamo = @FechaPrestamo , FechaDescuento = @FechaDescuento , 
		IdConcepto = @IdConcepto , Cuotas = @Cuotas , Descuento = @Descuento , Monto = @Monto
		WHERE ID = @IdPrestamo AND IdDatoLaboral = @IdDatoLaboral AND IdEmpresa = @IdEmpresa
		SELECT @IdPrestamo
	END
	ELSE
	BEGIN
		SET @IdPrestamo = -1;
		SELECT @IdPrestamo;
	END
END
