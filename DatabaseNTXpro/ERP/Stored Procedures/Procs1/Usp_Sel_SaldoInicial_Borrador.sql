
CREATE PROC ERP.Usp_Sel_SaldoInicial_Borrador
@IdEmpresa INT
AS
BEGIN
			SELECT SI.ID,
			       SI.IdProveedor		IdProveedor,
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
				   SI.FechaRegistro		FechaRegistro
			FROM ERP.SaldoInicial SI
			LEFT JOIN ERP.Proveedor PRO ON PRO.ID = SI.IdProveedor
			LEFT JOIN ERP.Entidad E ON E.ID = PRO.IdEntidad
			LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = PRO.IdEntidad
			LEFT JOIN PLE.T2TipoDocumento TD ON TD.ID = ETD.IdTipoDocumento
			LEFT JOIN Maestro.Moneda MO ON MO.ID = SI.IdMoneda
			LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = SI.IdTipoComprobante
			WHERE SI.IdEmpresa = @IdEmpresa AND SI.FlagBorrador = 1
END
