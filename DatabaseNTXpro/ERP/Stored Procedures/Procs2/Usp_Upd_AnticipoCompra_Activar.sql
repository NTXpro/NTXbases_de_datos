
create PROC [ERP].[Usp_Upd_AnticipoCompra_Activar]
@ID INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN

			UPDATE ERP.AnticipoCompra SET Flag = 1,UsuarioActivo =@UsuarioActivo , FechaActivacion = DATEADD(HOUR, 3, GETDATE())  WHERE ID = @ID

			UPDATE ERP.CuentaPagar SET Flag = 1  WHERE ID = (SELECT IdCuentaPagar FROM ERP.AnticipoCompraCuentaPagar WHERE IdAnticipo = @ID)

END
