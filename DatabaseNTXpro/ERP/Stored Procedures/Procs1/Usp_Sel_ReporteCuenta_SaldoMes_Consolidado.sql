
CREATE PROCEDURE [ERP].[Usp_Sel_ReporteCuenta_SaldoMes_Consolidado]
@IdEmpresa INT,
@IdAnio INT,
@CuentaContable VARCHAR(25),
@IdMoneda INT
AS
BEGIN
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);

	INSERT INTO @DataInvalida
	SELECT 
	A.ID AS ID
	FROM ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	WHERE 
	P.IdAnio = @IdAnio AND
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
		AD.ID,
		O.Abreviatura + RIGHT('0000000' + LTRIM(RTRIM(A.Orden)),7) AS Comprobante,
		ISNULL(AD.Fecha, A.Fecha) AS Fecha, -- FECHA TIPO COMPROBANTE Ó EMISIÓN DE DOCUMENTO
		AD.Nombre AS Glosa,
		TC.Nombre AS NombreTipoComprobante,
		AD.Serie,
		AD.Documento,
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END, 0)
			WHEN @IdMoneda = 2 THEN ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END, 0)
		END AS Debe,
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END, 0)
			WHEN @IdMoneda = 2 THEN ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END, 0)
		END AS Haber,
		ISNULL(TCD.VentaSunat, A.TipoCambio) AS TipoCambio
	FROM ERP.AsientoDetalle AD
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	LEFT JOIN ERP.TipoCambioDiario TCD ON CAST(AD.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
	LEFT JOIN ERP.Entidad EN ON AD.IdEntidad = EN.ID
	LEFT JOIN PLE.T10TipoComprobante TC ON AD.IdTipoComprobante = TC.ID
	WHERE
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	PC.CuentaContable = @CuentaContable AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	---------------------
	A.FlagBorrador = 0 AND
	A.Flag = 1
	ORDER BY M.Valor,O.Abreviatura, A.Orden
END
