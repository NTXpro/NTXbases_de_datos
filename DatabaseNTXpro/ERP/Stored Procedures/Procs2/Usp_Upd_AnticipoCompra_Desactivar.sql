create PROC [ERP].[Usp_Upd_AnticipoCompra_Desactivar]
@ID INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN

			UPDATE ERP.AnticipoCompra SET Flag = 0,UsuarioElimino =@UsuarioElimino , FechaActivacion = DATEADD(HOUR, 3, GETDATE())  WHERE ID = @ID

			UPDATE ERP.CuentaPagar SET Flag = 0  WHERE ID = (SELECT IdCuentaPagar FROM ERP.AnticipoCompraCuentaPagar WHERE IdAnticipo = @ID)

END
