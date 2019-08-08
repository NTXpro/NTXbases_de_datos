
CREATE FUNCTION [ERP].[ObtenerFechaActual]() 
RETURNS DATETIME
AS
BEGIN
	DECLARE @ValorParametroHora INT = CAST((SELECT VALOR FROM ERP.Parametro WHERE Abreviatura = 'SHA') AS INT)
	DECLARE @FechaActual DATETIME= DATEADD(HOUR, -@ValorParametroHora, GETDATE());

	RETURN @FechaActual
END