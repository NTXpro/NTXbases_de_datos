CREATE PROC [ERP].[Usp_Upd_Vendedor_Desactivar]
@IdVendedor INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN

	UPDATE ERP.Vendedor SET Flag = 0 , UsuarioElimino=@UsuarioElimino , FechaEliminado = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdVendedor

END