
CREATE PROC [ERP].[Usp_Sel_Saldo_Cuenta]
@Fecha DATETIME,
@TipoCambio DECIMAL(14,5),
@Ordenamiento INT,
@TipoCuenta INT,
@IdEmpresa INT
AS
BEGIN
	SELECT	C.ID,
			(SELECT [ERP].[ObtenerNombreBancoMonedaTipo_By_IdCuenta](C.ID)) NombreCuentaBancoMoneda,
-------------------------------  SOLES  ----------------------------------
			CASE WHEN C.IdMoneda = 1 THEN
				(SELECT [ERP].[ObtenerTotalMovimientoByCuentaFecha](C.ID,@Fecha))
			ELSE 
				CAST(0 AS DECIMAL(14,5))
			END SaldoLibrosSoles,
			CASE WHEN C.IdMoneda = 1 THEN
				(SELECT [ERP].[ObtenerTotalMovimientoConciliadoByCuentaFecha](C.ID,@Fecha))
			ELSE 
				CAST(0 AS DECIMAL(14,5))
			END SaldoBancoSoles,
			CASE WHEN C.IdMoneda = 1 THEN
				(SELECT [ERP].[ObtenerTotalMovimientoByCuentaFecha](C.ID,@Fecha))
			ELSE 
				CAST(0 AS DECIMAL(14,5))
			END SaldoDisponibleSoles,
-------------------------------  DOLARES  ----------------------------------
			CASE WHEN C.IdMoneda = 2 THEN
				(SELECT [ERP].[ObtenerTotalMovimientoByCuentaFecha](C.ID,@Fecha))
			ELSE 
				CAST(0 AS DECIMAL(14,5))
			END SaldoLibrosDolares,
			CASE WHEN C.IdMoneda = 2 THEN
				(SELECT [ERP].[ObtenerTotalMovimientoConciliadoByCuentaFecha](C.ID,@Fecha))
			ELSE 
				CAST(0 AS DECIMAL(14,5))
			END SaldoBancoDolares,
			CASE WHEN C.IdMoneda = 2 THEN
				(SELECT [ERP].[ObtenerTotalMovimientoByCuentaFecha](C.ID,@Fecha))
			ELSE 
				CAST(0 AS DECIMAL(14,5))
			END SaldoDisponibleDolares,
-------------------------------  ORIGINAL  ----------------------------------
			CASE WHEN C.IdMoneda = 2 THEN
				CAST(((SELECT [ERP].[ObtenerTotalMovimientoByCuentaFecha](C.ID,@Fecha)) / @TipoCambio)AS DECIMAL(14,5))
			ELSE 
				(SELECT [ERP].[ObtenerTotalMovimientoByCuentaFecha](C.ID,@Fecha))
			END SaldoLibrosOriginal,
			CASE WHEN C.IdMoneda = 2 THEN
				CAST(((SELECT [ERP].[ObtenerTotalMovimientoConciliadoByCuentaFecha](C.ID,@Fecha)) / @TipoCambio)AS DECIMAL(14,5))
			ELSE 
				(SELECT [ERP].[ObtenerTotalMovimientoConciliadoByCuentaFecha](C.ID,@Fecha))
			END SaldoBancoOriginal,
			CASE WHEN C.IdMoneda = 2 THEN
				CAST(((SELECT [ERP].[ObtenerTotalMovimientoByCuentaFecha](C.ID,@Fecha)) / @TipoCambio)AS DECIMAL(14,5))
			ELSE 
				(SELECT [ERP].[ObtenerTotalMovimientoByCuentaFecha](C.ID,@Fecha))
			END SaldoDisponibleOriginal
	FROM ERP.Cuenta C
	WHERE Flag = 1 AND FlagBorrador = 0 AND (@TipoCuenta = 0 OR IdTipoCuenta = @TipoCuenta) AND IdEmpresa = @IdEmpresa
	ORDER BY 
    CASE @Ordenamiento
    WHEN 1 THEN (SELECT [ERP].[ObtenerTotalMovimientoByCuentaFecha](C.ID,@Fecha))
    END,
	CASE @Ordenamiento
    WHEN 2 THEN C.IdMoneda
    END;
END
