CREATE PROC [ERP].[Usp_Sel_Propiedad_By_ID]  --14
@ID int
AS
BEGIN

	SELECT	PR.ID											ID,
			UM.ID											IdUnidadMedida,
			PR.Nombre										NombrePropiedad,
			UM.Nombre										NombreUnidadMedida,
			UM.CodigoSunat									CodigoSunat,
			   PR.FechaRegistro,
			   PR.FechaEliminado,
			   PR.FechaModificado,
			   PR.FechaActivacion,
			   PR.UsuarioRegistro,
			   PR.UsuarioModifico,
			   PR.UsuarioElimino,
			   PR.UsuarioActivo
			
	FROM [Maestro].[Propiedad] PR
	LEFT JOIN [PLE].[T6UnidadMedida] UM
	ON UM.ID = PR.IdUnidadMedida
	WHERE PR.ID = @ID
END
