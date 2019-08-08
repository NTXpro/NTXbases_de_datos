CREATE PROCEDURE [ERP].[Usp_Sel_ReporteLibroMayor_PlanCuenta_Prueba] --1, 9, 6
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT
AS
BEGIN
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	DECLARE @VALOR_MES_HASTA INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMes)

	INSERT INTO @DataInvalida
	SELECT
	A.ID AS ID
	FROM ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	WHERE 
	P.IdAnio = @IdAnio AND
	P.IdMes = @IdMes AND
	A.IdEmpresa = @IdEmpresa AND
	O.Abreviatura NOT IN ('02','03')
	GROUP BY A.ID
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL
	
	SELECT
		PC.ID AS IdPlanCuenta,
		PC.CuentaContable,
		REPLACE(REPLACE(PC.Nombre,CHAR(10),''),CHAR(13),'') AS NombreCuentaContable,
		SUM(ISNULL(CASE WHEN M.Valor < @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END END, 0)) AS SaldoDebe,
		SUM(ISNULL(CASE WHEN M.Valor < @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END END, 0)) AS SaldoHaber
	FROM
	ERP.Asiento A
	INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	WHERE
	P.IdAnio = @IdAnio AND
	
	M.Valor BETWEEN 0 AND @VALOR_MES_HASTA AND
	A.IdEmpresa = @IdEmpresa AND
	PC.IdEmpresa = @IdEmpresa AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	ISNULL(A.FlagBorrador, 0) = 0 AND
	A.Flag = 1
	GROUP BY
		PC.ID,
		PC.CuentaContable,
		PC.Nombre
	ORDER BY PC.CuentaContable
END