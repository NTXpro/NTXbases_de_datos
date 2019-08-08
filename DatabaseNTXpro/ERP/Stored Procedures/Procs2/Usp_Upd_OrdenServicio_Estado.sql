
CREATE PROC [ERP].[Usp_Upd_OrdenServicio_Estado]
@IdOrdenServicio INT,
@IdEstado INT,
@IdEmpresa INT,
@ObservacionRechazo VARCHAR(MAX),
@UsuarioModifico VARCHAR(250)
AS
BEGIN
	UPDATE ERP.OrdenServicio SET	IdOrdenServicioEstado = @IdEstado , 
								ObservacionRechazado = @ObservacionRechazo,
								UsuarioModifico=@UsuarioModifico,
								FechaModificado = DATEADD(HOUR, 3, GETDATE())
		WHERE ID = @IdOrdenServicio AND IdEmpresa = @IdEmpresa	


END