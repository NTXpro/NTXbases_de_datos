
CREATE PROC [ERP].[Usp_Sel_MovimientoTesoreria_By_PeriodoCuentaTipoSeleccion]
@IdConciliacion INT,
@IdCuenta INT,
@Anio INT,
@Mes INT,
@TipoSeleccion INT,
@Ordenamiento INT
AS
BEGIN
	DECLARE @IdAnio INT = (SELECT TOP 1 ID FROM Maestro.Anio WHERE Nombre = @Anio);
	DECLARE @IdPeriodo INT = (SELECT ID FROM ERP.Periodo WHERE IdMes = @Mes AND IdAnio = @IdAnio)

	SELECT MT.ID,
		   MT.Orden,
		   MT.Voucher,
		   TM.ID IdTipoMovimiento,
		   TM.Nombre NombreTipoMovimiento,
		   ETD.NumeroDocumento,
		   MT.Total,
		   MT.Nombre,
		   MT.FlagConciliado,
		   MT.Fecha 
	FROM ERP.MovimientoTesoreria MT
	INNER JOIN Maestro.TipoMovimiento TM ON TM.ID = MT.IdTipoMovimiento
	LEFT JOIN ERP.Entidad E ON E.ID = MT.IdEntidad
	LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID
	WHERE IdCuenta = @IdCuenta AND (@TipoSeleccion = -1 OR FlagConciliado = @TipoSeleccion) AND MT.Flag = 1 AND MT.FlagBorrador = 0
	AND (IdMovimientoConciliacion = @IdConciliacion OR (IdPeriodo IN (SELECT ID FROM ERP.Periodo WHERE (IdAnio IN (SELECT ID FROM Maestro.Anio WHERE Nombre < @Anio) AND IdMes <= 12) OR (IdAnio = @IdAnio AND IdMes <= @Mes )) AND (FlagConciliado = 0 OR FlagConciliado IS NULL)))
	ORDER BY 
    CASE @Ordenamiento
    WHEN 1 THEN MT.Orden
    END,
	CASE @Ordenamiento
    WHEN 2 THEN ETD.NumeroDocumento
    END,
	CASE @Ordenamiento
	WHEN 3 THEN MT.Fecha
    END,
	CASE @Ordenamiento
	WHEN 4 THEN MT.Total
    END;

END