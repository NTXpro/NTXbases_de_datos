CREATE PROCEDURE [ERP].[Usp_Sel_ReporteMayorAuxiliar_AsientoDetalle]
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT,
@IdMoneda INT,
@IdEntidad INT,
@IdPlanCuenta INT
AS
BEGIN
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	DECLARE @VALOR_MES_HASTA INT = (SELECT Valor 
									FROM Maestro.Mes 
									WHERE ID = @IdMes);

	PRINT @VALOR_MES_HASTA

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
		P.IdMes AS IdMes,
		ISNULL(CASE
					WHEN M.Valor < @VALOR_MES_HASTA THEN 
						CASE 
							WHEN AD.IdDebeHaber = 1 AND @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) 
							WHEN AD.IdDebeHaber = 1 AND @IdMoneda = 2 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) 
						END 
					ELSE 0 
				END, 0) AS DebeMesAnterior,
		ISNULL(CASE 
					WHEN M.Valor < @VALOR_MES_HASTA THEN 
						CASE 
							WHEN AD.IdDebeHaber = 2 AND @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) 
							WHEN AD.IdDebeHaber = 2 AND @IdMoneda = 2 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) 
						END 
					ELSE 0 
				END, 0) AS HaberMesAnterior,
		ISNULL(CASE 
					WHEN M.Valor < @VALOR_MES_HASTA THEN 
						CASE 
							WHEN AD.IdDebeHaber = 1 AND @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) 
							WHEN AD.IdDebeHaber = 1 AND @IdMoneda = 2 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) 
						END 
					ELSE 0 
				END, 0) -
		ISNULL(CASE 
					WHEN M.Valor < @VALOR_MES_HASTA THEN 
						CASE
							WHEN AD.IdDebeHaber = 2 AND @IdMoneda = 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) 
							WHEN AD.IdDebeHaber = 2 AND @IdMoneda = 2 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) 
						END 
					ELSE 0 
				END, 0) AS SaldoInicial,
		AD.ID,
		O.Abreviatura + RIGHT('0000000' + LTRIM(RTRIM(A.Orden)),7) AS Comprobante,
		ISNULL(AD.Fecha, A.Fecha) AS Fecha, -- FECHA TIPO COMPROBANTE
		ETD.NumeroDocumento AS NumeroDocumento,
		CASE @VALOR_MES_HASTA WHEN 0 THEN 'ASIENTO APERTURA' ELSE A.Nombre END AS Glosa,
		TC.Nombre AS NombreTipoComprobante,
		AD.Documento,
		AD.Serie,
		A.TipoCambio AS TipoCambio, -- TIPO DE CAMBIO-
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(CASE WHEN M.Valor = @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) END ELSE 0 END, 0)
			WHEN @IdMoneda = 2 THEN ISNULL(CASE WHEN M.Valor = @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) END ELSE 0 END, 0)
		END AS Debe,
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(CASE WHEN M.Valor = @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN CAST(AD.ImporteSoles AS DECIMAL(14,2)) END ELSE 0 END, 0)
			WHEN @IdMoneda = 2 THEN ISNULL(CASE WHEN M.Valor = @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN CAST(AD.ImporteDolares AS DECIMAL(14,2)) END ELSE 0 END, 0)
		END AS Haber,
		CASE
			WHEN PC.IdMoneda = 2 AND @IdMoneda = 1 THEN ISNULL(CASE WHEN M.Valor = @VALOR_MES_HASTA THEN CASE WHEN AD.IdDebeHaber = 2 THEN AD.ImporteDolares * -1 ELSE AD.ImporteDolares END ELSE 0 END, 0)
			ELSE 0
		END AS Dolares
	FROM
	ERP.PlanCuenta PC
	LEFT JOIN ERP.AsientoDetalle AD ON PC.ID = AD.IdPlanCuenta
	LEFT JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	LEFT JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	LEFT JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	LEFT JOIN Maestro.Mes M ON P.IdMes = M.ID
	LEFT JOIN ERP.TipoCambioDiario TCD ON CAST(AD.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
	LEFT JOIN ERP.Entidad EN ON AD.IdEntidad = EN.ID
	LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = EN.ID	
	LEFT JOIN PLE.T10TipoComprobante TC ON AD.IdTipoComprobante = TC.ID
	WHERE
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN 0 AND @VALOR_MES_HASTA AND
	A.IdEmpresa = @IdEmpresa AND
	PC.IdEmpresa = @IdEmpresa AND
	(@IdEntidad = 0 OR AD.IdEntidad = @IdEntidad) AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	PC.ID = @IdPlanCuenta AND
	ISNULL(AD.FlagBorrador, 0) = 0 AND
	ISNULL(A.FlagBorrador, 0) = 0 AND
	A.Flag = 1
	ORDER BY O.Abreviatura, A.Orden
END