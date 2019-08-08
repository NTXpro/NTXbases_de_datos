CREATE PROC [ERP].[Usp_Sel_AplicacionAnticipoCobrarSinAplicar]
@IdCliente INT,
@IdEmpresa INT
AS
BEGIN
		SELECT	AA.ID,
				AA.ID,
				AA.Fecha,
				AA.Serie,
				AA.Documento,
				AA.Total,
				AA.TipoCambio,
				AA.IdMoneda,
				AA.Moneda,
				AA.IdTipoComprobante,
				AA.TipoComprobante,
				AA.IdCliente,
				AA.Cliente,
				AA.Saldo
		FROM
		(SELECT CC.ID				ID,
			   CC.Fecha				Fecha,
			   CC.Serie				Serie,
			   CC.Numero			Documento,
			   CC.Total				Total,
			   CC.TipoCambio		TipoCambio,
			   MO.ID				IdMoneda,
			   MO.CodigoSunat		Moneda,
			   TC.ID				IdTipoComprobante,
			   TC.Nombre			TipoComprobante,
			   CLI.ID				IdCliente,
			   ENT.Nombre			Cliente,
			   (SELECT(ERP.ObtenerTotalSaldoAplicacionCuentaCobrar(CC.ID))) Saldo
		FROM ERP.CuentaCobrar CC
		INNER JOIN ERP.Entidad ENT
		ON ENT.ID = CC.IdEntidad
		INNER JOIN ERP.Cliente CLI
		ON CLI.IdEntidad = ENT.ID
		INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = CC.IdTipoComprobante
		INNER JOIN Maestro.Moneda MO
		ON MO.ID = CC.IdMoneda
		WHERE CC.Flag = 1 AND TC.ID IN (183,8,178) AND CLI.ID = @IdCliente AND CC.IdEmpresa = @IdEmpresa  AND (TC.ID IN (183,8) OR (TC.ID = 178 AND CC.IdDebeHaber = 2))) AA WHERE AA.Saldo > 0 

END