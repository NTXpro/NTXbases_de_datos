
CREATE PROC [ERP].[Usp_ObetenerPeriodo]
@IdAnio CHAR(4),
@IdMes INT
AS
BEGIN		
	DECLARE @IdPeriodo INT = (
				SELECT	PE.ID
				FROM [ERP].[Periodo] PE
				INNER JOIN [Maestro].[Anio] AN
				ON AN.ID = PE.IdAnio
				INNER JOIN [Maestro].[Mes] ME
				ON ME.ID = PE.IdMes
				WHERE AN.Nombre = @IdAnio AND ME.Valor = @IdMes)
	SELECT @IdPeriodo
END
