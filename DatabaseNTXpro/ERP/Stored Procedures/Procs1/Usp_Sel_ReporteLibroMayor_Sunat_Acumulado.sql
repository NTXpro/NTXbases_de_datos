CREATE PROCEDURE [ERP].[Usp_Sel_ReporteLibroMayor_Sunat_Acumulado] -- 1, 9, 6
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
	P.IdMes=@IdMes AND 
    M.Valor BETWEEN 0 AND @VALOR_MES_HASTA AND
	A.IdEmpresa = @IdEmpresa AND
	O.Abreviatura NOT IN ('02','03')
	GROUP BY A.ID
	HAVING

	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0)  <>
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID  FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL
	
	SELECT
        
	     0  AS RowNumber,
		'' AS Abreviatura,
		0  AS Orden,
		'' AS Correlativo,
		'' AS FechaStr,
		'' AS Glosa,
		'' AS Codigo,
		'' AS Denominacion,
		
		
		ISNULL(SUM(CASE WHEN M.Valor = @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END END), 0) AS Debe,
		ISNULL(SUM(CASE WHEN M.Valor = @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END END), 0) AS Haber,
		0 AS AcumuladoDebe,
		0 AS AcumuladoHaber,
			ISNULL(SUM(CASE WHEN M.Valor < @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END END), 0) AS SaldoDebe,
		ISNULL(SUM(CASE WHEN M.Valor < @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END END), 0) AS SaldoHaber,
		0 AS LagDebe,
		0 AS LagHaber,
		'' AS Mes
		
	FROM
	ERP.Asiento A
	INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	WHERE
	P.IdAnio = @IdAnio AND
	A.IdEmpresa = @IdEmpresa AND
	PC.IdEmpresa = @IdEmpresa AND

	ISNULL(A.FlagBorrador, 0) = 0 AND
	A.Flag = 1 and 
	A.ID NOT IN (SELECT ID FROM @DataInvalida) 

	
UNION ALL

	SELECT
		RowNumber,
		Abreviatura,
		Orden,
		Correlativo,
		FechaStr,
		Glosa,
		Codigo,
		Denominacion,
		Debe,
		Haber,
		AcumuladoDebe,
		AcumuladoHaber,
		SaldoDebe,
		SaldoHaber,
		LAG(AcumuladoDebe) OVER(ORDER BY RowNumber ASC) AS LagDebe,
		LAG(AcumuladoHaber) OVER(ORDER BY RowNumber ASC) AS Laghaber,
		Mes
	FROM
	(SELECT
		RowNumber,
		Abreviatura,
		Orden,
		Correlativo,
		FechaStr,
		Glosa,
		Codigo,
		Denominacion,
		Debe,
		Haber,
		
		SUM(Debe) OVER(ORDER BY RowNumber ASC) AS AcumuladoDebe,
		SUM(Haber) OVER(ORDER BY RowNumber ASC) AS AcumuladoHaber,
		SaldoDebe,
		SaldoHaber,
		Mes
	FROM
	(SELECT
		ROW_NUMBER() OVER(ORDER BY PC.CuentaContable ASC) AS RowNumber,
		M.Valor AS Mes,
	    O.Abreviatura,
		A.Orden,
		CONCAT(O.Abreviatura, RIGHT('000000' + LTRIM(RTRIM(A.Orden)), 6)) AS Correlativo,
		CONVERT(VARCHAR, A.Fecha, 103) AS FechaStr,
		A.Nombre AS Glosa,
		PC.CuentaContable AS Codigo,
		PC.Nombre AS Denominacion,
	
       	ISNULL(CASE WHEN M.Valor = @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END END, 0) AS Debe,
		ISNULL(CASE WHEN M.Valor = @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END END, 0) AS Haber,
		ISNULL(CASE WHEN M.Valor < @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END END, 0) AS SaldoDebe,
		ISNULL(CASE WHEN M.Valor < @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END END, 0) AS SaldoHaber
		
	FROM
	ERP.Asiento A
	INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	WHERE
	P.IdAnio = @IdAnio AND
	
	A.IdEmpresa = @IdEmpresa AND
	PC.IdEmpresa = @IdEmpresa AND
	M.Valor BETWEEN 0 AND @VALOR_MES_HASTA AND
	ISNULL(A.FlagBorrador, 0) = 0 AND
	A.Flag = 1 AND 
	A.ID NOT IN (SELECT ID FROM @DataInvalida)) AS TEMP) AS TEMP2
	SELECT ID AS PRUEBA FROM @DataInvalida 
END