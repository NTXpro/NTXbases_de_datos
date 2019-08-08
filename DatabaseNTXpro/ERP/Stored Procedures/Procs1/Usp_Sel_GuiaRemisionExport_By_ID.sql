CREATE PROC [ERP].[Usp_Sel_GuiaRemisionExport_By_ID]
@IdGuiaRemision INT 
AS
BEGIN

		SELECT GR.Serie,
			   GR.Documento,
			   GR.Fecha,
			   GR.TotalPeso PesoBruto,
			   GR.CodigoHash,
			   ENTGR.Nombre Cliente,
			   ENTGRES.Direccion DireccionCliente,
			   T10.Nombre	TipoComprobante,
			   T2GR.Abreviatura	TipoDocumentoCliente,
			   ETDGR.NumeroDocumento NumeroDocumentoCliente,
			   --GR.EstablecimientoDestino DirecionDestino,
			   ISNULL(GR.EstablecimientoDestino + ' - ','')  + T7UD.Nombre + ' - ' + ([PLAME].[ObtenerNombreProvincia_By_Distrito](T7UD.ID)) + ' - ' + ((SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](T7UD.ID))) AS DirecionDestino,
			   --GR.EstablecimientoOrigen DirecionOrigen,
			   ISNULL(GR.EstablecimientoOrigen + ' - ','')  + T7UO.Nombre + ' - ' + ([PLAME].[ObtenerNombreProvincia_By_Distrito](T7UO.ID)) + ' - ' + ((SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](T7UO.ID))) AS DirecionOrigen,
			   T20.Nombre MotivoTraslado,
			   T18.Nombre ModalidadTransporte,
			   VE.Placa NumeroPlaca,
			   T2CH.Abreviatura TipoDocumentoConductor,
			   ETDCH.NumeroDocumento NumeroDocumentoConductor,
			   ENTCH.Nombre NombreConductor,
			   CH.Licencia,
			   ETD.NumeroDocumento RucEmpresa,
			   ENT.Nombre NombreEmpresa,
			   EM.Telefono  TelefonoEmpresa,
			   EM.Celular	CelularEmpresa,
			   EM.Web WebEmpresa,
			   EM.Correo CorreoEmpresa,
			   EES.Direccion DireccionEmpresa,
			   (SELECT [ERP].[ObtenerWebSiteComprobanteElectronico]()) WebSiteComprobante,
			   EM.NumeroResolucion NumeroResolucionEmpresa,
			   EM.Imagen ImagenEmpresa,
			   ((SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](UE.ID)) +' - '+([PLAME].[ObtenerNombreProvincia_By_Distrito](UE.ID)) +' - '+UE.Nombre) AS DepartamentoProvinciaEmpresa,
			   PT.Nombre + ' '+ISNULL(PT.ApellidoPaterno,'') NombreVendedor,
			   GR.Observacion
		FROM ERP.GuiaRemision GR
		INNER JOIN PLE.T10TipoComprobante T10 ON T10.ID = GR.IdTipoComprobante
		INNER JOIN ERP.Entidad ENTGR ON ENTGR.ID = GR.IdEntidad
		LEFT JOIN ERP.Establecimiento ENTGRES ON ENTGRES.IdEntidad = ENTGR.ID  AND ENTGRES.IdTipoEstablecimiento = 1
		INNER JOIN EntidadTipoDocumento ETDGR ON ETDGR.IdEntidad = GR.IdEntidad
		INNER JOIN PLE.T2TipoDocumento T2GR ON T2GR.ID = ETDGR.IdTipoDocumento
		INNER JOIN XML.T20MotivoTraslado T20 ON T20.ID = GR.IdMotivoTraslado
		INNER JOIN XML.T18ModalidadTraslado T18 ON T18.ID = GR.IdModalidadTraslado
		LEFT JOIN ERP.Vehiculo VE ON VE.ID = GR.IdVehiculo
		LEFT JOIN ERP.Chofer CH ON CH.ID = GR.IdChofer
		INNER JOIN ERP.Entidad ENTCH ON ENTCH.ID = CH.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETDCH ON ETDCH.IdEntidad = CH.IdEntidad
		INNER JOIN PLE.T2TipoDocumento T2CH ON T2CH.ID = ETDCH.IdTipoDocumento
		INNER JOIN ERP.Empresa EM ON EM.ID = GR.IdEmpresa
		INNER JOIN ERP.Entidad ENT ON ENT.ID = EM.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = EM.IdEntidad
		LEFT JOIN ERP.Establecimiento EES ON EES.IdEntidad = EM.IdEntidad  AND EES.IdTipoEstablecimiento = 1
		LEFT JOIN PLAME.T7Ubigeo UE ON UE.ID = EES.IdUbigeo
		LEFT JOIN ERP.Vendedor V ON V.ID = GR.IdVendedor
		LEFT JOIN ERP.Trabajador T ON T.ID = V.IdTrabajador
		LEFT JOIN ERP.Persona PT ON PT.IdEntidad = T.IdEntidad
		LEFT JOIN PLAME.T7Ubigeo T7UO ON T7UO.ID = GR.IdUbigeoOrigen
		LEFT JOIN PLAME.T7Ubigeo T7UD ON T7UD.ID = GR.IdUbigeoDestino
		WHERE GR.ID = @IdGuiaRemision
		
END