
CREATE PROC [ERP].[Usp_Upd_MovimientoConciliacion]
@ID INT,
@BancoSaldoAnterior DECIMAL(14,5),
@BancoIngreso DECIMAL(14,5),
@BancoEgreso DECIMAL(14,5),
@BancoSaldo DECIMAL(14,5),
@ConciliadoIngreso DECIMAL(14,5),
@ConciliadoEgreso DECIMAL(14,5),
@DifiereIngreso DECIMAL(14,5),
@DifiereEgreso DECIMAL(14,5),
@LibroSaldoAnterior DECIMAL(14,5),
@LibroIngreso DECIMAL(14,5),
@LibroEgreso DECIMAL(14,5),
@LibroSaldo DECIMAL(14,5),
@UsuarioRegistro VARCHAR(250)
AS
BEGIN
	DECLARE @IdPeriodo INT = (SELECT IdPeriodo FROM ERP.MovimientoConciliacion WHERE ID = @ID);
	DECLARE @IdCuenta INT = (SELECT IdCuenta FROM ERP.MovimientoConciliacion WHERE ID = @ID);
	DECLARE @Anio INT = (SELECT Nombre FROM Maestro.Anio A INNER JOIN ERP.Periodo P ON A.ID = P.IdAnio WHERE P.ID = @IdPeriodo)
	DECLARE @IdAnio INT = (SELECT IdAnio FROM ERP.Periodo WHERE ID = @IdPeriodo)
	DECLARE @Mes INT = (SELECT IdMes FROM ERP.Periodo WHERE ID = @IdPeriodo)

	UPDATE ERP.MovimientoConciliacion SET BancoSaldoAnterior = @BancoSaldoAnterior
										  ,BancoIngreso = @BancoIngreso
										  ,BancoEgreso = @BancoEgreso
										  ,BancoSaldo = @BancoSaldo
										  ,ConciliadoIngreso = @ConciliadoIngreso
										  ,ConciliadoEgreso = @ConciliadoEgreso
										  ,DifiereIngreso = @DifiereIngreso
										  ,DifiereEgreso = @DifiereEgreso
										  ,LibroSaldoAnterior = @LibroSaldoAnterior
										  ,LibroIngreso = @LibroIngreso
										  ,LibroEgreso = @LibroEgreso
										  ,LibroSaldo = @LibroSaldo
										  ,UsuarioRegistro = @UsuarioRegistro
										  ,FlagConciliado = CAST(1 AS BIT)  
		WHERE ID = @ID

		INSERT INTO ERP.MovimientoConciliacionPendiente(IdMovimientoConciliacion
														,IdMovimientoTesoreria
														,FlagPendiente)
		SELECT @ID,
			   ID,
			   CAST(1 AS BIT) 
		FROM ERP.MovimientoTesoreria
		WHERE (IdPeriodo IN (SELECT ID FROM ERP.Periodo WHERE (IdAnio IN (SELECT ID FROM Maestro.Anio WHERE Nombre < @Anio) AND IdMes <= 12) OR (IdAnio = @IdAnio AND IdMes <= @Mes )) AND (FlagConciliado = 0 OR FlagConciliado IS NULL))
		AND FlagConciliado = 0 AND IdCuenta = @IdCuenta AND Flag = 1 AND FlagBorrador = 0; 
END
