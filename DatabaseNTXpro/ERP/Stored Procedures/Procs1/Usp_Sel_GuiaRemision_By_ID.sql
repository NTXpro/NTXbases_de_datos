CREATE PROC [ERP].[Usp_Sel_GuiaRemision_By_ID] 
@IdGuiaRemision INT
AS
BEGIN
		SELECT GR.ID,
			   GR.IdMoneda,
			   GR.IdTipoComprobante,
			   GR.IdEmpresa,
			   GR.IdEntidad,
			   GR.IdGuiaRemisionEstado,
			   GR.IdEstablecimiento,
			   GR.IdChofer,
			   GR.IdTransporte,
			   GR.IdVehiculo,
			   GR.IdAlmacen,
			   GR.IdMotivoTraslado,
			   GR.IdVale,
			   GR.IdModalidadTraslado,
			   GR.IdTipoMovimiento,
			   GR.TipoCambio,
			   GR.Fecha,
			   GR.Serie,
			   GR.EstablecimientoOrigen,
			   GR.EstablecimientoDestino,
			   GR.Documento,
			   GR.PorcentajeIGV,
			   GR.SubTotal,
			   GR.IGV,
			   GR.Total,
			   GR.RutaDocumentoXML,
			   GR.RutaDocumentoPDF,
			   GR.Flag,
			   GR.FlagGuiaElectronico,
			   GR.IdUbigeoOrigen,
			   GR.IdUbigeoDestino,
			   GR.CodigoPuerto,
			   GR.NumeroContenedor,
			   GR.FlagBorrador,
			   GR.UsuarioRegistro,
			   GR.UsuarioModifico,
			   GR.FechaRegistro,
			   GR.FechaModificado,
			   GR.Observacion,
			   GR.TotalPeso,
			   GR.FlagValidarStock,
			   GR.IdListaPrecio,
			   VE.Marca,
			   VE.Placa,
			   VE.Modelo,
			   VE.Color,
			   ENT.Nombre NombreCompleto,
			   ENTR.Nombre Transporte,
			   ENTCH.Nombre Chofer,
			   ETDCH.NumeroDocumento NumeroDocumentoChofer,
			   TDCH.CodigoSunat CodigoTipoDocumentoChofer,
			   TP.Nombre  TipoPersona,
			   ETD.NumeroDocumento,
			   TD.Abreviatura NombreTipoDocumento,
			   TD.ID IdTipoDocumento,
			   TD.CodigoSunat CodigoTipoDocumentoEntidad,
			   AL.Nombre Almacen,
			   EST.Direccion Establecimiento,
			   MN.CodigoSunat Moneda,
			   TC.Nombre NombreTipoComprobante,
			   TC.CodigoSunat CodigoTipoComprobante,
			   ENTEMP.Nombre NombreEmpresa,
			   ETDEMP.NumeroDocumento NumeroDocumentoEmpresa,
			   TDEMP.CodigoSunat CodigoTipoDocumentoEmpresa,
			   MT.CodigoSunat CodigoMotivoTraslado,
			   MT.Nombre NombreMotivoTraslado,
			   UM.CodigoSunat UnidadMedidaPeso,
			   MTR.CodigoSunat CodigoModalidadTraslado,
			   TUO.CodigoSunat CodigoUbigeoOrigen,
			   TUD.CodigoSunat CodigoUbigeoDestino,
			   CLI.Correo,

			   (SELECT [PLAME].[ObtenerIdProvincia_By_Distrito](TUO.ID))			IdProvincia,
			   (SELECT [PLAME].[ObtenerNombreProvincia_By_Distrito](TUO.ID))		NombreProvincia,
			   (SELECT [PLAME].[ObtenerIdDepartamento_By_Distrito](TUO.ID))		IdDepartamento,
			   (SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](TUO.ID))	NombreDepartamento,


			   (SELECT [PLAME].[ObtenerIdProvincia_By_Distrito](TUD.ID))			IdProvincia2,
			   (SELECT [PLAME].[ObtenerNombreProvincia_By_Distrito](TUD.ID))		NombreProvincia2,
			   (SELECT [PLAME].[ObtenerIdDepartamento_By_Distrito](TUD.ID))		IdDepartamento2,
			   (SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](TUD.ID))	NombreDepartamento2,

			    TUD.ID															IdDistrito2,
				TUD.Nombre														NombreDistrito2,

				TUO.ID																IdDistrito,
				TUO.Nombre															NombreDistrito,
				MT.IdTipoOperacion IdConcepto,
				V.ID IdVendedor,
				ET.Nombre NombreVendedor
		FROM ERP.GuiaRemision GR
		LEFT JOIN ERP.Almacen AL ON AL.ID = GR.IdAlmacen
		LEFT JOIN Maestro.Moneda MN ON MN.ID = GR.IdMoneda
		LEFT JOIN ERP.Establecimiento EST ON EST.ID = GR.IdEstablecimiento
		LEFT JOIN ERP.Entidad ENT ON ENT.ID = GR.IdEntidad
		LEFT JOIN ERP.Cliente CLI ON CLI.IdEntidad = ENT.ID
		LEFT JOIN Maestro.TipoPersona TP ON TP.ID = ENT.IdTipoPersona
		LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = ENT.ID
		LEFT JOIN PLE.T2TipoDocumento TD ON TD.ID = ETD.IdTipoDocumento
		LEFT JOIN Maestro.Moneda MO ON MO.ID = GR.IdMoneda
		LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = GR.IdTipoComprobante
		LEFT JOIN ERP.Chofer CH ON CH.ID = GR.IdChofer
		LEFT JOIN ERP.Entidad ENTCH ON ENTCH.ID = CH.IdEntidad
		LEFT JOIN ERP.EntidadTipoDocumento ETDCH ON ETDCH.IdEntidad = ENTCH.ID
		LEFT JOIN PLE.T2TipoDocumento TDCH ON TDCH.ID = ETDCH.IdTipoDocumento
		LEFT JOIN ERP.Transporte TR ON TR.ID = GR.IdTransporte
		LEFT JOIN ERP.Entidad ENTR ON ENTR.ID = TR.IdEntidad
		LEFT JOIN ERP.Vehiculo VE ON VE.ID = GR.IdVehiculo
		LEFT JOIN ERP.Empresa EMP ON EMP.ID = GR.IdEmpresa
		LEFT JOIN ERP.Entidad ENTEMP ON ENTEMP.ID = EMP.IdEntidad
		LEFT JOIN ERP.EntidadTipoDocumento ETDEMP ON ETDEMP.IdEntidad = ENTEMP.ID
		LEFT JOIN PLE.T2TipoDocumento TDEMP ON TDEMP.ID = ETDEMP.IdTipoDocumento
		LEFT JOIN [XML].T20MotivoTraslado MT ON MT.ID = GR.IdMotivoTraslado
		LEFT JOIN [XML].T18ModalidadTraslado MTR ON MTR.ID = GR.IdModalidadTraslado
		LEFT JOIN [PLE].[T6UnidadMedida] UM ON UM.ID = GR.IdUnidadMedida
		LEFT JOIN [PLAME].[T7Ubigeo] TUO ON TUO.ID = GR.IdUbigeoOrigen
		LEFT JOIN [PLAME].[T7Ubigeo] TUD ON TUD.ID = GR.IdUbigeoDestino 
		LEFT JOIN ERP.Vendedor V ON V.ID = GR.IdVendedor
		LEFT JOIN ERP.Trabajador T ON T.ID = V.IdTrabajador
		LEFT JOIN ERP.Entidad ET ON ET.ID = T.IdEntidad
		WHERE GR.ID = @IdGuiaRemision
END
