

CREATE PROC [ERP].[Usp_Sel_SaldoFinalMovimiento] --1,1,1
@IdCuenta INT,
@IdEmpresa INT,
@Mes INT,
@Anio INT
AS
BEGIN
	SELECT [ERP].[ObtenerTotalSaldoFinalMovimientoByCuentaPeriodo](@IdEmpresa,@IdCuenta,@Mes,@Anio)
END
