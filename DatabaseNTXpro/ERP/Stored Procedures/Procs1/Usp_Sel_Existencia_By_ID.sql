

CREATE PROC [ERP].[Usp_Sel_Existencia_By_ID]
@ID int
AS
BEGIN
SELECT	   EX.ID					ID,
		   EX.Nombre				Nombre,
		   EX.CodigoSunat			CodigoSunat,
		   EX.FechaRegistro,
		   UsuarioRegistro,
		   FechaModificado,
		   UsuarioModifico,
		   FechaEliminado,
		   UsuarioElimino,
		   FechaActivacion,
		   UsuarioActivo
	FROM [PLE].[T5Existencia] EX
	WHERE EX.ID = @ID
END
