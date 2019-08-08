
CREATE PROCEDURE ERP.Usp_Sel_ComprobanteParaRetencion
@IdTipoComprobanteFactura INT,
@IdTipoComprobanteBoleta INT,
@IdCliente INT,
@IdEmpresa INT
AS
	SELECT C.ID, 
			C.IdTipoComprobante, 
			C.Serie, 
			C.Documento, 
			C.Fecha, 
			C.IdMoneda, 
			MO.CodigoSunat Moneda,
			C.Total,
			0 SaldoInicial
	FROM ERP.Comprobante C	
	INNER JOIN Maestro.Moneda MO ON C.IdMoneda = MO.ID	
	INNER JOIN ComprobanteCuentaCobrar CCC ON C.ID = CCC.IdComprobante
	INNER JOIN ERP.CuentaCobrar CC ON CCC.IdCuentaCobrar = CC.ID
	WHERE (C.IdTipoComprobante = @IdTipoComprobanteFactura
	OR C.IdTipoComprobante = @IdTipoComprobanteBoleta)
	AND C.IdCliente = @IdCliente
	AND C.IdEmpresa = @IdEmpresa
	AND C.Flag = 1
	AND C.FlagBorrador = 0
	AND (C.IdComprobanteEstado = 1
		OR C.IdComprobanteEstado = 2)
	AND CC.Flag	= 1	
	AND CC.FlagCancelo = 0

	UNION

	SELECT SIC.ID,
			SIC.IdTipoComprobante,
			SIC.Serie,
			SIC.Documento, 
			SIC.Fecha, 
			SIC.IdMoneda, 
			MO.CodigoSunat Moneda,
			SIC.Monto AS 'Total',
			1 SaldoInicial
	FROM ERP.SaldoInicialCobrar SIC
	INNER JOIN Maestro.Moneda MO ON SIC.IdMoneda = MO.ID	
	INNER JOIN ERP.SaldoInicialCuentaCobrar SICC ON SIC.ID = SICC.IdSaldoInicialCobrar
	INNER JOIN ERP.CuentaCobrar CC ON SICC.IdCuentaCobrar = CC.ID
	WHERE (SIC.IdTipoComprobante = @IdTipoComprobanteFactura
	OR SIC.IdTipoComprobante = @IdTipoComprobanteBoleta)
	AND SIC.IdCliente = @IdCliente
	AND SIC.IdEmpresa = @IdEmpresa
	AND SIC.Flag = 1
	AND SIC.FlagBorrador = 0
	AND CC.Flag	= 1	
	AND CC.FlagCancelo = 0

	ORDER BY Fecha DESC
