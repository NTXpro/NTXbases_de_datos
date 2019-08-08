

CREATE PROC [ERP].[Usp_Upd_LetraPagar]
@ID INT,
@FechaVencimiento DATETIME,
@Monto DECIMAL(14,5),
@UsuarioModifico VARCHAR(250)
AS
BEGIN
	DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());
	UPDATE ERP.LetraPagar SET 
		FechaVencimiento = @FechaVencimiento,
		Monto = @Monto,
		UsuarioModifico = @UsuarioModifico,
		FechaModificado = @FechaActual
	WHERE ID = @ID

	UPDATE ERP.CuentaPagar
		SET Total = @Monto,
			FechaVencimiento = @FechaVencimiento
	WHERE ID IN (SELECT IdCuentaPagar FROM ERP.LetraPagarCuentaPagar WHERE IdLetraPagar = @ID)
END
