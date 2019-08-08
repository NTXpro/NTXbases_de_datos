
CREATE PROC [ERP].[Usp_Sel_RendirCuenta_Borrador]	
@IdEmpresa INT
AS
BEGIN
	SELECT RC.ID,
		   MT.Nombre,
		   MT.Total,
		   RC.FechaRegistro
	FROM ERP.MovimientoRendirCuenta RC
	INNER JOIN ERP.MovimientoTesoreria MT ON MT.ID = RC.IdMovimientoTesoreria
	WHERE RC.FlagBorrador = 1 AND RC.IdEmpresa = @IdEmpresa
	

END