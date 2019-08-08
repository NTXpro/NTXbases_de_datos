
CREATE PROC [ERP].[Usp_Validar_MovimientoConciliacion_By_Fecha]
@Fecha DATETIME,
@IdCuenta INT,
@IdEmpresa INT
AS
BEGIN
	DECLARE @Mes INT = (SELECT MONTH(@Fecha))
	DECLARE @Anio INT = (SELECT YEAR(@Fecha))
	DECLARE @IdPeriodo INT = (SELECT ID FROM ERP.Periodo WHERE IdMes = @Mes AND IdAnio = (SELECT ID FROM Maestro.Anio WHERE Nombre = @Anio));

	SELECT ISNULL(COUNT(ID),0) FROM ERP.MovimientoConciliacion WHERE IdPeriodo = @IdPeriodo AND IdEmpresa = @IdEmpresa AND IdCuenta = @IdCuenta AND FlagConciliado = 1
END
