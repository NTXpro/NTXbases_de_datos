	CREATE FUNCTION ERP.ObtenerUltimoCeseLaboralByTrabajador(@IdTrabajador INT) RETURNS DATETIME
	AS
	BEGIN

			DECLARE @IdEmpresa INT = (SELECT IdEmpresa FROM ERP.Trabajador WHERE ID = @IdTrabajador)

			DECLARE @FechaCese DATETIME = (SELECT TOP 1 FechaCese
			FROM ERP.DatoLaboral DL
			INNER JOIN ERP.Trabajador TR ON TR.ID = DL.IdTrabajador
			WHERE DL.IdTrabajador = @IdTrabajador AND DL.IdEmpresa = @IdEmpresa
			ORDER BY DL.ID DESC)

			RETURN @FechaCese
	END
