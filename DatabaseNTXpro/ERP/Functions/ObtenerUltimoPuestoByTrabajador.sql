
	CREATE FUNCTION ERP.ObtenerUltimoPuestoByTrabajador(@IdTrabajador INT) RETURNS VARCHAR(250)
	AS
	BEGIN

			DECLARE @IdEmpresa INT = (SELECT IdEmpresa FROM ERP.Trabajador WHERE ID = @IdTrabajador)

			DECLARE @Puesto VARCHAR(250) = (SELECT TOP 1 PU.Nombre
													FROM ERP.DatoLaboral DL
													INNER JOIN ERP.DatoLaboralDetalle DLD ON DLD.IdDatoLaboral = DL.ID
													INNER JOIN Maestro.Puesto PU ON PU.ID = DLD.IdPuesto
													INNER JOIN ERP.Trabajador TR ON TR.ID = DL.IdTrabajador
													WHERE DL.IdTrabajador = @IdTrabajador AND DL.IdEmpresa = @IdEmpresa
													ORDER BY DLD.ID DESC)

			RETURN @Puesto
	END
