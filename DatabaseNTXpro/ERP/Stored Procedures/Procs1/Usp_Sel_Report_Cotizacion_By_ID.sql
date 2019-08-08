CREATE PROC [ERP].[Usp_Sel_Report_Cotizacion_By_ID]
@Id INT
AS
BEGIN
	
	SELECT EE.Nombre NombreEmpresa,
		   TCE.CodigoSunat CodigoTipoDocumentoEmpresa,
		   TCE.Nombre TipoDocumentoEmpresa,
		   ETDE.NumeroDocumento NumeroDocumentoEmpresa,
		   EES.Direccion DireccionEmpresa,
		   (UE.Nombre +' - '+([PLAME].[ObtenerNombreProvincia_By_Distrito](UE.ID)) +' - '+ (SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](UE.ID))) AS DepartamentoProvinciaEmpresa,
			ECLI.Nombre NombreCliente,
			TDCLI.CodigoSunat CodigoTipoDocumentoCliente,
			TDCLI.Abreviatura TipoDocumentoCliente,
			ETDCLI.NumeroDocumento NumeroDocumentoCliente,
			ESCLI.Direccion DireccionCliente,
			(UCLI.Nombre +' - '+([PLAME].[ObtenerNombreProvincia_By_Distrito](UCLI.ID)) +' - '+ (SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](UCLI.ID))) AS DepartamentoProvinciaCliente,
			M.Nombre NombreMoneda, 
			C.PorcentajeIGV,
			C.TotalDetalleAfecto,
			C.TotalDetalleInafecto,
			C.SubTotal,
			C.IGV,
			CASE WHEN C.FlagPercepcion = 1 THEN C.TotalPercepcion ELSE C.Total END Total,
			C.Fecha,
			C.FechaVencimiento,
			TC.ID IdTipoComprobante,
			E.Imagen,
			C.Serie,
			C.Documento,
			(SELECT [ERP].[ObtenerWebSiteComprobanteElectronico]()) WebSiteComprobante,
			E.NumeroResolucion NumeroResolucionEmpresa,
			CASE WHEN C.FlagAnticipo = 1 THEN C.Total ELSE CAST(0 AS DECIMAL(14,5)) END TotalAnticipo,
			C.PorcentajeDescuento,
			C.ImporteDescuento TotalDescuento,
			C.ISC TotalISC,
			C.Observacion,
			C.IdTipoComprobante,
			(SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](UE.ID)) NombreDepartamento,
			(SELECT [ERP].[ObtenerVentaBienesTransferidosAmazonia](C.IdEmpresa,GETDATE())) ParametroTextoDepartamental,
			'' Referencia,
			ETRA.Nombre NombreVendedor,
			(SELECT [ERP].[ObtenerDatosEmpresa](E.ID)) DatosEmpresa,
			E.Correo CorreoEmpresa,
			E.Web WebEmpresa,
			E.Telefono TelefonoEmpresa,
			E.Celular CelularEmpresa,
			TEC.Nombre TipoSucursal,
			CASE WHEN EES.ID = EC.ID THEN
				''
			ELSE
				EC.Nombre + ' - ' +EC.Direccion + '-' + ((SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](UES.ID)) +' - '+([PLAME].[ObtenerNombreProvincia_By_Distrito](UES.ID)) +' - '+UES.Nombre)
			END Sucursal,
			EC.Telefono TelefonoSucursal,
			EC.Celular CelularSucursal,
			C.PorcentajePercepcion,
			C.ImportePercepcion
	FROM ERP.Cotizacion C 
	INNER JOIN PLE.T10TipoComprobante TC
		ON TC.ID = C.IdTipoComprobante
	INNER JOIN Maestro.Moneda M
		ON M.ID = C.IdMoneda
	INNER JOIN ERP.Empresa E
		ON E.ID = C.IdEmpresa
	LEFT JOIN ERP.Entidad EE
		ON EE.ID = E.IdEntidad
	LEFT JOIN ERP.Establecimiento EES 
		ON EES.IdEntidad = EE.ID  AND EES.IdTipoEstablecimiento = 1
	LEFT JOIN ERP.EntidadTipoDocumento ETDE 
		ON ETDE.IdEntidad = EE.ID
	LEFT JOIN PLE.T10TipoComprobante TCE 
		ON TCE.ID = ETDE.IdTipoDocumento
	LEFT JOIN [PLAME].[T7Ubigeo] UE 
		ON UE.ID = EES.IdUbigeo
	LEFT JOIN ERP.Cliente CLI
		ON CLI.ID = C.IdCliente
	LEFT JOIN ERP.Entidad ECLI
		ON ECLI.ID = CLI.IdEntidad
	LEFT JOIN ERP.Establecimiento ESCLI 
		ON ESCLI.ID = C.IdEstablecimientoCliente
	LEFT JOIN ERP.EntidadTipoDocumento ETDCLI
		ON ETDCLI.IdEntidad = ECLI.ID
	LEFT JOIN PLE.T2TipoDocumento TDCLI  
		ON TDCLI.ID = ETDCLI.IdTipoDocumento
	LEFT JOIN [PLAME].[T7Ubigeo] UCLI
		ON UCLI.ID = ESCLI.IdUbigeo
	LEFT JOIN ERP.Vendedor V
		ON V.ID = C.IdVendedor
	LEFT JOIN ERP.Trabajador T
		ON T.ID = V.IdTrabajador
	LEFT JOIN ERP.Entidad ETRA
		ON ETRA.ID = T.IdEntidad
	LEFT JOIN ERP.Establecimiento EC
		ON EC.ID = C.IdEstablecimiento
	LEFT JOIN [PLAME].[T7Ubigeo] UES 
		ON UES.ID = EC.IdUbigeo
	LEFT JOIN PLAME.T2TipoEstablecimiento TEC
		ON TEC.ID = EC.IdTipoEstablecimiento
	WHERE C.ID = @Id
END