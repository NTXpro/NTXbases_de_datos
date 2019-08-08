
CREATE PROC [ERP].[Usp_Sel_Report_AplicacionAnticipoCobrar_By_ID]
@IdAplicacionAnticipo INT
AS
BEGIN

	SELECT	   AAC.Serie			Serie,
			   AAC.Documento		Documento,
			   AAC.FechaAplicacion	FechaRegistro,
			   AAC.TipoCambio		TipoCambio,
			   AAC.Total			Total,
			   AAC.UsuarioRegistro	UsuarioRegistro,
			   ENT.Nombre			Cliente,
			   TC.Nombre			TipoComprobante,
			   ETD.NumeroDocumento  RUC,
			   TD.Abreviatura		TipoDocumento,
			   MO.CodigoSunat		Moneda,
			   (SELECT(ERP.ObtenerTotalSaldoAplicacionCuentaCobrar(AAC.IdCuentaCobrar))) Saldo
		FROM ERP.AplicacionAnticipoCobrar AAC
		INNER JOIN ERP.Cliente CLI
		ON CLI.ID = AAC.IdCliente
		INNER JOIN ERP.Entidad ENT
		ON ENT.ID = CLI.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = ENT.ID
		INNER JOIN PLE.T2TipoDocumento  TD
		ON TD.ID = ETD.IdTipoDocumento
		INNER JOIN Maestro.Moneda MO
		ON MO.ID = AAC.IdMoneda
		INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = AAC.IdTipoComprobante
		WHERE AAC.ID = @IdAplicacionAnticipo
END
