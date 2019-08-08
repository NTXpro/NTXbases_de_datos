CREATE PROC [ERP].[Usp_Sel_SaldoInicialMovimiento]
@IdEmpresa INT,
@IdCuenta INT,
@Mes INT,
@Anio INT
AS
BEGIN
	DECLARE @SaldoInicialTotal DECIMAL(14,5)= (SELECT [ERP].[ObtenerTotalSaldoInicialMovimientoByCuentaPeriodo](@IdEmpresa,@IdCuenta, @Mes, @Anio))

	SELECT @SaldoInicialTotal
END