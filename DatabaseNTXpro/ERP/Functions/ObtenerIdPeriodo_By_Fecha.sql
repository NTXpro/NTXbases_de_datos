
CREATE FUNCTION [ERP].[ObtenerIdPeriodo_By_Fecha](@Fecha DATETIME)
RETURNS INT
AS
BEGIN

DECLARE @IdPeriodo INT = (SELECT P.ID FROM ERP.Periodo P WHERE IdMes = MONTH(@Fecha) AND
						  IdAnio = (SELECT A.ID FROM Maestro.Anio A WHERE A.Nombre = YEAR(@Fecha)))

RETURN @IdPeriodo

END

