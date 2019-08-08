CREATE PROC [ERP].[Usp_Upd_EstructuraTres_Flag]
@ID INT,
@UsuarioElimino VARCHAR(250),
@FechaEliminado DATETIME
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000
	
	/*UPDATE [ERP].[EstructuraTres] SET 
		Flag = 0,
		UsuarioElimino = @UsuarioElimino,
		FechaEliminado = @FechaEliminado
	WHERE ID = @ID

	UPDATE [ERP].[EstructuraCuatro] SET 
		Flag = 0,
		UsuarioElimino = @UsuarioElimino,
		FechaEliminado = @FechaEliminado
	WHERE IdEstructuraTres = @ID;*/

	DELETE FROM [ERP].[EstructuraCuatro] WHERE IdEstructuraTres = @ID;
	DELETE FROM [ERP].[EstructuraTres] WHERE ID = @ID;

	SELECT @ID;
END
