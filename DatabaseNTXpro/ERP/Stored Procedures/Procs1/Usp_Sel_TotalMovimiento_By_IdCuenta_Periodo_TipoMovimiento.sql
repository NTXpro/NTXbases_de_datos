

CREATE PROC [ERP].[Usp_Sel_TotalMovimiento_By_IdCuenta_Periodo_TipoMovimiento]
@IdCuenta INT,
@IdTipoMovimiento INT,
@Anio INT,
@Mes INT
AS
BEGIN
	DECLARE @IdPeriodo INT = (SELECT ID FROM ERP.Periodo WHERE IdMes = @Mes AND IdAnio = (SELECT ID FROM Maestro.Anio WHERE Nombre = @Anio))
	DECLARE @TotalMovimientoConciliado DECIMAL(14,5)

	--SET @TotalMovimientoConciliado = (SELECT SUM(CASE WHEN C.IdMoneda = 1 THEN	
	--												MT.Total
	--											 ELSE
	--												MT.Total * MT.TipoCambio
	--											 END) 
	--								  FROM ERP.MovimientoTesoreria MT
	--								  INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
	--								  WHERE IdTipoMovimiento = @IdTipoMovimiento AND IdPeriodo = @IdPeriodo AND MT.IdCuenta = @IdCuenta
	--								  AND MT.FlagBorrador = 0 AND MT.Flag = 1)

	SET @TotalMovimientoConciliado = (SELECT SUM(MT.Total) 
									  FROM ERP.MovimientoTesoreria MT
									  INNER JOIN ERP.Cuenta C ON C.ID = MT.IdCuenta
									  WHERE IdTipoMovimiento = @IdTipoMovimiento AND IdPeriodo = @IdPeriodo AND MT.IdCuenta = @IdCuenta
									  AND MT.FlagBorrador = 0 AND MT.Flag = 1)

	SELECT ISNULL(@TotalMovimientoConciliado,0)
END