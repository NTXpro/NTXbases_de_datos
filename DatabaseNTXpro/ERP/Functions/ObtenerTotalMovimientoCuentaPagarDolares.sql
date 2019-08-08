CREATE FUNCTION [ERP].[ObtenerTotalMovimientoCuentaPagarDolares](
@IdCuentaPagar INT
)
RETURNS DECIMAL(15,2)
AS
BEGIN
	DECLARE @Total DECIMAL(14,2);
	DECLARE @TotalMovimientoCuentaPagarDolares DECIMAL(14,2);

	SET @TotalMovimientoCuentaPagarDolares = (SELECT
											SUM(CASE WHEN C.IdMoneda = 2 THEN 
													MTD.Total 
												WHEN C.IdMoneda = 1 THEN
													MTD.Total / MT.TipoCambio
												END)
									 		FROM ERP.MovimientoTesoreriaDetalleCuentaPagar MDCP
									 		INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCP.IdMovimientoTesoreriaDetalle
									 		INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
											INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
											WHERE IdCuentaPagar = @IdCuentaPagar AND MT.Flag = 1 AND MT.FlagBorrador = 0 AND MTD.PagarCobrar = 'P');

	SET @Total = ISNULL(@TotalMovimientoCuentaPagarDolares,0)
									 
	RETURN @Total
END
