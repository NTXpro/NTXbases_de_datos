
	CREATE FUNCTION ERP.ObtenerUltimoPlanillaTrabajador(@IdTrabajador INT) RETURNS VARCHAR(250)
	AS
	BEGIN

			DECLARE @IdEmpresa INT = (SELECT IdEmpresa FROM ERP.Trabajador WHERE ID = @IdTrabajador)

			DECLARE @Planilla VARCHAR(250) = (SELECT TOP 1 PL.Nombre
													FROM ERP.DatoLaboral DL
													INNER JOIN ERP.Trabajador TR ON TR.ID = DL.IdTrabajador
													INNER JOIN Maestro.Planilla PL ON PL.ID = DL.IdPlanilla
													WHERE DL.IdTrabajador = @IdTrabajador AND DL.IdEmpresa = @IdEmpresa
													ORDER BY DL.ID DESC)

			RETURN @Planilla
	END
