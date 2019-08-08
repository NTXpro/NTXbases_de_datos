CREATE PROC [ERP].[Usp_Validar_Periodo_Parametro] 
@IdEmpresa INT,
@NombrePeriodo VARCHAR(60),
@IdAnio INT,
@IdMes INT
AS
BEGIN
	
	DECLARE @CountParametro INT = (SELECT COUNT(ID) 
									FROM ERP.Parametro
									WHERE Nombre = @NombrePeriodo AND IdPeriodo = (SELECT ID FROM ERP.Periodo WHERE IdAnio = @IdAnio AND IdMes = @IdMes)
									AND IdEmpresa = @IdEmpresa)

	SELECT  ISNULL(@CountParametro,0)
END


