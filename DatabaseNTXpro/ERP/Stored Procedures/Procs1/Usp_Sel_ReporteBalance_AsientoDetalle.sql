CREATE PROCEDURE [ERP].[Usp_Sel_ReporteBalance_AsientoDetalle] -- 1,8,3,4,1,1,'','',1,5
@IdEmpresa INT,
@IdAnio INT,
@IdMesDesde INT,
@IdMesHasta INT,
@IdMoneda INT,
@CuentaContable VARCHAR(25),
@IdPeriodo INT,
@IdOrigen INT
AS
BEGIN
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	DECLARE @VALOR_MES_DESDE INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMesDesde);
	DECLARE @VALOR_MES_HASTA INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMesHasta);

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
	P.ID = @IdPeriodo AND
	A.IdEmpresa = @IdEmpresa AND
	O.ID = @IdOrigen AND
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
	--ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	--ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL

	SELECT 
		A.ID,
		O.Abreviatura + RIGHT('0000000' + LTRIM(RTRIM(A.Orden)),7) AS Comprobante,
		ISNULL(AD.Fecha, A.Fecha) AS Fecha,
		ETD.NumeroDocumento AS NumeroDocumento,
		AD.Nombre AS Glosa,
		AD.Documento,			
		ISNULL(TCD.VentaSunat, A.TipoCambio) AS TipoCambio,
		ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN @IdMoneda = 1 THEN AD.ImporteSoles ELSE AD.ImporteDolares END) END, 0) AS Debe,
		ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN @IdMoneda = 1 THEN AD.ImporteSoles ELSE AD.ImporteDolares END) END, 0) AS Haber,
		CASE
			WHEN PC.IdMoneda = 2 AND @IdMoneda = 1 THEN ISNULL(CASE WHEN AD.IdDebeHaber = 2 THEN AD.ImporteDolares * -1 ELSE AD.ImporteDolares END, 0)
			ELSE 0
		END AS Dolares
	FROM
	ERP.Asiento A
	INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	LEFT JOIN ERP.Entidad EN ON AD.IdEntidad = EN.ID
	LEFT JOIN [ERP].[TipoCambioDiario] TCD ON CAST(AD.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
	LEFT JOIN [PLE].[T10TipoComprobante] TC ON AD.IdTipoComprobante = TC.ID
	LEFT JOIN [ERP].[EntidadTipoDocumento] ETD ON ETD.IdEntidad = EN.ID	
	WHERE
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	PC.CuentaContable LIKE @CuentaContable + '%' AND
	P.ID = @IdPeriodo AND
	O.ID = @IdOrigen AND
	ISNULL(A.FlagBorrador, 0) = 0 AND
	A.Flag = 1
	ORDER BY
	A.Fecha,
	O.Abreviatura + RIGHT('0000000' + LTRIM(RTRIM(A.Orden)),7) ASC
END