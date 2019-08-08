CREATE PROC [ERP].[Usp_Upd_SaldoInicial_Desactivar]
@IdSaldo INT,
@UsuarioElimino VARCHAR(250)
AS
BEGIN
		UPDATE ERP.SaldoInicial SET Flag = 0 ,FechaEliminado=DATEADD(HOUR, 3, GETDATE()),UsuarioElimino = @UsuarioElimino  WHERE ID = @IdSaldo 

		UPDATE ERP.CuentaPagar SET Flag = 0 WHERE ID IN  (SELECT CCP.IdCuentaPagar FROM 
									ERP.SaldoInicial C
									INNER JOIN ERP.SaldoInicialCuentaPagar CCP ON C.ID = CCP.IdSaldoInicial
									WHERE C.ID = @IdSaldo);
END