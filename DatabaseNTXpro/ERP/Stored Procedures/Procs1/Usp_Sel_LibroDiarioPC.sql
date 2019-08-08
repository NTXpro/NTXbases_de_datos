CREATE PROCEDURE ERP.Usp_Sel_LibroDiarioPC
@IdAnio INT,
@IdMes INT,
@IdEmpresa INT
AS
	DECLARE @IdGrado INT
	DECLARE @Mes CHAR(2)

	SELECT TOP 1 @IdGrado = ID 
	FROM Maestro.Grado
	WHERE IdAnio = @IdAnio
	AND IdEmpresa = @IdEmpresa
	ORDER BY Longitud DESC

	SELECT @Mes = RIGHT('00' + CAST(M.Valor AS VARCHAR(5)), 2)
	FROM Maestro.Mes M
	WHERE M.ID = @IdMes

	SELECT AN.Nombre + @Mes + '01' Periodo,
			PC.CuentaContable,
			PC.Nombre NombrePlanCuenta
	FROM ERP.PlanCuenta PC	
	INNER JOIN Maestro.Anio AN ON PC.IdAnio = AN.ID	
	WHERE PC.Flag = 1
	AND PC.FlagBorrador = 0
	AND PC.IdAnio = @IdAnio	
	AND PC.IdEmpresa = @IdEmpresa
	AND PC.IdGrado = @IdGrado