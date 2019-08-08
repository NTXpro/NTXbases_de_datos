
	CREATE FUNCTION ERP.ObtenerUltimoSueldoByTrabajador(@IdTrabajador INT) RETURNS DECIMAL(14,5)
	AS
	BEGIN

			DECLARE @IdEmpresa INT = (SELECT IdEmpresa FROM ERP.Trabajador WHERE ID = @IdTrabajador)

			DECLARE @Sueldo DECIMAL(14,5) = (SELECT TOP 1 DLD.Sueldo
													FROM ERP.DatoLaboral DL
													INNER JOIN ERP.DatoLaboralDetalle DLD ON DLD.IdDatoLaboral = DL.ID
													INNER JOIN ERP.Trabajador TR ON TR.ID = DL.IdTrabajador
													WHERE DL.IdTrabajador = @IdTrabajador AND DL.IdEmpresa = @IdEmpresa
													ORDER BY DLD.ID DESC)

			RETURN ISNULL(@Sueldo,0)
	END
