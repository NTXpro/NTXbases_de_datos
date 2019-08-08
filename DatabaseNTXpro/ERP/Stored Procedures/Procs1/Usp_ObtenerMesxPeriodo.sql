
CREATE PROC ERP.Usp_ObtenerMesxPeriodo
@IdPeriodo INT
AS
BEGIN

		SELECT ME.Valor
		FROM ERP.Periodo PE
		INNER JOIN Maestro.Anio AN
		ON AN.ID = PE.IdAnio
		INNER JOIN Maestro.Mes ME
		ON ME.ID = PE.IdMes
		WHERE PE.ID = @IdPeriodo
END
