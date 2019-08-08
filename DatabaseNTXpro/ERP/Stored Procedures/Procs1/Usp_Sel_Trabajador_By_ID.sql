CREATE PROC [ERP].[Usp_Sel_Trabajador_By_ID] --1
@ID INT
AS
BEGIN

	DECLARE @ID_SECUNDARIO INT = (SELECT TOP 1 ES.ID
									FROM ERP.Trabajador T
									INNER JOIN ERP.Entidad E ON T.IdEntidad = E.ID
									INNER JOIN ERP.Establecimiento ES ON E.ID = ES.IdEntidad
									WHERE T.ID = @ID AND ES.IdTipoEstablecimiento != 1
									ORDER BY ES.ID)

	SELECT
		T.ID,
		T.IdEntidad,
		T.IdEmpresa,
		T.NombreImagen,
		T.Imagen,
		T.UsuarioRegistro,
		T.FechaRegistro,
		T.UsuarioModifico,
		T.FechaModificado,
		T.UsuarioElimino,
		T.FechaEliminado,
		T.UsuarioActivo,
		T.FechaActivacion,
		T.FlagBorrador,
		T.Flag,
		P.ID AS IdPersona,
		P.IdSexo,
		P.ApellidoPaterno,
		P.ApellidoMaterno,
		P.Nombre,
		P.FechaNacimiento,
		P.IdPais,
		P.IdEstadoCivil,
		P.IdCentroAsistencial,
		E.IdTipoPersona,
		E.Nombre AS NombreEntidad,
		E.IdCondicionSunat,
		E.EstadoSunat,
		E.IdEstadoContribuyente,
		TP.Nombre AS NombreTipoPersona,
		TP.Abreviatura AS AbreviaturaTipoPersona,
		ETD.ID AS IdEntidadTipoDocumento,
		ETD.NumeroDocumento,
		ETD.IdTipoDocumento,
		TD.ID AS IdTipoDocumento,
		TD.Nombre AS NombreTipoDocumento,
		TD.Abreviatura AS AbreviaturaTipoDocumento,
		NE.ID AS IdNivelEducativo,
		NE.Nombre AS NombreNivelEducativo,
		S.Nombre AS NombreSexo,
		EC.Nombre AS NombreEstadoCivil,

		ES.ID AS IdEstablecimientoPrincipal,
		ES.IdVia AS IdViaPrincipal,
		ES.ViaNombre AS ViaNombrePrincipal,
		ES.ViaNumero AS ViaNumeroPrincipal,
		ES.Interior AS InteriorPrincipal,
		ES.Sector AS SectorPrincipal,
		ES.Grupo AS GrupoPrincipal,
		ES.Manzana AS ManzanaPrincipal,
		ES.Lote AS LotePrincipal,
		ES.Kilometro AS KilometroPrincipal,
		ES.IdZona AS IdZonaPrincipal,
		ES.ZonaNombre AS ZonaNombrePrincipal,
		ES.Referencia AS ReferenciaPrincipal,
		ES.Direccion AS DireccionPrincipal,
		ES.IdUbigeo AS IdUbigeoPrincipal,		
		U2.ID AS IdProvinciaPrincipal,	
		U3.ID AS IdDepartamentoPrincipal,
		U1.Nombre AS NombreDistritoPrincipal,
		U2.Nombre AS NombreProvinciaPrincipal,
		U3.Nombre AS NombreDepartamentoPrincipal,

		ES_2.ID AS IdEstablecimientoSecundario,
		ES_2.IdVia AS IdViaSecundario,
		ES_2.ViaNombre AS ViaNombreSecundario,
		ES_2.ViaNumero AS ViaNumeroSecundario,
		ES_2.Interior AS InteriorSecundario,
		ES_2.Sector AS SectorSecundario,
		ES_2.Grupo AS GrupoSecundario,
		ES_2.Manzana AS ManzanaSecundario,
		ES_2.Lote AS LoteSecundario,
		ES_2.Kilometro AS KilometroSecundario,
		ES_2.IdZona AS IdZonaSecundario,
		ES_2.ZonaNombre AS ZonaNombreSecundario,
		ES_2.Referencia AS ReferenciaSecundario,
		ES_2.Direccion AS DireccionSecundario,
		ES_2.IdUbigeo AS IdUbigeoSecundario,
		U2_2.ID AS IdProvinciaSecundario,
		U3_2.ID AS IdDepartamentoSecundario,		
		U1_2.Nombre AS NombreDistritoSecundario,
		U2_2.Nombre AS NombreProvinciaSecundario,
		U3_2.Nombre AS NombreDepartamentoSecundario,
		PS.Nombre NombrePais
	FROM ERP.Trabajador T
	INNER JOIN ERP.Entidad E ON E.ID = T.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento ETD ON E.ID = ETD.IdEntidad
	INNER JOIN PLE.T2TipoDocumento TD ON ETD.IdTipoDocumento = TD.ID
	INNER JOIN Maestro.TipoPersona TP ON E.IdTipoPersona = TP.ID
	LEFT JOIN ERP.Persona P ON E.ID = P.IdEntidad
	LEFT JOIN Maestro.EstadoCivil EC ON P.IdEstadoCivil = EC.ID
	LEFT JOIN Maestro.Sexo S ON P.IdSexo = S.ID
	LEFT JOIN [PLAME].[T9NivelEducativo] NE ON P.IdNivelEducativo = NE.ID

	INNER JOIN ERP.Establecimiento ES ON E.ID = ES.IdEntidad AND ES.IdTipoEstablecimiento = 1
	LEFT JOIN PLE.T35Paises PS ON PS.ID = ES.IdPais
	LEFT JOIN [PLAME].[T7Ubigeo] U1 ON ES.IdUbigeo = U1.ID
	LEFT JOIN [PLAME].[T7Ubigeo] U2 ON CONCAT('00', SUBSTRING(U1.CodigoSunat, 1,4)) = U2.CodigoSunat
	LEFT JOIN [PLAME].[T7Ubigeo] U3 ON CONCAT('0000', SUBSTRING(U1.CodigoSunat, 1,2)) = U3.CodigoSunat

	LEFT JOIN ERP.Establecimiento ES_2 ON E.ID = ES_2.IdEntidad AND ES_2.ID = @ID_SECUNDARIO
	LEFT JOIN [PLAME].[T7Ubigeo] U1_2 ON ES_2.IdUbigeo = U1_2.ID
	LEFT JOIN [PLAME].[T7Ubigeo] U2_2 ON CONCAT('00', SUBSTRING(U1_2.CodigoSunat, 1,4)) = U2_2.CodigoSunat
	LEFT JOIN [PLAME].[T7Ubigeo] U3_2 ON CONCAT('0000', SUBSTRING(U1_2.CodigoSunat, 1,2)) = U3_2.CodigoSunat

	WHERE T.ID = @ID


END
