CREATE PROC [ERP].[Usp_Upd_Requerimiento_Estado]
@IdRequerimiento INT,
@IdEstado INT,
@IdEmpresa INT,
@ObservacionRechazo VARCHAR(MAX),
@UsuarioModifico VARCHAR(250)
AS
BEGIN
		UPDATE ERP.Requerimiento SET IdRequerimientoEstado = @IdEstado , 
									 ObservacionRechazado = @ObservacionRechazo,
									 UsuarioModifico=@UsuarioModifico,
									 FechaModificado = DATEADD(HOUR, 3, GETDATE())
		WHERE ID = @IdRequerimiento AND IdEmpresa = @IdEmpresa
END
