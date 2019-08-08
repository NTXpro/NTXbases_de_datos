
CREATE PROC [ERP].[Usp_Sel_Movimientos_CajaBanco]
@IdEmpresa INT,
@IdCuenta INT,
@IdTipoMovimiento INT,
@Ordenamiento INT,
@NroMovimientoInicio INT,
@NroMovimientoFin INT,
@Filtro INT,
@FechaInicio DATETIME,
@FechaFin DATETIME
AS
BEGIN

	SELECT	MT.ID,
			MT.IdTipoMovimiento,
			MT.Orden,
			CTM.Abreviatura,
			MT.Fecha,
			MT.Nombre,
			MT.Observacion,
			CASE WHEN MT.IdTipoMovimiento = 1 THEN
				MT.Total
			ELSE
				CAST(0 AS DECIMAL(14,5))
			END AS Ingreso,
			CASE WHEN MT.IdTipoMovimiento = 2 THEN
				MT.Total
			ELSE
				CAST(0 AS DECIMAL(14,5))
			END AS Egreso
	FROM ERP.MovimientoTesoreria MT
	LEFT JOIN Maestro.CategoriaTipoMovimiento CTM ON CTM.ID = MT.IdCategoriaTipoMovimiento
	WHERE MT.IdEmpresa = @IdEmpresa AND MT.IdCuenta = @IdCuenta AND (@IdTipoMovimiento = 0 OR MT.IdTipoMovimiento = @IdTipoMovimiento)
    AND (@NroMovimientoFin = 0 OR (Orden >= @NroMovimientoInicio  AND  Orden <= @NroMovimientoFin)) 
	AND ((@Filtro = 1 AND (YEAR(MT.Fecha) = YEAR(@FechaInicio) AND MONTH(MT.Fecha) = MONTH(@FechaInicio)))
	OR (@Filtro = 2 AND (CAST(MT.Fecha AS DATE) >= CAST(@FechaInicio AS DATE) AND CAST(MT.Fecha AS DATE) <= CAST(@FechaFin AS DATE))))
	AND MT.Flag = 1 AND MT.FlagBorrador = 0
	ORDER BY 
    CASE @Ordenamiento
    WHEN 1 THEN MT.Orden
    END,
	CASE @Ordenamiento
    WHEN 2 THEN MT.Nombre
    END,
	CASE @Ordenamiento
	WHEN 3 THEN MT.Fecha
    END,
	CASE @Ordenamiento
	WHEN 4 THEN MT.Total
    END;


END