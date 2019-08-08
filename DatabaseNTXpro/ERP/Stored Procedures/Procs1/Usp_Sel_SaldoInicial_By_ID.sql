CREATE PROC [ERP].[Usp_Sel_SaldoInicial_By_ID] 
@ID INT
AS
BEGIN
			SELECT SI.ID,
			       SI.IdProveedor		IdProveedor,
				   SI.Fecha				Fecha,
				   SI.FechaVencimiento	FechaVencimiento,
				   SI.FechaRecepcion	FechaRecepcion,
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
			FROM ERP.SaldoInicial SI
			LEFT JOIN ERP.Proveedor PRO ON PRO.ID = SI.IdProveedor
			LEFT JOIN ERP.Entidad E ON E.ID = PRO.IdEntidad
			LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = PRO.IdEntidad
			LEFT JOIN PLE.T2TipoDocumento TD ON TD.ID = ETD.IdTipoDocumento
			LEFT JOIN Maestro.Moneda MO ON MO.ID = SI.IdMoneda
			LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = SI.IdTipoComprobante
			WHERE SI.ID	= @ID
END
