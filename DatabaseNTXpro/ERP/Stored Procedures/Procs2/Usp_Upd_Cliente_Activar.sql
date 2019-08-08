

CREATE PROC [ERP].[Usp_Upd_Cliente_Activar]
@IdCliente			INT,
@UsuarioActivo		VARCHAR(250)
AS
BEGIN
	UPDATE ERP.Cliente SET Flag = 1 ,UsuarioActivo=@UsuarioActivo ,FechaActivacion= DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdCliente
END
