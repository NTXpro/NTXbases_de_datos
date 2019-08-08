CREATE PROC [ERP].[Usp_Sel_Operacion_By_ID]
@IdOperacion INT
AS
BEGIN

		SELECT *
		FROM ERP.Operacion OP
		LEFT JOIN ERP.PlanCuenta PC ON PC.ID = OP.IdPlanCuenta
		LEFT JOIN Maestro.TipoMovimiento TM ON TM.ID = OP.IdTipoMovimiento
		WHERE OP.ID  = @IdOperacion
END
