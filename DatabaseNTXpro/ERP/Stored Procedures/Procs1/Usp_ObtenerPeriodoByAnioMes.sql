
CREATE PROC [ERP].[Usp_ObtenerPeriodoByAnioMes]
@IdAnio INT,
@IdMes INT
AS
BEGIN
		DECLARE @IdPeriodo INT =(SELECT ID FROM ERP.Periodo WHERE IdAnio = @IdAnio AND IdMes = @IdMes)

		SELECT ISNULL(@IdPeriodo, 0)
END
