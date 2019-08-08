CREATE PROC ERP.Usp_Sel_MovimientoTesoreria_Conciliacion_Pendiente
@IdConciliacion INT,
@IdEmpresa	 INT
AS
BEGIN

DECLARE @IdPeriodo INT = (SELECT IdPeriodo
								FROM ERP.MovimientoConciliacion
								WHERE ID = @IdConciliacion);

DECLARE @IdCuenta INT = (SELECT IdCuenta
								FROM ERP.MovimientoConciliacion
								WHERE ID = @IdConciliacion);

	SELECT MT.ID,
		   MT.Nombre,
		   MT.Total,
		   MT.Fecha,
		   MT.Orden,
		   TM.Nombre TipoMovimiento,
		   MT.IdTipoMovimiento
	FROM ERP.MovimientoTesoreria MT
	INNER JOIN Maestro.TipoMovimiento TM ON TM.ID = MT.IdTipoMovimiento
	WHERE Flag = 1 AND ISNULL(FlagBorrador, 0) = 0
	AND MT.FlagConciliado = 0
	AND IdCuenta = @IdCuenta
	AND IdEmpresa = @IdEmpresa
	AND IdPeriodo <= @IdPeriodo
END