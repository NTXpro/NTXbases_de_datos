create PROC [ERP].[Usp_Sel_AnticipoCompra_Borrador]
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT
AS
BEGIN

		SELECT ENT.Nombre			Proveedor,
			   AN.IdProveedor		IdProveedor,
			   AN.IdMoneda			IdMoneda,
			   TD.Abreviatura		TipoDocumento,
			   ETD.NumeroDocumento	NumeroDocumento,
			   AN.IdTipoComprobante	IdTipoComprobante,
			   MO.CodigoSunat		Moneda,
			   AN.TipoCambio		TipoCambio,
			   TC.Nombre			TipoComprobante,
			   AN.Orden				Orden,
			   AN.Serie				Serie,
			   AN.Documento			Documento,
			   AN.FechaEmision		FechaEmision,
			   AN.Descripcion		Descripcion,
			   AN.Total				Total,
			   AN.ID				ID,
			   AN.IdEmpresa			IdEmpresa
		FROM ERP.AnticipoCompra AN
		LEFT JOIN ERP.Proveedor PRO
		ON PRO.ID = AN.IdProveedor
		LEFT JOIN ERP.Entidad ENT
        ON ENT.ID = PRO.IdEntidad
		LEFT JOIN ERP.EntidadTipoDocumento ETD
        ON ETD.IdEntidad = ENT.ID
		LEFT JOIN PLE.T2TipoDocumento TD
		ON TD.ID = ETD.IdTipoDocumento
        LEFT JOIN PLE.T10TipoComprobante TC
        ON TC.ID = AN.IdTipoComprobante
        LEFT JOIN Maestro.Moneda MO
        ON MO.ID = AN.IdMoneda
		WHERE AN.Flag = 1 AND AN.FlagBorrador = 1 AND AN.IdEmpresa = @IdEmpresa AND YEAR(AN.FechaEmision) = @IdAnio AND MONTH(AN.FechaEmision) = @IdMes

END
