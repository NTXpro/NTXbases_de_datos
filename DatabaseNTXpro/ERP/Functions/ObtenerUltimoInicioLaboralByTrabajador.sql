
	CREATE FUNCTION ERP.ObtenerUltimoInicioLaboralByTrabajador(@IdTrabajador INT) RETURNS DATETIME
	AS
	BEGIN

			DECLARE @IdEmpresa INT = (SELECT IdEmpresa FROM ERP.Trabajador WHERE ID = @IdTrabajador)

			DECLARE @FechaInicio DATETIME = (SELECT TOP 1 FechaInicio
			FROM ERP.DatoLaboral DL
			INNER JOIN ERP.Trabajador TR ON TR.ID = DL.IdTrabajador
			WHERE DL.IdTrabajador = @IdTrabajador AND DL.IdEmpresa = @IdEmpresa
			ORDER BY DL.ID DESC)

			RETURN @FechaInicio
	END
