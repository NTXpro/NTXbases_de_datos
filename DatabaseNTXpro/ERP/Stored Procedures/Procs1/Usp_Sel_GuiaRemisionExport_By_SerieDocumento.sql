CREATE PROC [ERP].[Usp_Sel_GuiaRemisionExport_By_SerieDocumento]
--[ERP].[Usp_Sel_GuiaRemisionExport_By_SerieDocumento] '0001', '00000007'
@Serie VARCHAR(4),
@Documento VARCHAR(8)
AS
BEGIN
    SELECT GR.ID IdGuiaRemision,
            GR.Serie,
            GR.Documento,
            GR.Fecha,
            GR.TotalPeso PesoBruto,
            GR.CodigoHash,
            ENTGR.Nombre Cliente,
            ENTGRES.Direccion DireccionCliente,
            T10.Nombre  TipoComprobante,
            ETDGR.NumeroDocumento NumeroDocumentoCliente,
            GR.EstablecimientoDestino DirecionDestino,
			CONCAT(T7DE2.Nombre, ' - ', T7PR2.Nombre, ' - ', T7U2.Nombre) UbigeoLlegada,
            GR.EstablecimientoOrigen DirecionOrigen,
			CONCAT(T7DE.Nombre, ' - ', T7PR.Nombre, ' - ', T7U.Nombre) UbigeoPartida,
            T20.Nombre MotivoTraslado,
            T18.Nombre ModalidadTransporte,
            VE.Marca UnidadTransporte,
            CH.Licencia,
            VE.Placa NumeroPlaca,
            T2CH.Abreviatura TipoDocumentoConductor,
            ENTCH.Nombre NombreConductor,
            ETDCH.NumeroDocumento NumeroDocumentoConductor,
            ENTTRA.Nombre NombreTransportista,
            ETTRA.NumeroDocumento NumeroDocumentoTransportista,
            ETD.NumeroDocumento RucEmpresa,
            ENT.Nombre NombreEmpresa,
            EM.Telefono  TelefonoEmpresa,
            EM.Celular  CelularEmpresa,
            EM.Web WebEmpresa,
            EM.Correo CorreoEmpresa,
            EES.Direccion DireccionEmpresa,
            (SELECT [ERP].[ObtenerWebSiteComprobanteElectronico]()) WebSiteComprobante,
            EM.NumeroResolucion NumeroResolucionEmpresa,
            EM.Imagen ImagenEmpresa,
            ((SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](UE.ID)) +' - '+([PLAME].[ObtenerNombreProvincia_By_Distrito](UE.ID)) +' - '+UE.Nombre) AS DepartamentoProvinciaEmpresa,
            PT.Nombre + ' '+ISNULL(PT.ApellidoPaterno,'') NombreVendedor,
			VE.Inscripcion,
			GR.Observacion,
			GR.TotalPeso
    FROM ERP.GuiaRemision GR
    INNER JOIN PLE.T10TipoComprobante T10 ON T10.ID = GR.IdTipoComprobante
    INNER JOIN ERP.Entidad ENTGR ON ENTGR.ID = GR.IdEntidad
    LEFT JOIN ERP.Establecimiento ENTGRES ON ENTGRES.IdEntidad = ENTGR.ID  AND ENTGRES.IdTipoEstablecimiento = 1

    INNER JOIN EntidadTipoDocumento ETDGR ON ETDGR.IdEntidad = GR.IdEntidad
    INNER JOIN XML.T20MotivoTraslado T20 ON T20.ID = GR.IdMotivoTraslado
    INNER JOIN XML.T18ModalidadTraslado T18 ON T18.ID = GR.IdModalidadTraslado

    LEFT JOIN ERP.Vehiculo VE ON VE.ID = GR.IdVehiculo
        
    LEFT JOIN ERP.Transporte TRA ON TRA.ID = GR.IdTransporte
    LEFT JOIN ERP.Entidad ENTTRA ON ENTTRA.ID = TRA.IdEntidad
    LEFT JOIN ERP.EntidadTipoDocumento ETTRA ON ETTRA.IdEntidad = TRA.IdEntidad

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

	/*Ubigeos*/
	INNER JOIN PLAME.T7Ubigeo T7U ON T7U.ID = GR.IdUbigeoOrigen
	INNER JOIN PLAME.T7Ubigeo T7PR ON CONCAT('00', LEFT(T7U.CodigoSunat, 4)) = T7PR.CodigoSunat
	INNER JOIN PLAME.T7Ubigeo T7DE ON CONCAT('0000', LEFT(T7U.CodigoSunat, 2)) = T7DE.CodigoSunat

	INNER JOIN PLAME.T7Ubigeo T7U2 ON T7U2.ID = GR.IdUbigeoDestino
	INNER JOIN PLAME.T7Ubigeo T7PR2 ON CONCAT('00', LEFT(T7U2.CodigoSunat, 4)) = T7PR2.CodigoSunat
	INNER JOIN PLAME.T7Ubigeo T7DE2 ON CONCAT('0000', LEFT(T7U2.CodigoSunat, 2)) = T7DE2.CodigoSunat
	/********/

    WHERE GR.Serie = @Serie
    AND GR.Documento =  @Documento
END