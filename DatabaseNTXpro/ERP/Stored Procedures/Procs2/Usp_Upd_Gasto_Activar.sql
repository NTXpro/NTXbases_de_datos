CREATE PROC [ERP].[Usp_Upd_Gasto_Activar]
@ID INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN

			UPDATE ERP.Gasto SET Flag = 1,UsuarioActivo =@UsuarioActivo , FechaActivacion = DATEADD(HOUR, 3, GETDATE())  WHERE ID = @ID

			UPDATE ERP.CuentaPagar SET Flag = 1  WHERE ID = (SELECT IdCuentaPagar FROM ERP.GastoCuentaPagar WHERE IdGasto = @ID)

END
