
CREATE PROCEDURE [ERP].[Usp_Sel_ReporteCaja_Detallado_Consolidado]
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT,
@IdMoneda INT
AS
BEGIN
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	DECLARE @VALOR_MES INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMes)
	DECLARE @MAXIMO_VALOR INT =  (SELECT TOP 1 MAX(Longitud) FROM Maestro.Grado WHERE IdEmpresa = @IdEmpresa AND IdAnio = @IdAnio);

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
		PC.ID,
		O.Abreviatura + RIGHT('0000000' + LTRIM(RTRIM(A.Orden)),7) AS Comprobante,
		ISNULL(AD.Fecha, A.Fecha) AS Fecha, -- FECHA TIPO COMPROBANTE / FECHA EMISION
		ETD.NumeroDocumento AS NumeroDocumento,
		AD.Nombre AS Glosa,
		AD.Documento,			
		ISNULL(TCD.VentaSunat, A.TipoCambio) AS TipoCambio, -- TIPO DE CAMBIO
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END, 0)
			WHEN @IdMoneda = 2 THEN ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END, 0)
		END AS Debe,
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END, 0)
			WHEN @IdMoneda = 2 THEN ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END, 0)
		END AS Haber,
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
	P.IdMes = @IdMes AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	PC.IdGrado IN (SELECT ID FROM Maestro.Grado WHERE Longitud = @MAXIMO_VALOR AND IdEmpresa = @IdEmpresa AND IdAnio = @IdAnio) AND
	PC.CuentaContable LIKE '10%' AND
	---------------------
	A.FlagBorrador = 0 AND
	A.Flag = 1
	ORDER BY PC.ID, O.Abreviatura + RIGHT('0000000' + LTRIM(RTRIM(A.Orden)),7) ASC
END
