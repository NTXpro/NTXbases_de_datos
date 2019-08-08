CREATE PROC [ERP].[Usp_Sel_SaldoInicialCobrar_By_ID]
@ID INT
AS
BEGIN
			SELECT SI.ID,
			       SI.IdCliente			IdCliente,
				   SI.Fecha				Fecha,
				   SI.FechaVencimiento	FechaVencimiento,
				   SI.Serie				Serie,
				   SI.Documento			Documento,
				   SI.Monto				Monto,
				   SI.TipoCambio		TipoCambio,
				   TC.Nombre			NombreTipoComprobante,
				   SI.IdTipoComprobante	IdTipoComprobante,
				   TD.Abreviatura		TipoDocumento,
				   MO.ID				IdMoneda,
				   MO.Nombre			NombreMoneda,
				   ETD.NumeroDocumento	NumeroDocumento,
				   E.Nombre				NombreProveedor,
				   SI.FechaRegistro		FechaRegistro,
				   SI.FechaModificado	FechaModificado,
				   SI.FechaActivacion	FechaActivacion,
				   SI.FechaEliminado	FechaEliminado,
				   SI.UsuarioRegistro	UsuarioRegistro,
				   SI.UsuarioModifico	UsuarioModifico,
				   SI.UsuarioActivo		UsuarioActivo,
				   SI.UsuarioElimino	UsuarioElimino
			FROM ERP.SaldoInicialCobrar SI
			LEFT JOIN ERP.Cliente PRO ON PRO.ID = SI.IdCliente
			LEFT JOIN ERP.Entidad E ON E.ID = PRO.IdEntidad
			LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = PRO.IdEntidad
			LEFT JOIN PLE.T2TipoDocumento TD ON TD.ID = ETD.IdTipoDocumento
			LEFT JOIN Maestro.Moneda MO ON MO.ID = SI.IdMoneda
			LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = SI.IdTipoComprobante
			WHERE SI.ID	= @ID
END
