CREATE PROC [ERP].[Usp_Sel_Compra_By_ID]
@Id INT
AS
BEGIN
	
		SELECT CO.ID,
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
			   CO.FechaEliminado,
			   CO.FlagBorrador,
			   CR.Serie SerieReferencia,
			   CR.Numero DocumentoReferencia,
			   TCR.CodigoSunat CodigoSunatTipoComprobanteReferencia,
			   TD.Abreviatura		TipoDocumento,
			   TD.ID				IdTipoDocumento,
			   ETD.NumeroDocumento  RUC,
			   ENT.Nombre			NombreProveedor,
			   E.Direccion + ISNULL((' - ' + U.Nombre + ' - ' + (SELECT [PLAME].[ObtenerNombreProvincia_By_Distrito](U.ID)) + ' - ' + (SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](U.ID))),'')  Direccion,
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
			   CO.DiasVencimiento			DiasVencimiento,
			   CO.FechaVencimiento,
			   CO.Descripcion,
			   CO.FechaRecepcion,
			   CO.BaseImponible,
			   CO.Inafecto,
			   MO.CodigoSunat,
			   CO.IGV,
			   CO.ImpuestoRenta,
			   CO.ISC,
			   CO.OtroImpuesto OtroImpuesto,
			   CO.FlagImpuestoSegundaCategoria,
			   CO.ImpuestoRentaSegundaCategoria,
			   CO.Descuento,
			   CO.RedondeoSuma,
			   CO.RedondeoResta,
			   CO.Total,
			   CO.IdDetraccion,
			   DE.Nombre			NombreDetraccion,
			   DE.Porcentaje		PorcentajeDetraccion
		FROM ERP.Compra CO 
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
		LEFT JOIN ERP.CompraReferenciaInterna CI
		ON CI.IdCompra = CO.ID
		LEFT JOIN ERP.Compra CR
		ON CR.ID = CI.IdCompraReferencia
		LEFT JOIN PLE.T10TipoComprobante TCR
		ON TCR.ID = CR.IdTipoComprobante
		LEFT JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = ENT.ID
		LEFT JOIN PLE.T2TipoDocumento TD
		ON TD.ID = ETD.IdTipoDocumento
		LEFT JOIN Maestro.Moneda MO
		ON MO.ID = CO.IdMoneda
		INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = CO.IdTipoComprobante
		LEFT JOIN Maestro.TipoIGV TIG
		ON TIG.ID = CO.IdTipoIGV
		LEFT JOIN Maestro.Detraccion DE
		ON DE.ID = CO.IdDetraccion
		WHERE CO.ID = @Id
END