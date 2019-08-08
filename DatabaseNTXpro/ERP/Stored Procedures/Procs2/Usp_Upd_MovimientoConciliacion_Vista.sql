CREATE PROC [ERP].[Usp_Upd_MovimientoConciliacion_Vista]
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
@LibroSaldo DECIMAL(14,5)
AS
BEGIN

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
										  ,FlagConciliado = CAST(0 AS BIT)  
		WHERE ID = @ID
END