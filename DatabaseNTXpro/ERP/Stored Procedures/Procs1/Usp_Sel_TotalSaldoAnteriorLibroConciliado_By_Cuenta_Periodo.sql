CREATE PROC [ERP].[Usp_Sel_TotalSaldoAnteriorLibroConciliado_By_Cuenta_Periodo]-- 2,2016,12
@IdCuenta INT,
@Anio INT,
@Mes INT
AS
BEGIN
    
	DECLARE @TotalSaldoAnteriorLibro DECIMAL(14,5);
	
	--SET @TotalSaldoAnteriorLibro = (SELECT SUM(CASE WHEN C.IdMoneda = 1 THEN	
	--												MT.Total
	--											 ELSE
	--												MT.Total * MT.TipoCambio
	--											 END)  
	--								FROM ERP.MovimientoTesoreria MT
	--								INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta 
	--								WHERE ((YEAR(MT.Fecha) =  @Anio AND MONTH(MT.Fecha) =  @Mes) OR (YEAR(MT.Fecha) <  @Anio)) AND FlagConciliado = 1
	--								AND MT.FlagBorrador = 0 AND MT.Flag = 1 AND MT.IdCuenta = @IdCuenta)

	SET @TotalSaldoAnteriorLibro = (SELECT SUM(MT.Total)  
								FROM ERP.MovimientoTesoreria MT
								INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta 
								WHERE ((YEAR(MT.Fecha) =  @Anio AND MONTH(MT.Fecha) <=  @Mes) OR (YEAR(MT.Fecha) <  @Anio)) AND FlagConciliado = 0
								AND MT.FlagBorrador = 0 AND MT.Flag = 1 AND MT.IdCuenta = @IdCuenta)

	SELECT ISNULL(@TotalSaldoAnteriorLibro,0)
END
