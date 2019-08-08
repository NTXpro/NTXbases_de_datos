CREATE PROC [ERP].[Usp_Upd_Cerrar_Proyecto]
@IdProyecto INT,
@Usuario VARCHAR(250)
AS
BEGIN

		UPDATE ERP.Proyecto SET FlagCierre = 1 ,UsuarioModifico = @Usuario , FechaModificado = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdProyecto
END
