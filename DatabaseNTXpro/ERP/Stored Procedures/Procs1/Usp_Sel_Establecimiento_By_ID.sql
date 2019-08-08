
CREATE PROCEDURE [ERP].[Usp_Sel_Establecimiento_By_ID] --3795
@Id INT
AS
BEGIN

	SELECT EST.ID,
		   EST.IdEntidad,
		   EST.Nombre														NombreEstablecimiento,
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

		   EST.Sector														Sector,
		   EST.Grupo														Grupo,
		   EST.Manzana														Manzana,
		   EST.Lote															Lote,
		   EST.Kilometro													Kilometro,
		   EST.FlagSistema													FlagSistema,

		   EST.Referencia													Referencia,
		   EST.Direccion													Direccion,
		   U.ID																IdDistrito,
		   U.Nombre															NombreDistrito,

		   (SELECT [PLAME].[ObtenerIdProvincia_By_Distrito](U.ID))			IdProvincia,
		   (SELECT [PLAME].[ObtenerNombreProvincia_By_Distrito](U.ID))		NombreProvincia,
		   (SELECT [PLAME].[ObtenerIdDepartamento_By_Distrito](U.ID))		IdDepartamento,
		   (SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](U.ID))	NombreDepartamento,
		   EST.FechaRegistro,
		   EST.UsuarioRegistro,
		   EST.FechaModificado,
		   EST.UsuarioModifico,
		   EST.FechaEliminado,
		   EST.UsuarioElimino,
		   EST.FechaActivacion,
		   EST.UsuarioActivo,
		   EST.Telefono,
		   EST.Celular
	FROM  ERP.Establecimiento EST
	LEFT JOIN PLAME.T2TipoEstablecimiento TE
		ON TE.ID = EST.IdTipoEstablecimiento
	LEFT JOIN PLAME.T5Via V
		ON V.ID = EST.IdVia
	LEFT JOIN PLAME.T6Zona Z
		ON Z.ID = EST.IdZona
	LEFT JOIN PLAME.T7Ubigeo U
		ON U.ID = EST.IdUbigeo
	WHERE EST.ID = @Id
END
