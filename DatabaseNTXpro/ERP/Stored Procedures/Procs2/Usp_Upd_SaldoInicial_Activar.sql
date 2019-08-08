CREATE PROC [ERP].[Usp_Upd_SaldoInicial_Activar]
@IdSaldo INT,
@UsuarioActivo VARCHAR(250)
AS
BEGIN
	UPDATE ERP.SaldoInicial SET Flag = 1 ,FechaActivacion=DATEADD(HOUR, 3, GETDATE()),UsuarioActivo = @UsuarioActivo  WHERE ID = @IdSaldo 

		UPDATE ERP.CuentaPagar SET Flag = 1 WHERE ID IN (SELECT CP.ID FROM 
									ERP.SaldoInicial C
									INNER JOIN ERP.SaldoInicialCuentaPagar CCP ON C.ID = CCP.IdSaldoInicial
									INNER JOIN ERP.CuentaPagar CP ON CCP.IdCuentaPagar = CP.ID
									WHERE C.ID = @IdSaldo);
END