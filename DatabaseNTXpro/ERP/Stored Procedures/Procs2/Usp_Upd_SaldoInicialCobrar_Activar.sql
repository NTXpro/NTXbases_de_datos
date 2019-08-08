CREATE PROC [ERP].[Usp_Upd_SaldoInicialCobrar_Activar]
@IdSaldo INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN
	UPDATE ERP.SaldoInicialCobrar SET Flag = 1 ,FechaActivacion=DATEADD(HOUR, 3, GETDATE()),UsuarioActivo = @UsuarioActivo  WHERE ID = @IdSaldo 


		UPDATE ERP.CuentaCobrar SET Flag = 1 WHERE ID IN (SELECT CP.ID FROM 
									ERP.SaldoInicialCobrar C
									INNER JOIN ERP.SaldoInicialCuentaCobrar CCP ON C.ID = CCP.IdSaldoInicialCobrar
									INNER JOIN ERP.CuentaCobrar CP ON CCP.IdCuentaCobrar = CP.ID
									WHERE C.ID = @IdSaldo);
END