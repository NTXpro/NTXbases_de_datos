CREATE PROCEDURE [ERP].[Usp_Sel_Entidad_By_Documento] --0,4,'20529000180'
@IdEmpresa INT,
@IdTipoDocumento INT,
@NumeroDocumento VARCHAR(20)
AS
BEGIN

	SELECT DISTINCT
		   E.ID																IdEntidad,
		   EMP.ID															IdEmpresa,
		   USU.ID															IdUsuario,
		   T.ID																IdTrabajador,
		   CH.ID															IdChofer,
		   CASE WHEN (SELECT COUNT(VE.ID) FROM ERP.Vendedor VE INNER JOIN ERP.Trabajador TR ON TR.ID = VE.IdTrabajador
		    WHERE VE.FlagBorrador = 0 AND TR.IdEntidad = E.ID) > 0 THEN
				(SELECT TOP 1 VE.ID FROM ERP.Vendedor VE INNER JOIN ERP.Trabajador TR ON TR.ID = VE.IdTrabajador
				WHERE VE.FlagBorrador = 0 AND TR.IdEntidad = E.ID)
		   ELSE
				VEND.ID
		   END																IdVendedor,
		   C.ID																IdCliente,
		   PROV.ID															IdProveedor,
		   BA.ID															IdBanco,
		   ETD.																IdTipoDocumento,
		   TD.Abreviatura													NombreTipoDocumento,
		   ETD.NumeroDocumento												NumeroDocumento,
		   P.ApellidoMaterno												ApellidoMaterno,
		   P.ApellidoPaterno												ApellidoPaterno,
		   P.Nombre															Nombre,
		   CASE WHEN E.IdTipoPersona = 1 THEN
			''
		   ELSE
			E.Nombre	
		   END																NombreCompleto,											
		   E.IdTipoPersona													IdTipoPersona,
		   E.IdCondicionSunat												IdCondicionSunat,
		   'HABIDO'															NombreCondicionSunat,
		   E.EstadoSunat													EstadoSunat,
		   E.IdEstadoContribuyente											IdEstadoContribuyente,
		   EC.Nombre														NombreEstadoContribuyente,
		   TE.ID															IdTipoEstablecimiento,
		   TE.Nombre														NombreTipoEstablecimiento,
		   V.ID																IdTipoVia,
		   V.Nombre															NombreTipoVia,
		   EST.ViaNombre													ViaNombre,
		   EST.ViaNumero													ViaNumero,
		   EST.Interior														Interior,
		   Z.ID																IdZona,
		   Z.Nombre															NombreTipoZona,
		   EST.ZonaNombre													ZonaNombre,
		   EST.Referencia													Referencia,
		   EST.Direccion													Direccion,
		   U.ID																IdDistrito,
		   U.Nombre															NombreDistrito,
		   (SELECT [PLAME].[ObtenerIdProvincia_By_Distrito](U.ID))			IdProvincia,
		   (SELECT [PLAME].[ObtenerNombreProvincia_By_Distrito](U.ID))		NombreProvincia,
		   (SELECT [PLAME].[ObtenerIdDepartamento_By_Distrito](U.ID))		IdDepartamento,
		   (SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](U.ID))	NombreDepartamento,
		   EST.Sector,
		   EST.Grupo,
		   EST.Manzana,
		   EST.Lote,
		   EST.Kilometro,
		   E.Flag,
		   E.FlagBorrador
	FROM ERP.Entidad E
	LEFT JOIN ERP.Empresa EMP
		ON EMP.IdEntidad = E.ID
	LEFT JOIN ERP.Proveedor PROV
		ON PROV.IdEntidad = E.ID AND PROV.IdEmpresa = @IdEmpresa
	LEFT JOIN Seguridad.Usuario USU
		ON USU.IdEntidad = E.ID 
	LEFT JOIN ERP.Trabajador T
		ON T.IdEntidad = E.ID AND T.IdEmpresa = @IdEmpresa
	LEFT JOIN ERP.Chofer CH
		ON CH.IdEntidad = E.ID AND CH.IdEmpresa = @IdEmpresa
	LEFT JOIN ERP.Vendedor VEND
		ON VEND.IdTrabajador = T.ID
	LEFT JOIN ERP.Cliente C
		ON C.IdEntidad = E.ID AND C.IdEmpresa = @IdEmpresa
	LEFT JOIN ERP.Persona P
		ON P.IdEntidad = E.ID
	LEFT JOIN [PLE].[T3Banco] BA
		ON BA.IdEntidad = E.ID
	LEFT JOIN ERP.Establecimiento EST
		ON EST.IdEntidad = E.ID
	LEFT JOIN PLAME.T2TipoEstablecimiento TE
		ON TE.ID = EST.IdTipoEstablecimiento
	LEFT JOIN PLAME.T5Via V
		ON V.ID = EST.IdVia
	LEFT JOIN PLAME.T6Zona Z
		ON Z.ID = EST.IdZona
	LEFT JOIN PLAME.T7Ubigeo U
		ON U.ID = EST.IdUbigeo
	LEFT JOIN Maestro.EstadoContribuyente EC
		ON EC.ID = E.IdEstadoContribuyente
	LEFT JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = E.ID
	LEFT JOIN PLE.T2TipoDocumento TD
		ON TD.ID = ETD.IdTipoDocumento
	WHERE ETD.NumeroDocumento = @NumeroDocumento 
	AND ETD.IdTipoDocumento = @IdTipoDocumento 
	AND ISNULL(EMP.FlagBorrador, 0) = 0
	AND ISNULL(PROV.FlagBorrador, 0) = 0
	AND ISNULL(USU.FlagBorrador, 0) = 0
	AND ISNULL(T.FlagBorrador, 0) = 0
	AND ISNULL(CH.FlagBorrador, 0) = 0
	AND ISNULL(VEND.FlagBorrador, 0) = 0
	AND ISNULL(C.FlagBorrador, 0) = 0
END
