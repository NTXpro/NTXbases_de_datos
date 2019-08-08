CREATE PROC [ERP].[Usp_Upd_Compra_Desactivar]
@IdCompra			INT,
@UsuarioElimino		VARCHAR(250)
AS
BEGIN
		UPDATE VA 
		SET VA.IdValeEstado = 1 /*REGISTRADO*/
		FROM ERP.Vale VA
		INNER JOIN ERP.CompraReferencia CR ON CR.IdReferencia = VA.ID
		WHERE CR.IdReferenciaOrigen = 5 AND CR.IdCompra = @IdCompra 

		UPDATE ERP.Compra 
		SET Flag = 0,
			FechaEliminado = DATEADD(HOUR, 3, GETDATE()),
			UsuarioElimino = @UsuarioElimino, 
			IdDetraccion = NULL
		WHERE ID = @IdCompra 

		DELETE ERP.CompraDetraccion WHERE IdCompra = @IdCompra

		DECLARE @ID_CUENTA_PAGAR_DETRACCION INT = 0
		DECLARE @ID_COMPRA_CUENTA_PAGAR_DETRACCION INT = 0
		DECLARE @ID_CUENTA_PAGAR INT = 0
		DECLARE @ID_COMPRA_CUENTA_PAGAR INT = 0

		SELECT @ID_CUENTA_PAGAR_DETRACCION = CP.ID, @ID_COMPRA_CUENTA_PAGAR_DETRACCION = CCP.ID
		FROM ERP.Compra C
		INNER JOIN ERP.CompraCuentaPagar CCP ON C.ID = CCP.IdCompra
		INNER JOIN ERP.CuentaPagar CP ON CCP.IdCuentaPagar = CP.ID
		WHERE CP.FlagDetraccion = 1
		AND C.ID = @IdCompra

		SELECT @ID_CUENTA_PAGAR = CP.ID, @ID_COMPRA_CUENTA_PAGAR= CCP.ID
		FROM ERP.Compra C
		INNER JOIN ERP.CompraCuentaPagar CCP ON C.ID = CCP.IdCompra
		INNER JOIN ERP.CuentaPagar CP ON CCP.IdCuentaPagar = CP.ID
		WHERE CP.FlagDetraccion = 0
		AND C.ID = @IdCompra			
		
		DELETE ERP.CompraCuentaPagar
		WHERE ID = @ID_COMPRA_CUENTA_PAGAR_DETRACCION

		DELETE ERP.CompraCuentaPagar
		WHERE ID = @ID_COMPRA_CUENTA_PAGAR

		UPDATE ERP.CuentaPagar
		SET Flag = 0 
		WHERE ID = @ID_CUENTA_PAGAR_DETRACCION

		UPDATE ERP.CuentaPagar
		SET Flag = 0 
		WHERE ID = @ID_CUENTA_PAGAR

		DECLARE @IdAsiento INT = (SELECT IdAsiento
									FROM ERP.Compra 
									WHERE ID = @IdCompra)

		EXEC ERP.Usp_Upd_AsientoContable_Compra_Anulado @IdAsiento
END