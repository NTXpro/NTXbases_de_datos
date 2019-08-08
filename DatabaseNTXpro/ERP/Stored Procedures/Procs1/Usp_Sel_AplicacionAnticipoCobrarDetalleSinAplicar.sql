
CREATE PROC [ERP].[Usp_Sel_AplicacionAnticipoCobrarDetalleSinAplicar]
@IdCuentaCobrar	INT,
@IdEmpresa INT
AS
BEGIN

	DECLARE @FechaEmision DATE = (SELECT CAST(Fecha as DATE) FROM ERP.CuentaCobrar WHERE ID = @IdCuentaCobrar)
	DECLARE @IdEntidad INT = (SELECT IdEntidad FROM ERP.CuentaCobrar WHERE ID = @IdCuentaCobrar)

	SELECT	   CC.ID				ID,
			   CLI.ID				IdCliente,
			   MO.ID				IdMoneda,
			   CC.IdTipoComprobante	IdTipoComprobante,
			   CC.Fecha			
			   	FechaEmision,
			   CC.Serie				Serie,
			   CC.Numero			Documento,
			   CC.Total				Total,
			   CC.TipoCambio		TipoCambio,
			   MO.CodigoSunat		Moneda,
			   TC.Nombre			TipoComprobante,
			   ENT.Nombre			Cliente,
			   (SELECT ERP.ObtenerTotalSaldoAplicacionCuentaCobrarDetalleConvertido(@IdCuentaCobrar,CC.ID)) SaldoConvertido,
			   (SELECT ERP.ObtenerTotalSaldoAplicacionCuentaCobrarDetalleMonedaOriginal(CC.ID))				SaldoOriginal
		FROM ERP.CuentaCobrar CC
		INNER JOIN ERP.Entidad ENT
		ON ENT.ID = CC.IdEntidad
		INNER JOIN ERP.Cliente CLI
		ON CLI.IdEntidad = ENT.ID AND CLI.IdEmpresa = @IdEmpresa
		INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = CC.IdTipoComprobante
		INNER JOIN Maestro.Moneda MO
		ON MO.ID = CC.IdMoneda
		WHERE CC.Flag = 1 AND CC.IdDebeHaber = 1 AND CC.IdTipoComprobante != 183 AND CC.IdEmpresa = @IdEmpresa  --AND CAST(CC.Fecha AS DATE) >= @FechaEmision
		AND (SELECT ERP.ObtenerTotalSaldoAplicacionCuentaCobrarDetalleMonedaOriginal(CC.ID)) > 0 AND CC.IdEntidad = @IdEntidad

END
