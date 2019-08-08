CREATE PROC [ERP].[Usp_Upd_LetraCobrar]
@ID INT,
@FechaVencimiento DATETIME,
@Monto DECIMAL(14,5),
@UsuarioModifico VARCHAR(250)
AS
BEGIN
	DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());
	UPDATE ERP.LetraCobrar SET 
		FechaVencimiento = @FechaVencimiento,
		Monto = @Monto,
		UsuarioModifico = @UsuarioModifico,
		FechaModificado = @FechaActual
	WHERE ID = @ID

	UPDATE ERP.CuentaCobrar
		SET Total = @Monto,
			FechaVencimiento = @FechaVencimiento
	WHERE ID IN (SELECT IdCuentaCobrar FROM ERP.LetraCobrarCuentaCobrar WHERE IdLetraCobrar = @ID)

END
