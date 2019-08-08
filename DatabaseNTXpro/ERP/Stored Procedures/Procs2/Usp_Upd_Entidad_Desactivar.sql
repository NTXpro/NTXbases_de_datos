
CREATE PROC [ERP].[Usp_Upd_Entidad_Desactivar]
@IdEntidad			INT,
@UsuarioElimino		VARCHAR(250)
AS
BEGIN
	UPDATE ERP.Entidad SET Flag = 0, FechaEliminado = DATEADD(HOUR, 3, GETDATE()),UsuarioElimino=@UsuarioElimino WHERE ID = @IdEntidad
END
