
CREATE PROC [ERP].[Usp_Sel_AplicacionAnticipoDetalleSinAplicarNC] 
@IdCuentaPagar INT,
@IdEmpresa INT,
@IdProveedor INT
AS
BEGIN
		--DECLARE @IdCompra INT = (SELECT IdCompra FROM ERP.CompraCuentaPagar WHERE IdCuentaPagar = @IdCuentaPagar);

		--DECLARE @TableReferencia TABLE (IdCompra INT NOT NULL,IdReferencia INT NOT NULL,IdReferenciaOrigen INT NOT NULL);

		--INSERT INTO @TableReferencia(IdCompra,IdReferencia,IdReferenciaOrigen)
		--SELECT CR.IdCompra,CR.IdReferencia,CR.IdReferenciaOrigen 
		--FROM ERP.CompraReferencia CR
		--INNER JOIN ERP.Compra C ON C.ID = CR.IdCompra
		--WHERE C.IdEmpresa = @IdEmpresa AND CR.FlagInterno = 1 
		----WHERE IdCompra = @IdCompra AND FlagInterno = 1 


		--DECLARE @TableCuentaPagar TABLE (IdCuentaPagar INT NOT NULL) 

		--INSERT INTO @TableCuentaPagar (IdCuentaPagar)
		--SELECT CCP.IdCuentaPagar
		--FROM ERP.CompraCuentaPagar CCP
		--WHERE CCP.IdCompra IN (SELECT IdReferencia FROM @TableReferencia WHERE IdReferenciaOrigen = 4)

		--UNION ALL

		--SELECT SICP.IdCuentaPagar
		--FROM ERP.SaldoInicialCuentaPagar  SICP
		--WHERE SICP.IdSaldoInicial IN (SELECT IdReferencia FROM @TableReferencia WHERE IdReferenciaOrigen = 10)

			SELECT CP.ID				ID,
				   CP.Fecha				FechaEmision,
				   PRO.ID				IdProveedor,
				   MO.ID				IdMoneda,
				   CP.IdTipoComprobante	IdTipoComprobante,
				   CP.Serie				Serie,
				   CP.Numero			Documento,
				   CP.Total				Total,
				   CP.TipoCambio		TipoCambio,
				   MO.CodigoSunat		Moneda,
				   TC.Nombre			TipoComprobante,
				   ENT.Nombre			Proveedor,
				   (SELECT [ERP].[ObtenerTotalSaldoAplicacionCuentaPagarDetalleConvertido](@IdCuentaPagar,CP.ID)) SaldoConvertido,
				   (SELECT ERP.ObtenerTotalSaldoAplicacionCuentaPagarDetalleMonedaOriginal(CP.ID)) SaldoOriginal
			FROM ERP.CuentaPagar CP
			INNER JOIN ERP.Entidad ENT
			ON ENT.ID = CP.IdEntidad
			INNER JOIN ERP.Proveedor PRO
			ON PRO.IdEntidad = ENT.ID
			INNER JOIN PLE.T10TipoComprobante TC
			ON TC.ID = CP.IdTipoComprobante
			INNER JOIN Maestro.Moneda MO
			ON MO.ID = CP.IdMoneda
			WHERE --CP.ID IN (SELECT IdCuentaPagar FROM @TableCuentaPagar) 
			CP.IdEmpresa = @IdEmpresa and PRO.ID = @IdProveedor AND CP.FLAG = 1 AND CP.IdDebeHaber = 2
			AND ROUND((SELECT ERP.ObtenerTotalSaldoAplicacionCuentaPagarDetalleMonedaOriginal(CP.ID)),2) > 0
END
