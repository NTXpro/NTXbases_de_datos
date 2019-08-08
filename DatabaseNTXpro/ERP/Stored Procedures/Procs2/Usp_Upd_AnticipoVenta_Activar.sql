
CREATE PROC [ERP].[Usp_Upd_AnticipoVenta_Activar]
@ID INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN

			UPDATE ERP.AnticipoVenta SET Flag = 1,UsuarioActivo =@UsuarioActivo , FechaActivacion = DATEADD(HOUR, 3, GETDATE())  WHERE ID = @ID

			UPDATE ERP.CuentaCobrar SET Flag = 1  WHERE ID = (SELECT IdCuentaCobrar FROM ERP.AnticipoVentaCuentaCobrar WHERE IdAnticipo = @ID)

END
