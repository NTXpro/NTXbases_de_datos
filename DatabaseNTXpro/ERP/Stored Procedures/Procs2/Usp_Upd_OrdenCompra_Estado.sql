CREATE PROC [ERP].[Usp_Upd_OrdenCompra_Estado]
@IdOrdenCompra INT,
@IdEstado INT,
@IdEmpresa INT,
@ObservacionRechazo VARCHAR(MAX),
@UsuarioModifico VARCHAR(250),
@UsuarioActivo Varchar (250)
AS
BEGIN
	UPDATE ERP.OrdenCompra SET	IdOrdenCompraEstado = @IdEstado , 
								ObservacionRechazado = @ObservacionRechazo,
								UsuarioModifico=@UsuarioModifico,
								FechaModificado = DATEADD(HOUR, 3, GETDATE())
		WHERE ID = @IdOrdenCompra AND IdEmpresa = @IdEmpresa	


END