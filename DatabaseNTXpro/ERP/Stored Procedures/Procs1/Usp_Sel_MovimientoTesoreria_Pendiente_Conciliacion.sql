CREATE PROC ERP.Usp_Sel_MovimientoTesoreria_Pendiente_Conciliacion
@IdConciliacion INT
AS
BEGIN
	SELECT MT.ID,
		   MT.Nombre,
		   MT.Total,
		   MT.Fecha,
		   MT.Orden,
		   TM.Nombre TipoMovimiento,
		   MT.IdTipoMovimiento
	FROM ERP.MovimientoConciliacionPendiente MCP
	INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = MCP.IdMovimientoTesoreria
	INNER JOIN Maestro.TipoMovimiento TM ON TM.ID = MT.IdTipoMovimiento
	WHERE MCP.IdMovimientoConciliacion = @IdConciliacion
END

