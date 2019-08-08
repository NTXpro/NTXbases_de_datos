CREATE PROC ERP.Usp_ObtenerAnioxPeriodo
@IdPeriodo INT
AS
BEGIN

		SELECT CAST(AN.Nombre AS INT )
		FROM ERP.Periodo PE
		INNER JOIN Maestro.Anio AN
		ON AN.ID = PE.IdAnio
		INNER JOIN Maestro.Mes ME
		ON ME.ID = PE.IdMes
		WHERE PE.ID = @IdPeriodo
END
