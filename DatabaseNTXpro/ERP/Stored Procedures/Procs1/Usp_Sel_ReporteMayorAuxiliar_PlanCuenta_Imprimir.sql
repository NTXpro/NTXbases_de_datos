CREATE PROCEDURE [ERP].[Usp_Sel_ReporteMayorAuxiliar_PlanCuenta_Imprimir]
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT,

@IdMoneda INT,
@FlagAllCuenta BIT,
@CuentaContableDesde VARCHAR(25),
@CuentaContableHasta VARCHAR(25),
@IdEntidad INT
AS
BEGIN
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	DECLARE @VALOR_MES_HASTA INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMes)

	/******************************************************************************/
	DECLARE @CADENA VARCHAR(30) = '000000000000000000000000000000';
	DECLARE @MAX_LEN INT = (SELECT MAX(LEN(CuentaContable)) FROM ERP.PlanCuenta);
	DECLARE @TOTAL_CEROS VARCHAR(30) = (SELECT SUBSTRING(@CADENA, 1, @MAX_LEN));
	DECLARE @CC_DESDE INT = CAST(LEFT(@CuentaContableDesde + @TOTAL_CEROS, @MAX_LEN) AS INT)
	DECLARE @CC_HASTA INT = CAST(LEFT(@CuentaContableHasta + @TOTAL_CEROS, @MAX_LEN) AS INT)
	/******************************************************************************/

	INSERT INTO @DataInvalida
	SELECT 
	A.ID AS ID
	FROM ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	INNER JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
	WHERE 
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN 0 AND @VALOR_MES_HASTA AND
	A.IdEmpresa = @IdEmpresa AND
	O.Abreviatura NOT IN ('02','03')
	GROUP BY A.ID
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL
	
	SELECT
		M.Valor,
		PC.CuentaContable,
		REPLACE(REPLACE(PC.Nombre,CHAR(10),''),CHAR(13),'') AS NombreCuentaContable,
		ISNULL(CASE WHEN M.Valor < @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END END, 0) AS SaldoDebe,
		ISNULL(CASE WHEN M.Valor < @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END END, 0) AS SaldoHaber,
		CONVERT(VARCHAR, A.Fecha, 103) AS FechaStr,
		O.Abreviatura,
		A.Orden,
		CONCAT(O.Abreviatura, RIGHT('000000' + LTRIM(RTRIM(A.Orden)), 6)) AS Correlativo,
		A.Nombre AS Glosa,
		ISNULL(CASE WHEN M.Valor = @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END END, 0) AS Debe,
		ISNULL(CASE WHEN M.Valor = @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END END, 0) AS Haber,
		X.ID,
		X.CuentaContable,
		X.Nombre,
		X.DebeCabecera,
		X.HaberCabecera,
		X.DebeActual,
		X.HaberActual,
		X.DebeAcumulado,
		X.HaberAcumulado
	FROM
	ERP.Asiento A
	INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	LEFT JOIN (
				SELECT 
					PC.ID,
					PC.CuentaContable,
					PC.Nombre,
					------------------------------------------------------------------------------------------------------------------------------------------------------
					CASE 
						WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE WHEN M.Valor < @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) END ELSE 0 END ), 0)
						WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE WHEN M.Valor < @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) END ELSE 0 END ), 0)
					END AS DebeCabecera,
					CASE 
						WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE WHEN M.Valor < @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) END ELSE 0 END ), 0)
						WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE WHEN M.Valor < @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) END ELSE 0 END ), 0)
					END AS HaberCabecera,
					--------------------------------------------------------------------------------------------------------------------------------------------------------
					CASE 
						WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE WHEN M.Valor = @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) END ELSE 0 END ), 0)
						WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE WHEN M.Valor = @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) END ELSE 0 END ), 0)
					END AS DebeActual,
					CASE 
						WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE WHEN M.Valor = @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) END ELSE 0 END ), 0)
						WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE WHEN M.Valor = @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) END ELSE 0 END ), 0)
					END AS HaberActual,
					--------------------------------------------------------------------------------------------------------------------------------------------------------
					CASE 
						WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) END), 0)
						WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) END), 0)
					END AS DebeAcumulado,
					CASE 
						WHEN @IdMoneda = 1 THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) END), 0)
						WHEN @IdMoneda = 2 THEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) END), 0)
					END AS HaberAcumulado
				FROM
				ERP.PlanCuenta PC
				LEFT JOIN ERP.AsientoDetalle AD ON PC.ID = AD.IdPlanCuenta
				LEFT JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
				LEFT JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
				LEFT JOIN Maestro.Mes M ON P.IdMes = M.ID
				LEFT JOIN ERP.Entidad EN ON AD.IdEntidad = EN.ID
				WHERE
				P.IdAnio = @IdAnio AND
				M.Valor BETWEEN 0 AND @VALOR_MES_HASTA AND
				A.IdEmpresa = @IdEmpresa AND
				PC.IdEmpresa = @IdEmpresa AND
				--PC.IdAnio = @IdAnio AND
				(@IdEntidad = 0 OR AD.IdEntidad = @IdEntidad) AND
				A.ID NOT IN (
								SELECT 
								A.ID AS ID
								FROM ERP.AsientoDetalle AD
								INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
								INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
								INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
								INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
								INNER JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
								WHERE 
								P.IdAnio = @IdAnio AND
								M.Valor BETWEEN 0 AND @VALOR_MES_HASTA AND
								A.IdEmpresa = @IdEmpresa AND
								O.Abreviatura NOT IN ('02','03')
								GROUP BY A.ID
								HAVING
								ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
								ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
								UNION
								SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL
							)
				AND	(CAST(LEFT(PC.CuentaContable + @TOTAL_CEROS, @MAX_LEN) AS INT) BETWEEN @CC_DESDE AND @CC_HASTA OR @FlagAllCuenta = 1)
				AND ISNULL(A.FlagBorrador, 0) = 0
				AND A.Flag = 1
				AND AD.FlagBorrador = 0
				GROUP BY PC.ID, PC.CuentaContable, PC.Nombre
				HAVING
				ISNULL(SUM(AD.ImporteSoles), 0) <> 0
				--ORDER BY PC.CuentaContable ASC
				) X ON X.ID = PC.ID
	WHERE
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN 0 AND @VALOR_MES_HASTA AND
	A.IdEmpresa = @IdEmpresa AND
	PC.IdEmpresa = @IdEmpresa AND
	(@IdEntidad = 0 OR AD.IdEntidad = @IdEntidad) AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	(CAST(LEFT(PC.CuentaContable + @TOTAL_CEROS, @MAX_LEN) AS INT) BETWEEN @CC_DESDE AND @CC_HASTA OR @FlagAllCuenta = 1) AND
	ISNULL(A.FlagBorrador, 0) = 0 AND
	A.Flag = 1
	ORDER BY PC.CuentaContable, O.Abreviatura, A.Orden
END