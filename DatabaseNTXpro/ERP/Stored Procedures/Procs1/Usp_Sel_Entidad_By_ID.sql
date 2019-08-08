CREATE PROCEDURE [ERP].[Usp_Sel_Entidad_By_ID] 
@Id INT
AS
BEGIN

	SELECT E.ID																IdEntidad,
		   ETD.																IdTipoDocumento,
		   TD.Abreviatura													NombreTipoDocumento,
		   ETD.NumeroDocumento												NumeroDocumento,
		   P.ApellidoMaterno												ApellidoMaterno,
		   P.ApellidoPaterno												ApellidoPaterno,
		   P.Nombre															Nombre,
		   E.UsuarioRegistro												UsuarioRegistro,
		   E.UsuarioModifico												UsuarioModifico,
		   E.UsuarioElimino													UsuarioElimino,
		   E.UsuarioActivo													UsuarioActivo,
		   E.FechaModificado												FechaModificado,
		   E.FechaRegistro													FechaRegistro,
		   E.FechaEliminado													FechaEliminado,
		   E.FechaActivacion												FechaActivacion,
		   E.Nombre															NombreCompleto,									
		   E.IdTipoPersona													IdTipoPersona,
		   ISNULL(E.BuenContribuyente, 0)									BuenContribuyente,
		   ISNULL(ResolucionBuenContribuyente, '')							ResolucionBuenContribuyente,
		   TP.Nombre														NombreTipoPersona,
		   E.IdCondicionSunat												IdCondicionSunat,
		   CS.Nombre														NombreCondicionSunat,
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
		   ESTS.Direccion													Direccion2,
		   U.ID																IdDistrito,
		   U.Nombre															NombreDistrito,
		   EST.Sector,
		   EST.Grupo,
		   EST.Manzana,
		   EST.Lote,
		   EST.Kilometro,
		   EST.IdPais,

		   (SELECT [PLAME].[ObtenerIdProvincia_By_Distrito](U.ID))			IdProvincia,
		   (SELECT [PLAME].[ObtenerNombreProvincia_By_Distrito](U.ID))		NombreProvincia,
		   (SELECT [PLAME].[ObtenerIdDepartamento_By_Distrito](U.ID))		IdDepartamento,
		   (SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](U.ID))	NombreDepartamento,


		   (SELECT [PLAME].[ObtenerIdProvincia_By_Distrito](US.ID))			IdProvincia2,
		   (SELECT [PLAME].[ObtenerNombreProvincia_By_Distrito](US.ID))		NombreProvincia2,
		   (SELECT [PLAME].[ObtenerIdDepartamento_By_Distrito](US.ID))		IdDepartamento2,
		   (SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](US.ID))	NombreDepartamento2,

		   US.ID															IdDistrito2,
		   US.Nombre														NombreDistrito2,

		   VS.ID																IdTipoVia2,
		   VS.Nombre															NombreTipoVia2,

		   ZS.ID																IdZona2,
		   ZS.Nombre															NombreTipoZona2,

		   ESTS.ViaNombre													ViaNombre2,
		   ESTS.ViaNumero													ViaNumero2,
		   ESTS.Interior													Interior2,
		   ESTS.ZonaNombre													ZonaNombre2,
		   ESTS.Referencia													Referencia2,
		   ESTS.Sector														Sector2,
		   ESTS.Grupo														Grupo2,
		   ESTS.Manzana														Manzana2,
		   ESTS.Lote														Lote2,
		   ESTS.Kilometro													Kilometro2,
		   P.FechaNacimiento,
		   P.IdEstadoCivil,
		   ESC.Nombre	EstadoCivil,
		   PA.Nombre	Nacionalidad,
		   EST.ID IdEstablecimiento

	FROM ERP.Entidad E
	LEFT JOIN ERP.Persona P
		ON P.IdEntidad = E.ID
	LEFT JOIN Maestro.EstadoCivil ESC
		ON ESC.ID = P.IdEstadoCivil
	LEFT JOIN PLE.T35Paises PA
		ON PA.ID = P.IdPais
	LEFT JOIN ERP.Establecimiento EST
		ON EST.ID = (SELECT TOP 1 ID FROM ERP.Establecimiento WHERE IdEntidad = @Id ORDER BY 1 ASC)

	LEFT JOIN ERP.Establecimiento ESTS
		ON ESTS.IdEntidad = E.ID --AND ESTS.IdTipoEstablecimiento = 4
	
	LEFT JOIN PLAME.T7Ubigeo US
		ON US.ID = ESTS.IdUbigeo --AND ESTS.IdTipoEstablecimiento = 4

	LEFT JOIN PLAME.T2TipoEstablecimiento TE
		ON TE.ID = EST.IdTipoEstablecimiento

	LEFT JOIN PLAME.T5Via V
		ON V.ID = EST.IdVia

	LEFT JOIN PLAME.T5Via VS
		ON VS.ID = ESTS.IdVia


	LEFT JOIN PLAME.T6Zona Z
		ON Z.ID = EST.IdZona

	LEFT JOIN PLAME.T6Zona ZS
		ON ZS.ID = ESTS.IdZona

	LEFT JOIN PLAME.T7Ubigeo U
		ON U.ID = EST.IdUbigeo
	LEFT JOIN Maestro.CondicionSunat CS
		ON CS.ID = E.IdCondicionSunat
	LEFT JOIN Maestro.EstadoContribuyente EC
		ON EC.ID = E.IdEstadoContribuyente
	INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = E.ID
	INNER JOIN PLE.T2TipoDocumento TD
		ON TD.ID = ETD.IdTipoDocumento
	INNER JOIN Maestro.TipoPersona TP
		ON TP.ID = E.IdTipoPersona
	WHERE E.ID = @Id
END