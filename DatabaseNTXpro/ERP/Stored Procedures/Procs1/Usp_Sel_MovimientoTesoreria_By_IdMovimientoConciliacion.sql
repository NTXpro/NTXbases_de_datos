
CREATE PROC [ERP].[Usp_Sel_MovimientoTesoreria_By_IdMovimientoConciliacion]
@IdMovimientoConciliacion INT
AS
BEGIN

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
	WHERE IdMovimientoConciliacion = @IdMovimientoConciliacion

END