CREATE PROC [ERP].[Usp_Sel_Banco_By_ID] 
@ID int
AS
BEGIN

	SELECT	B.ID,
			B.UsuarioRegistro,
			B.UsuarioModifico,
			B.UsuarioElimino,
			B.UsuarioActivo,
			B.FechaActivacion,
			B.FechaEliminado,
			B.FechaModificado,
			EC.FechaRegistro,
			B.CodigoSunat   CodigoSunat,
			ETD.IdTipoDocumento,
			ETD.NumeroDocumento,
			EC.Nombre NombreBanco,
			E.Direccion,
			B.IdEntidad,
			FlagSunat
	FROM [PLE].[T3Banco] B
	LEFT JOIN ERP.Entidad EC
		ON EC.ID = B.IdEntidad
	LEFT JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = EC.ID
	LEFT JOIN ERP.Establecimiento E
		ON E.IdEntidad = EC.ID
	WHERE B.ID = @ID
END