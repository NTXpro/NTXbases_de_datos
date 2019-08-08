
CREATE PROC [ERP].[Usp_Sel_Empresa_By_ID]
@ID int
AS
BEGIN

	SELECT E.ID						ID,
		   E.IdEntidad				IdEntidad,
		   EN.Nombre				Nombre,
		   ETD.NumeroDocumento		NumeroDocumento,
		   TD.Abreviatura			NombreTipoDocumento,
		   TD.CodigoSunat			CodigoSunatTipoDocumento,
		   TA.ID					IdTipoActividad,
		   TA.Nombre				NombreTipoActividad,
		   E.FechaRegistro,
		   E.FechaModificado,
		   E.FechaEliminado,
		   E.FechaActivacion,
		   E.UsuarioRegistro,
		   E.UsuarioModifico,
		   E.UsuarioElimino,
		   E.UsuarioActivo,
		   E.NombreImagen,
		   E.Imagen,
		   E.NumeroResolucion,
		   E.Correo,
		   E.Web,
		   E.Telefono,
		   E.Celular,
		   FlagPrincipal,
		   E.FlagPlantillaEmpresa
	FROM ERP.Empresa E 
	INNER JOIN ERP.Entidad EN
		ON EN.ID = E.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = EN.ID
	INNER JOIN PLE.T2TipoDocumento TD
		ON TD.ID = ETD.IdTipoDocumento
	LEFT JOIN PLAME.T1TipoActividad TA
		ON TA.ID = E.IdTipoActividad
	WHERE E.ID = @ID

END
