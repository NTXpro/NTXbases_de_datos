
CREATE PROC [ERP].[Usp_Sel_Movimientos_CajaBanco_Detallado]
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
			MT.Orden OrdenMovimiento,
			CTM.Abreviatura AbreviaturaCategoriaTipoMovimiento,
			MT.Fecha FechaMovimiento,
			MT.Nombre NombreMovimiento,
			MT.Observacion ObservacionMovimiento,
			CASE WHEN MT.IdTipoMovimiento = 1 THEN
				MT.Total
			ELSE
				CAST(0 AS DECIMAL(14,5))
			END AS Ingreso,
			CASE WHEN MT.IdTipoMovimiento = 2 THEN
				MT.Total
			ELSE
				CAST(0 AS DECIMAL(14,5))
			END AS Egreso,
			MT.TipoCambio,

			MTD.Nombre NombreDetalle,
			MTD.Orden OrdenMovimientoDetalle,
			CASE WHEN MTD.IdDebeHaber = 1 THEN
				MTD.Total
			ELSE
				CAST(0 AS DECIMAL(14,5))
			END AS Debe,
			CASE WHEN MTD.IdDebeHaber = 2 THEN
				MTD.Total
			ELSE
				CAST(0 AS DECIMAL(14,5))
			END AS Haber,
			PC.CuentaContable,
			(SELECT [ERP].[ObtenerNombreComprobante_By_IdTipoComprobanteSerieDocumento](MTD.IdTipoComprobante,MTD.Serie,MTD.Documento)) Documento,
			P.Nombre NombreProyectoDetalle
	FROM ERP.MovimientoTesoreria MT
	LEFT JOIN Maestro.CategoriaTipoMovimiento CTM ON CTM.ID = MT.IdCategoriaTipoMovimiento
	INNER JOIN ERP.MovimientoTesoreriaDetalle MTD ON MTD.IdMovimientoTesoreria = MT.ID
	LEFT JOIN ERP.PlanCuenta PC ON PC.ID = MTD.IdPlanCuenta 
	LEFT JOIN ERP.Proyecto P ON P.ID = MTD.IdProyecto
	WHERE MT.IdEmpresa = @IdEmpresa AND MT.IdCuenta = @IdCuenta AND (@IdTipoMovimiento = 0 OR MT.IdTipoMovimiento = @IdTipoMovimiento)
    AND (@NroMovimientoFin = 0 OR (MT.Orden >= @NroMovimientoInicio  AND  MT.Orden <= @NroMovimientoFin)) 
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