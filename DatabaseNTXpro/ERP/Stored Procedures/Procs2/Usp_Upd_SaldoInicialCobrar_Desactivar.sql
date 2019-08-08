CREATE PROC [ERP].[Usp_Upd_SaldoInicialCobrar_Desactivar]
@IdSaldo INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN
		UPDATE ERP.SaldoInicialCobrar SET Flag = 0 ,FechaEliminado=DATEADD(HOUR, 3, GETDATE()),UsuarioElimino = @UsuarioElimino  WHERE ID = @IdSaldo 

		UPDATE ERP.CuentaCobrar SET Flag = 0 WHERE ID IN (SELECT CP.ID FROM 
									ERP.SaldoInicialCobrar C
									INNER JOIN ERP.SaldoInicialCuentaCobrar CCP ON C.ID = CCP.IdSaldoInicialCobrar
									INNER JOIN ERP.CuentaCobrar CP ON CCP.IdCuentaCobrar = CP.ID
									WHERE C.ID = @IdSaldo)
END