CREATE PROC [ERP].[Usp_Upd_Proyecto_Desactivar]
@IdProyecto			INT,
@UsuarioElimino		VARCHAR(250)
AS
BEGIN
	UPDATE [ERP].[Proyecto] SET Flag = 0, FechaEliminado = DATEADD(HOUR, 3, GETDATE()),UsuarioElimino=@UsuarioElimino WHERE ID = @IdProyecto
END
