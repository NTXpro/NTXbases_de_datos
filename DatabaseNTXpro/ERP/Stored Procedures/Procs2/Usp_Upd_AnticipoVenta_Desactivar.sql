create PROC [ERP].[Usp_Upd_AnticipoVenta_Desactivar]
@ID INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN

			UPDATE ERP.AnticipoVenta SET Flag = 0,UsuarioElimino =@UsuarioElimino , FechaActivacion = DATEADD(HOUR, 3, GETDATE())  WHERE ID = @ID

			UPDATE ERP.CuentaCobrar SET Flag = 0  WHERE ID = (SELECT IdCuentaCobrar FROM ERP.AnticipoVentaCuentaCobrar WHERE IdAnticipo = @ID)

END
