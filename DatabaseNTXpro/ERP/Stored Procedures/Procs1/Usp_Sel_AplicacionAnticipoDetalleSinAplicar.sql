CREATE PROC [ERP].[Usp_Sel_AplicacionAnticipoDetalleSinAplicar] 
@IdCuentaPagar INT,
@IdEmpresa INT 
AS
BEGIN

		DECLARE @FechaEmision DATE = (SELECT CAST(Fecha as DATE) FROM ERP.CuentaPagar WHERE ID = @IdCuentaPagar)
		DECLARE @IdEntidad INT = (SELECT IdEntidad FROM ERP.CuentaPagar WHERE ID = @IdCuentaPagar)

		SELECT CP.ID				ID,
			   PRO.ID				IdProveedor,
			   MO.ID				IdMoneda,
			   CP.IdTipoComprobante	IdTipoComprobante,
			   CP.FechaRecepcion				FechaEmision,
			   CP.Serie				Serie,
			   CP.Numero			Documento,
			   CP.Total				Total,
			   CP.TipoCambio		TipoCambio,
			   MO.CodigoSunat		Moneda,
			   TC.Nombre			TipoComprobante,
			   ENT.Nombre			Proveedor,
			   (SELECT ERP.ObtenerTotalSaldoAplicacionCuentaPagarDetalleConvertido(@IdCuentaPagar,CP.ID))	SaldoConvertido,
			   (SELECT ERP.ObtenerTotalSaldoAplicacionCuentaPagarDetalleMonedaOriginal(CP.ID))				SaldoOriginal
		FROM ERP.CuentaPagar CP
		INNER JOIN ERP.Entidad ENT
		ON ENT.ID = CP.IdEntidad
		INNER JOIN ERP.Proveedor PRO
		ON PRO.IdEntidad = ENT.ID
		INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = CP.IdTipoComprobante
		INNER JOIN Maestro.Moneda MO
		ON MO.ID = CP.IdMoneda
		WHERE CP.Flag = 1 AND IdDebeHaber = 2 AND CP.IdTipoComprobante != 183 AND CP.IdEmpresa = @IdEmpresa AND PRO.IdEmpresa = @IdEmpresa 
		AND ROUND((SELECT ERP.ObtenerTotalSaldoAplicacionCuentaPagarDetalleMonedaOriginal(CP.ID)),2) > 0  AND CP.IdEntidad = @IdEntidad

END
