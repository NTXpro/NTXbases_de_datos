CREATE PROC [ERP].[Usp_Upd_Compra_Activar]
@IdCompra		INT,
@UsuarioActivo			VARCHAR(250)
AS
BEGIN
	UPDATE ERP.Compra SET Flag = 1 ,FechaActivacion=DATEADD(HOUR, 3, GETDATE()),UsuarioActivo = @UsuarioActivo  WHERE ID = @IdCompra 

	DECLARE @ID_CUENTA_PAGAR_DETRACCION INT = (SELECT CP.ID FROM 
									ERP.COMPRA C
									INNER JOIN ERP.COMPRACUENTAPAGAR CCP ON C.ID = CCP.IdCompra
									INNER JOIN ERP.CUENTAPAGAR CP ON CCP.IdCuentaPagar = CP.ID
									WHERE CP.FlagDetraccion = 1 AND C.ID = @IdCompra);

		DECLARE @ID_CUENTA_PAGAR INT = (SELECT CP.ID FROM 
									ERP.COMPRA C
									INNER JOIN ERP.COMPRACUENTAPAGAR CCP ON C.ID = CCP.IdCompra
									INNER JOIN ERP.CUENTAPAGAR CP ON CCP.IdCuentaPagar = CP.ID
									WHERE CP.FlagDetraccion = 0 AND C.ID = @IdCompra);

		DECLARE @ID_COMPRA_CUENTA_PAGAR_DETRACCION INT = (SELECT ID FROM
											   ERP.COMPRACUENTAPAGAR WHERE IdCompra = @IdCompra
											   AND IdCuentaPagar = @ID_CUENTA_PAGAR_DETRACCION);

		DECLARE @ID_COMPRA_CUENTA_PAGAR INT = (SELECT ID FROM
											   ERP.COMPRACUENTAPAGAR WHERE IdCompra = @IdCompra
											   AND IdCuentaPagar = @ID_CUENTA_PAGAR);
		
		UPDATE ERP.CuentaPagar SET Flag = 1 WHERE ID = @ID_CUENTA_PAGAR
		UPDATE ERP.CuentaPagar SET Flag = 1 WHERE ID = @ID_COMPRA_CUENTA_PAGAR_DETRACCION

		DECLARE @IdAsiento INT = (SELECT IdAsiento	FROM ERP.Compra WHERE ID = @IdCompra)

		UPDATE ERP.Asiento SET Flag = 1 WHERE ID = @IdAsiento

		EXEC ERP.Usp_Ins_AsientoContable_Compra_Reprocesar @IdAsiento,@IdCompra,5,4
END
