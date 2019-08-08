CREATE PROC [ERP].[Usp_Upd_Gasto_Desactivar]
@ID INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN

			UPDATE ERP.Gasto SET Flag = 0,UsuarioElimino =@UsuarioElimino , FechaEliminado = DATEADD(HOUR, 3, GETDATE())  WHERE ID = @ID
			UPDATE ERP.CuentaPagar SET Flag = 0  WHERE ID = (SELECT IdCuentaPagar FROM ERP.GastoCuentaPagar WHERE IdGasto = @ID)

END
