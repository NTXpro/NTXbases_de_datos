CREATE PROCEDURE [ERP].[Usp_Sel_ReporteBalance_PlanCuenta]
@IdEmpresa INT,
@IdAnio INT,
@IdMesDesde INT,
@IdMesHasta INT,
@IdMoneda INT,
@FlagAllCuenta BIT,
@CuentaContableDesde VARCHAR(25),
@CuentaContableHasta VARCHAR(25),
@PorGrado BIT,
@IdGrado INT,
@FlagSaldoInicial BIT
AS
BEGIN
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	DECLARE @VALOR_MES_DESDE INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMesDesde);
	DECLARE @VALOR_MES_HASTA INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMesHasta);
	/******************************************************************************/
	DECLARE @CADENA VARCHAR(30) = '000000000000000000000000000000';
	DECLARE @MAX_LEN INT = (SELECT MAX(LEN(CuentaContable)) FROM ERP.PlanCuenta);
	DECLARE @TOTAL_CEROS VARCHAR(30) = (SELECT SUBSTRING(@CADENA, 1, @MAX_LEN));
	DECLARE @CC_DESDE INT = CAST(LEFT(@CuentaContableDesde + @TOTAL_CEROS, @MAX_LEN) AS INT)
	DECLARE @CC_HASTA INT = CAST(LEFT(@CuentaContableHasta + @TOTAL_CEROS, @MAX_LEN) AS INT)
	/******************************************************************************/
	DECLARE @LONGITUD INT = (CASE 
								WHEN @PorGrado = 0 THEN (SELECT MIN(Longitud) FROM Maestro.Grado) 
								ELSE (SELECT TOP 1 Longitud 
										FROM Maestro.Grado 
										WHERE ID = @IdGrado)
							END)	

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
	A.IdEmpresa =  @IdEmpresa AND
	O.Abreviatura NOT IN ('02','03')
	GROUP BY A.ID
	HAVING
		ISNULL(SUM(CASE
						WHEN AD.IdDebeHaber = 1 AND A.IdMoneda = 2 THEN AD.ImporteDolares
						WHEN AD.IdDebeHaber = 1 AND A.IdMoneda = 1 THEN AD.ImporteSoles
					END), 0)
		 <> ISNULL(SUM(CASE
						WHEN AD.IdDebeHaber = 2 AND A.IdMoneda = 2 THEN AD.ImporteDolares
						WHEN AD.IdDebeHaber = 2 AND A.IdMoneda = 1 THEN AD.ImporteSoles
					END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL

	IF(@FlagSaldoInicial = 1)
	BEGIN
	/**/
	SELECT 
		--TEMP.CuentaContable,
		PC.ID,
		TEMP.CuentaContable,
		PC.Nombre,
		TEMP.DebeInicial,
		TEMP.HaberInicial,
		TEMP.Debe,
		TEMP.Haber,
		TEMP.DebeAcumulado,
		TEMP.HaberAcumulado,
		TEMP.Deudor,
		TEMP.Acreedor,
		(CASE WHEN CB.Abreviatura = 'I' THEN TEMP.Deudor ELSE 0 END) AS Activo,
		(CASE WHEN CB.Abreviatura = 'I' THEN TEMP.Acreedor ELSE 0 END) AS Pasivo,
		(CASE WHEN CB.Abreviatura = 'N' OR CB.Abreviatura = 'R' THEN TEMP.Deudor ELSE 0 END) AS PerdidaNaturaleza,
		(CASE WHEN CB.Abreviatura = 'N' OR CB.Abreviatura = 'R' THEN TEMP.Acreedor ELSE 0 END) AS GananciaNaturaleza,
		(CASE WHEN CB.Abreviatura = 'F' OR CB.Abreviatura = 'R' THEN TEMP.Deudor ELSE 0 END) AS PerdidaFuncion,
		(CASE WHEN CB.Abreviatura = 'F' OR CB.Abreviatura = 'R' THEN TEMP.Acreedor ELSE 0 END) AS GananciaFuncion
	FROM
	(SELECT		
		LEFT(PC.CuentaContable, @LONGITUD) CuentaContable,
		ISNULL(SUM(CASE WHEN M.Valor < @VALOR_MES_DESDE THEN CASE AD.IdDebeHaber WHEN 1 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END ELSE 0 END ), 0) AS DebeInicial,
		ISNULL(SUM(CASE WHEN M.Valor < @VALOR_MES_DESDE THEN CASE AD.IdDebeHaber WHEN 2 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END ELSE 0 END ), 0) AS HaberInicial,
		ISNULL(SUM(CASE WHEN M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END ELSE 0 END ), 0) 
AS Debe,
		ISNULL(SUM(CASE WHEN M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END ELSE 0 END ), 0) 
AS Haber,
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END), 0) AS DebeAcumulado,
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END), 0) AS HaberAcumulado,
		(CASE 
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END), 0) -
				 ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END), 0) >= 0 
			THEN 			
				 ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END), 0) -
				 ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END), 0)
			ELSE 0
		END) AS Deudor,
		(CASE 
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END), 0) -
				 ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END), 0) < 0 
			THEN 			
				 ABS(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END), 0) -
				     ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END) END), 0))
			ELSE 0
		END) AS Acreedor
	FROM
	ERP.PlanCuenta PC	
	INNER JOIN ERP.AsientoDetalle AD ON PC.ID = AD.IdPlanCuenta
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID	
	WHERE
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN 0 AND @VALOR_MES_HASTA AND
	(CAST(LEFT(PC.CuentaContable + @TOTAL_CEROS, @MAX_LEN) AS INT) BETWEEN @CC_DESDE AND @CC_HASTA OR @FlagAllCuenta = 1) AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida)
	----------------------
	AND A.FlagBorrador = 0
	AND A.Flag = 1
	AND PC.FlagBorrador = 0
	--AND PC.Flag = 1
	GROUP BY LEFT(PC.CuentaContable, @LONGITUD)
	HAVING LEN(LTRIM(LEFT(PC.CuentaContable, @LONGITUD))) = @LONGITUD) AS TEMP
	INNER JOIN (SELECT * FROM ERP.PlanCuenta 
				WHERE IdEmpresa = @IdEmpresa
				AND FlagBorrador = 0
				--AND Flag = 1
				AND IdAnio = @IdAnio) PC ON PC.CuentaContable = TEMP.CuentaContable
	INNER JOIN Maestro.ColumnaBalance CB ON PC.IdColumnaBalance = CB.ID
	ORDER BY TEMP.CuentaContable

	END
	ELSE
	BEGIN
	/**/
	SELECT 
		--TEMP.CuentaContable,
		PC.ID,
		TEMP.CuentaContable,
		PC.Nombre,
		TEMP.DebeInicial,
		TEMP.HaberInicial,
		TEMP.Debe,
		TEMP.Haber,
		TEMP.DebeAcumulado,
		TEMP.HaberAcumulado,
		TEMP.Deudor,
		TEMP.Acreedor,
		(CASE WHEN CB.Abreviatura = 'I' THEN TEMP.Deudor ELSE 0 END) AS Activo,
		(CASE WHEN CB.Abreviatura = 'I' THEN TEMP.Acreedor ELSE 0 END) AS Pasivo,
		(CASE WHEN CB.Abreviatura = 'N' OR CB.Abreviatura = 'R' THEN TEMP.Deudor ELSE 0 END) AS PerdidaNaturaleza,
		(CASE WHEN CB.Abreviatura = 'N' OR CB.Abreviatura = 'R' THEN TEMP.Acreedor ELSE 0 END) AS GananciaNaturaleza,
		(CASE WHEN CB.Abreviatura = 'F' OR CB.Abreviatura = 'R' THEN TEMP.Deudor ELSE 0 END) AS PerdidaFuncion,
		(CASE WHEN CB.Abreviatura = 'F' OR CB.Abreviatura = 'R' THEN TEMP.Acreedor ELSE 0 END) AS GananciaFuncion
	FROM
	(SELECT		
		LEFT(PC.CuentaContable, @LONGITUD) CuentaContable,
		'0' DebeInicial,
		'0' HaberInicial,
		ISNULL(SUM(CASE WHEN M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END ELSE 0 END ), 0) 
AS Debe,
		ISNULL(SUM(CASE WHEN M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END ELSE 0 END ), 0) 
AS Haber,
		'0' DebeAcumulado,
		'0' HaberAcumulado,
		(CASE
			WHEN ISNULL(SUM(CASE WHEN M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END ELSE 0 END ), 0) -
				 ISNULL(SUM(CASE WHEN M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END ELSE 0 END ), 0) >= 0
			THEN ISNULL(SUM(CASE WHEN M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END ELSE 0 END ), 0) -
				 ISNULL(SUM(CASE WHEN M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END ELSE 0 END ), 0)
			ELSE 0
		END) AS Deudor,
		(CASE
			WHEN ISNULL(SUM(CASE WHEN M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END ELSE 0 END ), 0) -
				 ISNULL(SUM(CASE WHEN M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END ELSE 0 END ), 0) < 0
			THEN ABS(ISNULL(SUM(CASE WHEN M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END ELSE 0 END ), 0) -
				 ISNULL(SUM(CASE WHEN M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END ELSE 0 END ), 0))
			ELSE 0
		END) AS Acreedor
	FROM
	ERP.PlanCuenta PC	
	INNER JOIN ERP.AsientoDetalle AD ON PC.ID = AD.IdPlanCuenta
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID	
	WHERE
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN 0 AND @VALOR_MES_HASTA AND
	(CAST(LEFT(PC.CuentaContable + @TOTAL_CEROS, @MAX_LEN) AS INT) BETWEEN @CC_DESDE AND @CC_HASTA OR @FlagAllCuenta = 1) AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida)
	----------------------
	AND A.FlagBorrador = 0
	AND A.Flag = 1
	AND PC.FlagBorrador = 0
	--AND PC.Flag = 1
	GROUP BY LEFT(PC.CuentaContable, @LONGITUD)
	HAVING LEN(LTRIM(LEFT(PC.CuentaContable, @LONGITUD))) = @LONGITUD
	AND NOT (ISNULL(SUM(CASE WHEN M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END ELSE 0 END ), 0) = 0 AND ISNULL(SUM(CASE WHEN M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN CASE WHEN @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14, 2)) ELSE CAST(AD.ImporteDolares AS DECIMAL(14, 2)) END END ELSE 0 END ), 0)  = 0)
	) AS TEMP
	INNER JOIN (SELECT * FROM ERP.PlanCuenta 
				WHERE IdEmpresa = @IdEmpresa
				AND FlagBorrador = 0
				--AND Flag = 1
				AND IdAnio = @IdAnio) PC ON PC.CuentaContable = TEMP.CuentaContable
	INNER JOIN Maestro.ColumnaBalance CB ON PC.IdColumnaBalance = CB.ID
	ORDER BY TEMP.CuentaContable
	END
END