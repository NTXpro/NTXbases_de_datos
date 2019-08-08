
CREATE PROC [ERP].[Usp_Sel_Transporte_By_ID]
@IdTransporte INT
AS
BEGIN

	SELECT TR.ID						ID,
		   TR.IdEntidad				IdEntidad,
		   EN.Nombre				Nombre,
		   ETD.NumeroDocumento		NumeroDocumento,
		   TD.Nombre				NombreTipoDocumento,
		   TD.CodigoSunat			CodigoSunatTipoDocumento,
		   TR.FechaRegistro,
		   TR.FechaModificado,
		   TR.FechaEliminado,
		   TR.FechaActivacion,
		   TR.UsuarioRegistro,
		   TR.UsuarioModifico,
		   TR.UsuarioElimino,
		   TR.UsuarioActivo
	FROM ERP.Transporte TR 
	INNER JOIN ERP.Entidad EN
		ON EN.ID = TR.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = EN.ID
	INNER JOIN PLE.T2TipoDocumento TD
		ON TD.ID = ETD.IdTipoDocumento
	WHERE TR.ID = @IdTransporte
END
