﻿CREATE FUNCTION [ERP].[ObtenerTotalMovimientoCuentaCobrarSolesByClienteFechaVencimiento](
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

	SET @TotalCuentaCobrarSoles = (SELECT SUM(IIF(CC.IdMoneda = 1 ,CC.Total,'0.0000')*IIF(CC.IdTipoComprobante = 8,-1,1))
									FROM ERP.CuentaCobrar CC
									INNER JOIN ERP.Entidad ENT ON ENT.ID = CC.IdEntidad
									INNER JOIN ERP.Cliente CLI ON CLI.IdEntidad = ENT.ID
									WHERE CLI.ID = @IdCliente AND CC.Flag = 1
									AND CC.IdTipoComprobante IN (SELECT DATA FROM ERP.Fn_SplitContenido(@ListaTipoComprobante,','))
									AND CAST(CC.FechaVencimiento AS DATE)<= CAST(@Fecha AS DATE))

	SET @TotalMovimientoCuentaCobrarSoles = (SELECT SUM(IIF(CC.IdMoneda = 1 ,MTD.Total,'0.0000')*IIF(CC.IdTipoComprobante = 8,-1,1))
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
												AND CC.IdTipoComprobante IN (SELECT DATA FROM ERP.Fn_SplitContenido(@ListaTipoComprobante,','))
												AND CAST(CC.FechaVencimiento AS DATE)<= CAST(@Fecha AS DATE)
												AND CAST(MT.Fecha AS DATE) <= CAST(@Fecha AS DATE))

	SET @TotalAjuste = (SELECT SUM(IIF(A.IdMoneda = 1 ,A.Total,'0.0000')*IIF(CC.IdTipoComprobante = 8,-1,1))
										FROM ERP.AjusteCuentaCobrar A
										INNER JOIN ERP.CuentaCobrar CC ON CC.ID = A.IdCuentaCobrar
										INNER JOIN ERP.Cliente CLI ON CLI.IdEntidad = A.IdEntidad
										WHERE CLI.ID = @IdCliente 
										AND CC.IdTipoComprobante IN (SELECT DATA FROM ERP.Fn_SplitContenido(@ListaTipoComprobante,','))
										AND CAST(A.Fecha AS DATE) <= CAST(@Fecha AS DATE))

	SET @Total = ISNULL(@TotalCuentaCobrarSoles,0) - ISNULL(@TotalMovimientoCuentaCobrarSoles,0) - ISNULL(@TotalAjuste,0)

	RETURN @Total

END
