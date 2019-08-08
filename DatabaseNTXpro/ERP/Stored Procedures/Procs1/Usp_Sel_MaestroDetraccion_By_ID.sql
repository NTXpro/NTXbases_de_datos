
	CREATE PROC [ERP].[Usp_Sel_MaestroDetraccion_By_ID]
	@IdDetraccion INT
	AS
	BEGIN
			SELECT DE.ID,
				   DE.Nombre,
				   DE.CodigoSunat,
				   DE.Porcentaje,
				   DE.FechaRegistro,
				   DE.FechaEliminado,
				   DE.FechaActivacion,
				   DE.FechaModificado,
				   DE.UsuarioRegistro,
				   DE.UsuarioModifico,
				   DE.UsuarioActivo,
				   DE.UsuarioElimino
			FROM Maestro.Detraccion DE
			WHERE DE.ID = @IdDetraccion

	END
