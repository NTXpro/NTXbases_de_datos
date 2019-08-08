
create FUNCTION [ERP].[ObtenerValorParametroByAbreviaturaFecha] (
@IdEmpresa INT,
@Abreviatura VARCHAR(10),
@Fecha DATETIME) 
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @ValorParametro VARCHAR(MAX) = (SELECT TOP 1 PA.Valor FROM ERP.Parametro PA 
											LEFT JOIN ERP.Periodo P ON P.ID = PA.IdPeriodo
											LEFT JOIN Maestro.Anio A ON A.ID = P.IdAnio
											LEFT JOIN Maestro.Mes M ON M.ID = P.IdMes
											WHERE (IdEmpresa IS NULL OR IdEmpresa = @IdEmpresa)
											AND Abreviatura = @Abreviatura 
											AND ((A.Nombre < YEAR(@Fecha) OR (A.Nombre = YEAR(@Fecha) AND M.Valor <= MONTH(@Fecha))))
											ORDER BY A.Nombre, M.Valor DESC)

	IF @ValorParametro IS NULL 
	BEGIN
		SET @Fecha = GETDATE();
		SET @ValorParametro = (SELECT TOP 1 PA.Valor FROM ERP.Parametro PA 
											LEFT JOIN ERP.Periodo P ON P.ID = PA.IdPeriodo
											LEFT JOIN Maestro.Anio A ON A.ID = P.IdAnio
											LEFT JOIN Maestro.Mes M ON M.ID = P.IdMes
											WHERE (IdEmpresa IS NULL OR IdEmpresa = @IdEmpresa)
											AND Abreviatura = @Abreviatura 
											AND ((A.Nombre < YEAR(@Fecha) OR (A.Nombre = YEAR(@Fecha) AND M.Valor <= MONTH(@Fecha))))
											ORDER BY A.Nombre, M.Valor DESC)

	END

	RETURN @ValorParametro
END
