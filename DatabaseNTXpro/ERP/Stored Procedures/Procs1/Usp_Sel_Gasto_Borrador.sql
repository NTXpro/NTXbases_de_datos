
CREATE PROC [ERP].[Usp_Sel_Gasto_Borrador] 
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT
AS
BEGIN

		SELECT ENT.Nombre			Proveedor,
			   GA.IdProveedor		IdProveedor,
			   GA.IdMoneda			IdMoneda,
			   TD.Abreviatura		TipoDocumento,
			   GA.IdTipoComprobante	IdTipoComprobante,
			   ETD.NumeroDocumento	NumeroDocumento,
			   MO.CodigoSunat		Moneda,
			   GA.TipoCambio		TipoCambio,
			   TC.Nombre			TipoComprobante,
			   GA.Orden				Orden,
			   GA.Serie				Serie,
			   GA.Documento			Documento,
			   GA.FechaEmision		FechaEmision,
			   GA.Descripcion		Descripcion,
			   GA.Total				Total,
			   GA.ID				ID,
			   GA.IdEmpresa			IdEmpresa
		FROM ERP.Gasto GA
		LEFT JOIN ERP.Proveedor PRO
		ON PRO.ID = GA.IdProveedor
		LEFT JOIN ERP.Entidad ENT
        ON ENT.ID = PRO.IdEntidad
		LEFT JOIN ERP.EntidadTipoDocumento ETD
        ON ETD.IdEntidad = ENT.ID
		LEFT JOIN PLE.T2TipoDocumento TD
		ON TD.ID = ETD.IdTipoDocumento
        LEFT JOIN PLE.T10TipoComprobante TC
        ON TC.ID = GA.IdTipoComprobante
        LEFT JOIN Maestro.Moneda MO
        ON MO.ID = GA.IdMoneda
		WHERE GA.Flag = 1 AND GA.FlagBorrador = 1 AND GA.IdEmpresa = @IdEmpresa AND YEAR(GA.FechaEmision) = @IdAnio AND MONTH(GA.FechaEmision) = @IdMes

END
