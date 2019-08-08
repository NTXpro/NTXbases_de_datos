﻿
CREATE PROCEDURE [ERP].[Usp_Sel_ReporteMayorProyecto_AsientoDetalle]
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT,
@IdMesHasta INT,
@IdMoneda INT,
@IdEntidad INT,
@IdProyectoDetalle INT,
@IdPlanCuenta INT
AS
BEGIN
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	DECLARE @VALOR_MES_DESDE INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMes);
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
	M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA AND
	A.IdEmpresa = @IdEmpresa AND
	O.Abreviatura NOT IN ('02','03')
	GROUP BY A.ID
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL

	SELECT
		AN.Nombre AS NombreAnio,
		RIGHT('00' + LTRIM(RTRIM(M.Valor)),2) AS Valor,
		PC.CuentaContable,
		O.Abreviatura + RIGHT('0000000' + LTRIM(RTRIM(A.Orden)),7) AS Comprobante,
		A.Orden AS OrdenCabecera,
		O.Abreviatura,
		ISNULL(AD.Fecha, A.Fecha) AS Fecha, -- FECHA TIPO COMPROBANTE Ó EMISIÓN DE DOCUMENTO
		A.Nombre AS Glosa,
		TC.Nombre AS NombreTipoComprobante,
		AD.Serie,
		AD.Documento,
		ISNULL(TCD.VentaSunat, A.TipoCambio) AS TipoCambio, -- TIPO DE CAMBIO-
		ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END, 0) AS Debe,
		ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END, 0) AS Haber
	FROM
	ERP.Proyecto PR
	INNER JOIN ERP.AsientoDetalle AD ON PR.ID = AD.IdProyecto
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	LEFT JOIN ERP.TipoCambioDiario TCD ON CAST(AD.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
	LEFT JOIN [PLE].[T10TipoComprobante] TC ON AD.IdTipoComprobante = TC.ID
	WHERE
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN @VALOR_MES_DESDE AND @VALOR_MES_HASTA AND
	A.IdEmpresa = @IdEmpresa AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	PR.ID = @IdProyectoDetalle AND
	PC.ID = @IdPlanCuenta AND
	---------------------
	ISNULL(A.FlagBorrador, 0) = 0 AND
	A.Flag = 1
	ORDER BY AN.Nombre, M.Valor
END