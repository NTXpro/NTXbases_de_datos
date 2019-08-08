
CREATE PROC [ERP].[Usp_Sel_AplicacionAnticipoCobrarDetalleSinAplicarNC] --2
@IdCuentaCobrar	INT
AS
BEGIN
		DECLARE @IdEmpresa INT = (SELECT IdEmpresa FROM ERP.CuentaCobrar WHERE ID = @IdCuentaCobrar)
		DECLARE @IdEntidad INT = (SELECT IdEntidad FROM ERP.CuentaCobrar WHERE ID = @IdCuentaCobrar)

			SELECT CC.ID				ID,
				   CC.Fecha				FechaEmision,
				   CLI.ID				IdCliente,
				   MO.ID				IdMoneda,
				   CC.IdTipoComprobante	IdTipoComprobante,
				   CC.Serie				Serie,
				   CC.Numero			Documento,
				   CC.Total				Total,
				   CC.TipoCambio		TipoCambio,
				   MO.CodigoSunat		Moneda,
				   TC.Nombre			TipoComprobante,
				   ENT.Nombre			Cliente,
				   (SELECT ERP.ObtenerTotalSaldoAplicacionCuentaCobrarDetalleConvertido(@IdCuentaCobrar,CC.ID))	SaldoConvertido,
				   (SELECT ERP.ObtenerTotalSaldoAplicacionCuentaCobrarDetalleMonedaOriginal(CC.ID))				SaldoOriginal
			FROM ERP.CuentaCobrar CC
			INNER JOIN ERP.Entidad ENT
			ON ENT.ID = CC.IdEntidad
			INNER JOIN ERP.Cliente CLI
			ON CLI.IdEntidad = ENT.ID AND CLI.FlagBorrador = 0
			INNER JOIN PLE.T10TipoComprobante TC
			ON TC.ID = CC.IdTipoComprobante
			INNER JOIN Maestro.Moneda MO
			ON MO.ID = CC.IdMoneda
			WHERE
			CC.IdEmpresa = @IdEmpresa AND CC.FLAG = 1 AND CC.IdEntidad = @IdEntidad AND CC.IdDebeHaber = 1
			AND ROUND((SELECT ERP.ObtenerTotalSaldoAplicacionCuentaCobrarDetalleMonedaOriginal(CC.ID)),2) > 0

END
