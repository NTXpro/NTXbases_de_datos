
CREATE PROC [ERP].[Usp_Sel_UnidadMedida_By_ID]
@ID int
AS
BEGIN
SELECT	
		   UM.ID								ID,
		   UM.Nombre							Nombre,
		   UM.CodigoSunat						NombreCodigoSunat,
		   UM.FechaRegistro,
		   UM.FechaEliminado,
		   UM.FechaModificado,
		   UM.FechaActivacion,
		   UM.UsuarioRegistro,
		   UM.UsuarioElimino,
		   UM.UsuarioModifico,
		   UM.UsuarioActivo
	FROM [PLE].[T6UnidadMedida] UM
	WHERE UM.ID = @ID
END
