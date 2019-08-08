CREATE PROC [ERP].[Usp_Upd_Proyecto_Fin]
@IdProyecto INT,
@FechaFin DATETIME,
@Usuario VARCHAR(250)
AS
BEGIN

		UPDATE ERP.Proyecto SET FechaFin = @FechaFin , UsuarioModifico = @Usuario , FechaModificado = DATEADD(HOUR, 3, GETDATE())  WHERE ID = @IdProyecto
END
