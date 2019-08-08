CREATE PROC [ERP].[Usp_Sel_CompraDetraccion_By_ID] 
@IdCompraDetraccion INT
AS
BEGIN
	
		SELECT	  CD.ID,
				  CO.Serie,
                  CO.Numero,
				  CD.FechaDetraccion,
				  CO.FechaEmision,
				  TD.Abreviatura		TipoDocumento,
				  ETD.NumeroDocumento  RUC,
				  ENT.Nombre			NombreProveedor,
				  CO.Total,
				  CD.FechaDetraccion,
				  CO.IdTipoComprobante,
				  DE.Nombre			NombreDetraccion,
				  DE.Porcentaje		PorcentajeDetraccion,
				  CD.Comprobante  ComprobanteDetraccion,
				  CD.Importe      ImporteDetraccion,
				  CO.IdDetraccion,
                  CO.IdEmpresa,
                  CO.IdPeriodo,
                  CO.Orden,
                  CO.IdProveedor,
                  CO.FechaEmision,
                  CO.IdMoneda,
				  DE.Nombre  NombreDetraccion,
                  MO.Nombre			Moneda,
                  TC.Nombre			TipoComprobante,
                  CO.TipoCambio,
                  CO.PorcentajeIGV,
                  CO.IdTipoIGV,
                  TIG.Nombre			NombreTipoIGV,
                  CO.FechaVencimiento,
                  CO.BaseImponible,
                  CO.Inafecto,
                  CO.IGV,
                  CO.ISC,
                  CO.OtroImpuesto,
                  CO.Descuento,
                  CO.RedondeoSuma,
                  CO.RedondeoResta,
                  CO.Total
                  FROM ERP.CompraDetraccion CD
				  INNER JOIN ERP.Compra CO 
				  ON CD.IdCompra = CO.ID
				  INNER JOIN ERP.Empresa EM 
                  ON EM.ID = CO.IdEmpresa
                  INNER JOIN ERP.Periodo PE
                  ON PE.ID = CO.IdPeriodo
                  LEFT JOIN ERP.Proveedor PRO
                  ON PRO.ID = CO.IdProveedor
                  LEFT JOIN ERP.Entidad ENT
                  ON ENT.ID = PRO.IdEntidad
                  LEFT JOIN ERP.EntidadTipoDocumento ETD
                  ON ETD.IdEntidad = ENT.ID
                  LEFT JOIN PLE.T2TipoDocumento TD
                  ON TD.ID = ETD.IdTipoDocumento
                  INNER JOIN Maestro.Moneda MO
                  ON MO.ID = CO.IdMoneda
                  INNER JOIN PLE.T10TipoComprobante TC
                  ON TC.ID = CO.IdTipoComprobante
                  INNER JOIN Maestro.TipoIGV TIG
                  ON TIG.ID = CO.IdTipoIGV
                  LEFT JOIN Maestro.Detraccion DE
                  ON DE.ID = CO.IdDetraccion
		WHERE CD.ID = @IdCompraDetraccion
END