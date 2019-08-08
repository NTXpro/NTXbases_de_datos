CREATE PROC [ERP].[Usp_Upd_Vendedor_Activar]
@IdVendedor INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN

	UPDATE ERP.Vendedor SET Flag = 1,UsuarioActivo=@UsuarioActivo,FechaActivacion=DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdVendedor

END