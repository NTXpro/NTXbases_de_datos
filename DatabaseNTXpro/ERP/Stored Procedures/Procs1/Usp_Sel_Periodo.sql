CREATE PROC ERP.Usp_Sel_Periodo
@IdPeriodo INT
AS
BEGIN
		SELECT PE.ID,
			   PE.IdAnio,
			   PE.IdMes,
			   AN.Nombre  Anio,
			   ME.Nombre  Mes
		FROM ERP.Periodo PE
		INNER JOIN Maestro.Anio AN ON AN.ID = PE.IdAnio
		INNER JOIN Maestro.Mes ME ON ME.ID = PE.IdMes
		WHERE PE.ID = @IdPeriodo
END
