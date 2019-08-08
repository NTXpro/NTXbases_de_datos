
create PROC [ERP].[Usp_Sel_Report_AplicacionAnticipoPagar_By_ID]
@IdAplicacionAnticipo INT
AS
BEGIN

	SELECT AAP.Serie			Serie,
		   AAP.Documento		Documento,
		   AAP.FechaAplicacion	FechaRegistro,
		   AAP.TipoCambio		TipoCambio,
		   AAP.Total			Total,
		   AAP.UsuarioRegistro	UsuarioRegistro,
		   ENT.Nombre			Proveedor,
		   TC.Nombre			TipoComprobante,
		   ETD.NumeroDocumento  RUC,
		   TD.Abreviatura		TipoDocumento,
		   MO.CodigoSunat		Moneda,
		   (SELECT([ERP].[ObtenerTotalSaldoAplicacionCuentaPagarSoles](AAP.IdCuentaPagar))) Saldo
	FROM ERP.AplicacionAnticipoPagar AAP
	INNER JOIN ERP.Proveedor PRO
	ON PRO.ID = AAP.IdProveedor
	INNER JOIN ERP.Entidad ENT
	ON ENT.ID = PRO.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento ETD
	ON ETD.IdEntidad = ENT.ID
	INNER JOIN PLE.T2TipoDocumento  TD
	ON TD.ID = ETD.IdTipoDocumento
	INNER JOIN Maestro.Moneda MO
	ON MO.ID = AAP.IdMoneda
	INNER JOIN PLE.T10TipoComprobante TC
	ON TC.ID = AAP.IdTipoComprobante
	WHERE AAP.ID = @IdAplicacionAnticipo
END
