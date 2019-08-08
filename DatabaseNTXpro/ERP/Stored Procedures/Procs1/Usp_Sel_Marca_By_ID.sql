CREATE PROC [ERP].[Usp_Sel_Marca_By_ID]
@ID int
AS
BEGIN
SELECT	   MA.ID,
		   MA.Nombre,
		   MA.FechaRegistro,
		   MA.FechaEliminado,
		   FechaModificado,
		   FechaActivacion,
		   UsuarioRegistro,
		   UsuarioModifico,
		   UsuarioElimino,
		   UsuarioActivo
	FROM Maestro.Marca MA
	WHERE MA.ID = @ID
END
