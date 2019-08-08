
CREATE FUNCTION [ERP].[ObtenerTotalSaldoDolaresByCuentaPagar](
@IdCuentaPagar INT,
@Fecha DATETIME
)
RETURNS DECIMAL(15,5)
AS
BEGIN

	DECLARE @Total DECIMAL(14,5);
	DECLARE @TotalCuentaPagarDolares DECIMAL(14,5);
	DECLARE @TotalMovimientoCuentaPagarDolares DECIMAL(14,5);
	DECLARE @TotalAplicacionAnticipo DECIMAL(14,5);
	
	SET  @TotalCuentaPagarDolares = (SELECT 
								SUM(IIF(CP.IdMoneda = 2 ,CP.Total,'0.0000')*IIF(CP.IdTipoComprobante = 8,-1,1))
								FROM ERP.CuentaPagar CP
								WHERE CP.Flag = 1 AND CP.ID = @IdCuentaPagar)

	SET @TotalMovimientoCuentaPagarDolares = (SELECT
											SUM(IIF(CP.IdMoneda = 2 ,MTD.Total,'0.0000')*IIF(CP.IdTipoComprobante = 8,-1,1))
									 		FROM ERP.MovimientoTesoreriaDetalleCuentaPagar MDCP
											INNER JOIN ERP.CuentaPagar CP ON MDCP.IdCuentaPagar = CP.ID
									 		INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCP.IdMovimientoTesoreriaDetalle
									 		INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
											INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
											WHERE MDCP.IdCuentaPagar = @IdCuentaPagar AND MT.Flag = 1 AND MT.FlagBorrador = 0 AND CAST(MT.Fecha AS DATE) <= CAST(@Fecha AS DATE));
				
	SET @TotalAplicacionAnticipo = (SELECT SUM (CASE WHEN AAP.IdMoneda = 2 AND CP.IdMoneda = 2 THEN
																	AAPD.TotalAplicado
																WHEN AAP.IdMoneda = 1 AND CP.IdMoneda = 2 THEN
																	ROUND((AAPD.TotalAplicado / AAP.TipoCambio),2)
																WHEN AAP.IdMoneda = 2 AND CP.IdMoneda = 1 THEN
																	AAPD.TotalAplicado
																WHEN AAP.IdMoneda = 1 AND CP.IdMoneda = 2 THEN
																	ROUND((AAPD.TotalAplicado * AAP.TipoCambio),2)
																END
																	)
															FROM ERP.AplicacionAnticipoPagar AAP
															INNER JOIN ERP.AplicacionAnticipoPagarDetalle AAPD ON AAP.ID = AAPD.IdAplicacionAnticipo
															INNER JOIN ERP.CuentaPagar CP ON CP.ID = AAPD.IdCuentaPagar
															INNER JOIN ERP.Entidad ENT ON ENT.ID = CP.IdEntidad
															INNER JOIN ERP.Proveedor PRO ON PRO.IdEntidad = ENT.ID
															WHERE CP.ID = @IdCuentaPagar
															AND CAST(AAP.FechaAplicacion AS DATE) <= CAST(@Fecha AS DATE))

	SET @Total = ISNULL(@TotalCuentaPagarDolares,0) - ISNULL(@TotalMovimientoCuentaPagarDolares,0) - ISNULL(@TotalAplicacionAnticipo,0)
									 
	RETURN ISNULL(@Total,0)
END
