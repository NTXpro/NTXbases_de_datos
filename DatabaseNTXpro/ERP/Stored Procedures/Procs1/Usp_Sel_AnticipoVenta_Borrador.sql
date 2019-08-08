
CREATE PROC [ERP].[Usp_Sel_AnticipoVenta_Borrador]
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT
AS
BEGIN

		SELECT ENT.Nombre			Cliente,
			   AN.IdCliente		IdCliente,
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
		FROM ERP.AnticipoVenta AN
		LEFT JOIN ERP.Cliente CLI
		ON CLI.ID = AN.IdCliente
		LEFT JOIN ERP.Entidad ENT
        ON ENT.ID = CLI.IdEntidad
		LEFT JOIN ERP.EntidadTipoDocumento ETD
        ON ETD.IdEntidad = ENT.ID
		LEFT JOIN PLE.T2TipoDocumento TD
		ON TD.ID = ETD.IdTipoDocumento
        LEFT JOIN PLE.T10TipoComprobante TC
        ON TC.ID = AN.IdTipoComprobante
        LEFT JOIN Maestro.Moneda MO
        ON MO.ID = AN.IdMoneda
		WHERE AN.Flag = 0 AND AN.FlagBorrador = 1 AND AN.IdEmpresa = @IdEmpresa AND YEAR(AN.FechaEmision) = @IdAnio AND MONTH(AN.FechaEmision) = @IdMes

END
