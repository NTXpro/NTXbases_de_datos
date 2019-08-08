CREATE FUNCTION [ERP].[ObtenerTotalMovimientoCuentaCobrarSoles](
@IdCuentaCobrar INT
)
RETURNS DECIMAL(15,2)
AS
BEGIN
	
	DECLARE @Total DECIMAL(14,2);
	DECLARE @TotalMovimientoCuentaPagarSoles DECIMAL(14,2);
	DECLARE @TotalNotaCreditoSoles DECIMAL(14,2);

	SET @TotalMovimientoCuentaPagarSoles = (SELECT
											SUM(CASE WHEN C.IdMoneda = 1 THEN 
													MTD.Total 
												WHEN C.IdMoneda = 2 THEN
													MTD.Total * MT.TipoCambio
												END)
									 		FROM ERP.MovimientoTesoreriaDetalleCuentaCobrar MDCC
									 		INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCC.IdMovimientoTesoreriaDetalle
									 		INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
											INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
											WHERE IdCuentaCobrar = @IdCuentaCobrar AND MT.Flag = 1 AND MT.FlagBorrador = 0 AND MTD.PagarCobrar = 'C');
				
	SET @TotalNotaCreditoSoles = (SELECT CASE WHEN C.IdMoneda = 1 THEN 
										C.Total 
									WHEN C.IdMoneda = 2 THEN
										C.Total * C.TipoCambio
									END
							FROM ERP.Comprobante C
							INNER JOIN ERP.ComprobanteReferenciaInterno CRI ON CRI.IdComprobante = C.ID 
							INNER JOIN ERP.Comprobante CR ON CR.ID = CRI.IdComprobanteReferencia	
							WHERE CR.IdCuentaCobrar = @IdCuentaCobrar AND C.Flag = 1 AND C.FlagBorrador = 0
							AND C.IdComprobanteEstado = 2)
	
	SET @Total = ISNULL(@TotalMovimientoCuentaPagarSoles,0)	+ ISNULL(@TotalNotaCreditoSoles,0);					 
	RETURN ISNULL(@Total,0)
END
