
--[ERP].[Usp_Sel_ReporteDiarioAuxiliar_AsientoDetalle]1,8,3,1,1,1
CREATE PROCEDURE [ERP].[Usp_Sel_ReporteDiarioAuxiliar_AsientoDetalle]
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT,
@IdMoneda INT,
@IdOrigen INT,
@IdAsiento INT
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
		AD.ID,
		ISNULL(AD.Fecha, A.Fecha) AS Fecha, -- FECHA TIPO COMPROBANTE
		ISNULL(TCD.VentaSunat, A.TipoCambio) AS TipoCambio, -- TIPO DE CAMBIO
		AD.Nombre AS Glosa,
		ETD.NumeroDocumento AS NumeroDocumento,
		TC.Nombre AS NombreTipoComprobante,
		AD.Documento,
		PC.CuentaContable,
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
	ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN [ERP].[PlanCuenta] PC ON AD.IdPlanCuenta = PC.ID
	LEFT JOIN [ERP].[TipoCambioDiario] TCD ON CAST(AD.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
	LEFT JOIN [PLE].[T10TipoComprobante] TC ON AD.IdTipoComprobante = TC.ID
	LEFT JOIN [ERP].[Entidad] EN ON AD.IdEntidad = EN.ID
	LEFT JOIN [ERP].[EntidadTipoDocumento] ETD ON ETD.IdEntidad = EN.ID	
	WHERE
	A.FlagBorrador = 0 AND
	A.Flag = 1 AND
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	P.IdMes = @IdMes AND
	O.ID = @IdOrigen AND
	A.ID = @IdAsiento AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	---------------------
	ISNULL(A.FlagBorrador, 0) = 0 AND
	A.Flag = 1
	ORDER BY PC.CuentaContable ASC
END
