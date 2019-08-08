
CREATE PROC [ERP].[Usp_Upd_EliminarDetraccionByCompra]
@ID INT
AS
BEGIN

			DELETE ERP.CompraDetraccion WHERE IdCompra = @ID
			
			DECLARE @ID_CUENTA_PAGAR INT = (SELECT CP.ID FROM 
										ERP.COMPRA C
										INNER JOIN ERP.COMPRACUENTAPAGAR CCP ON C.ID = CCP.IdCompra
										INNER JOIN ERP.CUENTAPAGAR CP ON CCP.IdCuentaPagar = CP.ID
										WHERE CP.FlagDetraccion = 1
										AND C.ID = @ID);
			
			DECLARE @ID_COMPRA_CUENTA_PAGAR INT = (SELECT ID FROM
												   ERP.COMPRACUENTAPAGAR WHERE IdCompra = @ID
												   AND IdCuentaPagar = @ID_CUENTA_PAGAR);
			
			DELETE ERP.CompraCuentaPagar WHERE ID = @ID_COMPRA_CUENTA_PAGAR
			DELETE ERP.CuentaPagar WHERE ID = @ID_CUENTA_PAGAR
			
END
		
