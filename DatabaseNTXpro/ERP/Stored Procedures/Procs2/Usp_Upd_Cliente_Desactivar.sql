CREATE PROC [ERP].[Usp_Upd_Cliente_Desactivar]
@IdCliente			INT,
@UsuarioElimino    VARCHAR(250)
AS
BEGIN
	UPDATE ERP.Cliente SET Flag = 0 , FechaEliminado = DATEADD(HOUR, 3, GETDATE()) ,UsuarioElimino=@UsuarioElimino WHERE ID = @IdCliente
END
