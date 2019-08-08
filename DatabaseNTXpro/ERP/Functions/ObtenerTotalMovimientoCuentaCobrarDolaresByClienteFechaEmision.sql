CREATE FUNCTION [ERP].[ObtenerTotalMovimientoCuentaCobrarDolaresByClienteFechaEmision](
@IdCliente INT,
@ListaTipoComprobante VARCHAR(250),
@Fecha DATETIME
)
RETURNS DECIMAL(14,5)
AS
BEGIN

	DECLARE @Total DECIMAL(14,5);
	DECLARE @TotalMovimientoCuentaCobrarSoles DECIMAL(14,5);
	DECLARE @TotalCuentaCobrarSoles DECIMAL(14,5);
	DECLARE @TotalAjuste DECIMAL(14,5);
	DECLARE @TotalAnticipo DECIMAL(14,5);
	DECLARE @TotalAnticipoDetalle DECIMAL(14,5);

	SET @TotalCuentaCobrarSoles = (SELECT SUM(IIF(CC.IdMoneda = 2 ,CC.Total,'0.0000')*IIF(CC.IdTipoComprobante = 8,-1,1))
									FROM ERP.CuentaCobrar CC
									INNER JOIN ERP.Entidad ENT ON ENT.ID = CC.IdEntidad
									INNER JOIN ERP.Cliente CLI ON CLI.IdEntidad = ENT.ID AND CLI.IdEmpresa = CC.IdEmpresa
									WHERE CLI.ID = @IdCliente AND CC.Flag = 1
									AND CC.IdTipoComprobante IN (SELECT DATA FROM ERP.Fn_SplitContenido(@ListaTipoComprobante,','))
									AND CAST(CC.Fecha AS DATE)<= CAST(@Fecha AS DATE))

	SET @TotalMovimientoCuentaCobrarSoles = (SELECT SUM(IIF(CC.IdMoneda = 2 ,MTD.Total,'0.0000')*IIF(CC.IdTipoComprobante = 8,-1,1))
												FROM ERP.MovimientoTesoreriaDetalleCuentaCobrar MDCC
												INNER JOIN ERP.CuentaCobrar CC ON CC.ID = MDCC.IdCuentaCobrar
												INNER JOIN ERP.Entidad ENT ON ENT.ID = CC.IdEntidad
												INNER JOIN ERP.Cliente CLI ON CLI.IdEntidad = ENT.ID
												INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.ID = MDCC.IdMovimientoTesoreriaDetalle
												INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MTD.IdMovimientoTesoreria
												INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
												WHERE CLI.ID = @IdCliente AND MT.Flag = 1
												AND MT.FlagBorrador = 0 
												AND MTD.IdDebeHaber = 2
												AND CC.IdTipoComprobante NOT IN (183)
												AND CC.IdTipoComprobante IN (SELECT DATA FROM ERP.Fn_SplitContenido(@ListaTipoComprobante,','))
												--AND CAST(CC.Fecha AS DATE)<= CAST(@Fecha AS DATE))
												AND CAST(MT.Fecha AS DATE) <= CAST(@Fecha AS DATE))
	
	SET @TotalAnticipo = (SELECT SUM(IIF(CC.IdMoneda = 2 ,AAC.Total,'0.0000'))
							FROM ERP.AplicacionAnticipoCobrar AAC
							INNER JOIN ERP.CuentaCobrar CC ON CC.ID = AAC.IdCuentaCobrar
							INNER JOIN ERP.Cliente CLI ON CLI.ID = AAC.IdCliente
							WHERE CLI.ID = @IdCliente AND AAC.Flag = 1
							AND CC.IdTipoComprobante IN (SELECT DATA FROM ERP.Fn_SplitContenido(@ListaTipoComprobante,','))
							AND CAST(AAC.Fecha AS DATE) <= CAST(@Fecha AS DATE))




	SET @TotalAjuste = (SELECT SUM(IIF(A.IdMoneda = 2 ,A.Total,'0.0000')*IIF(CC.IdTipoComprobante = 8,-1,1))
										FROM ERP.AjusteCuentaCobrar A
										INNER JOIN ERP.CuentaCobrar CC ON CC.ID = A.IdCuentaCobrar
										INNER JOIN ERP.Cliente CLI ON CLI.IdEntidad = A.IdEntidad
										WHERE CLI.ID = @IdCliente 
										AND CC.IdTipoComprobante IN (SELECT DATA FROM ERP.Fn_SplitContenido(@ListaTipoComprobante,','))
										AND CAST(A.Fecha AS DATE) <= CAST(@Fecha AS DATE))
	
	SET @TotalAnticipoDetalle = (SELECT SUM(IIF(AACC.IdMoneda = 2 ,AACC.TotalAplicado,'0.0000'))
										FROM ERP.AplicacionAnticipoCobrar AAC
										INNER JOIN ERP.AplicacionAnticipoCobrarDetalle AACC ON AACC.IdAplicacionAnticipoCobrar = AAC.ID
										INNER JOIN ERP.CuentaCobrar CC ON CC.ID = AAC.IdCuentaCobrar
										INNER JOIN ERP.Cliente CLI ON CLI.ID = AAC.IdCliente
										WHERE CLI.ID = @IdCliente AND AAC.Flag = 1
										AND CC.IdTipoComprobante IN (SELECT DATA FROM ERP.Fn_SplitContenido(@ListaTipoComprobante,','))
										AND CAST(AAC.Fecha AS DATE) <= CAST(@Fecha AS DATE) AND AAC.Flag=1)

	SET @Total = ISNULL(@TotalCuentaCobrarSoles,0) - ISNULL(@TotalMovimientoCuentaCobrarSoles,0) - ISNULL(@TotalAjuste,0) - ISNULL(@TotalAnticipo,0) - ISNULL(@TotalAnticipoDetalle,0)

	RETURN @Total

END