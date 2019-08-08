
CREATE PROC [ERP].[Usp_Sel_Empresa_Principal]
AS
BEGIN

	SELECT TOP 1 E.ID						ID,
			   E.IdEntidad				IdEntidad,
			   EN.Nombre				Nombre,
			   ETD.NumeroDocumento		NumeroDocumento,
			   TD.Nombre				NombreTipoDocumento,
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
			   E.Imagen
	FROM ERP.Empresa E 
	INNER JOIN ERP.Entidad EN
		ON EN.ID = E.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = EN.ID
	INNER JOIN PLE.T2TipoDocumento TD
		ON TD.ID = ETD.IdTipoDocumento
	LEFT JOIN PLAME.T1TipoActividad TA
		ON TA.ID = E.IdTipoActividad
END

