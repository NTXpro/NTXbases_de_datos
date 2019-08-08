CREATE PROC [ERP].[Usp_Ins_MovimientoConciliacion]
@IdEmpresa INT,
@IdCuenta INT,
@Anio INT,
@Mes INT
AS
BEGIN
	DECLARE @IdPeriodo INT = (SELECT ID FROM ERP.Periodo WHERE IdMes = @Mes AND IdAnio = (SELECT ID FROM Maestro.Anio WHERE Nombre = @Anio));
	DECLARE @IdMovimientoConciliacion INT = (SELECT ID FROM ERP.MovimientoConciliacion WHERE IdCuenta = @IdCuenta AND IdPeriodo = @IdPeriodo AND IdEmpresa = @IdEmpresa);
	
	IF @IdMovimientoConciliacion IS NULL
		BEGIN
			INSERT INTO ERP.MovimientoConciliacion(IdCuenta, IdPeriodo, IdEmpresa, Flag) VALUES(@IdCuenta, @IdPeriodo, @IdEmpresa, CAST(1 AS BIT))
			SELECT CAST(SCOPE_IDENTITY() AS INT)
		END
	ELSE
		BEGIN
			SELECT @IdMovimientoConciliacion
		END
END