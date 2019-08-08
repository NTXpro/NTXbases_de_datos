CREATE PROC [ERP].[Usp_Sel_Percepcion_By_ID] --1
@ID INT
AS
BEGIN
	
		SELECT PER.ID,
			   PER.Fecha		FechaPercepcion,
			   PER.IdTipoPercepcion IdTipoPercepcion,
			   PER.Serie		SeriePercepcion,
			   PER.Documento	DocumentoPercepcion,
			   PER.Importe		ImportePercepcion,
			   CO.ID				IdCompra,
			   CO.IdEmpresa,
			   CO.IdPeriodo,
			   CO.Orden,
			   CO.IdProveedor,
			   CO.FechaEmision,
			   CO.UsuarioRegistro,
			   CO.UsuarioModifico,
			   CO.UsuarioActivo,
			   CO.UsuarioElimino,
			   CO.FechaModificado,
			   CO.FechaActivacion,
			   CO.FechaRegistro,
			   TD.Abreviatura		TipoDocumento,
			   TD.ID				IdTipoDocumento,
			   ETD.NumeroDocumento  RUC,
			   ENT.Nombre			NombreProveedor,
			   CO.FechaRecepcion,
			   CO.IdMoneda,
			   MO.Nombre			Moneda,
			   TC.ID				IdTipoComprobante,
			   TC.Nombre			TipoComprobante,
			   CO.Serie,
			   CO.Numero,
			   CO.TipoCambio,
			   CO.PorcentajeIGV,
			   CO.IdTipoIGV,
			   TIG.Nombre			NombreTipoIGV,
			   CO.FechaVencimiento,
			   CO.FechaRecepcion,
			   CO.BaseImponible,
			   CO.Inafecto,
			   CO.IGV,
			   CO.ISC,
			   CO.OtroImpuesto,
			   CO.Descuento,
			   CO.RedondeoSuma,
			   CO.RedondeoResta,
			   CO.Total,
			   CO.IdDetraccion,
			   DE.Nombre			NombreDetraccion,
			   DE.Porcentaje		PorcentajeDetraccion
		FROM ERP.Percepcion PER
		INNER JOIN ERP.Compra CO 
		ON CO.ID = PER.IdCompra
		LEFT JOIN ERP.Proyecto P
		ON P.ID = CO.ID
		INNER JOIN ERP.Empresa EM 
		ON EM.ID = CO.IdEmpresa
		INNER JOIN ERP.Periodo PE
		ON PE.ID = CO.IdPeriodo
		LEFT JOIN ERP.Proveedor PRO
		ON PRO.ID = CO.IdProveedor
		LEFT JOIN ERP.Entidad ENT
		ON ENT.ID = PRO.IdEntidad
		LEFT JOIN ERP.Establecimiento E
		ON E.IdEntidad = ENT.ID
		LEFT JOIN PLAME.T7Ubigeo U
		ON U.ID = E.IdUbigeo
		LEFT JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = ENT.ID
		LEFT JOIN PLE.T2TipoDocumento TD
		ON TD.ID = ETD.IdTipoDocumento
		LEFT JOIN Maestro.Moneda MO
		ON MO.ID = CO.IdMoneda
		INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = CO.IdTipoComprobante
		INNER JOIN Maestro.TipoIGV TIG
		ON TIG.ID = CO.IdTipoIGV
		LEFT JOIN Maestro.Detraccion DE
		ON DE.ID = CO.IdDetraccion
		WHERE PER.ID = @Id
END
