CREATE PROCEDURE [ERP].[Usp_Sel_Analisis_Consolidado] 
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT,
@IdMoneda INT,
@IdEstado INT,
@FlagAllCuenta BIT,
@CuentaContableDesde VARCHAR(25),
@CuentaContableHasta VARCHAR(25),
@IdEntidad INT,
@IdPlanCuenta INT,
@IdEntidadDetalle INT
AS
BEGIN
	DECLARE @MaximoValor INT = (SELECT TOP 1 MAX(Longitud) FROM Maestro.Grado)
	DECLARE @VALOR_MES_HASTA INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMes)
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
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
	INNER JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
	WHERE P.IdAnio = @IdAnio AND
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
		PC.Nombre AS NombrePlanCuenta,
		-----------------------
		EN.ID AS IdEntidad,
		RTRIM(LTRIM(EN.Nombre)) AS NombreCompleto,
		TD.Abreviatura AS NombreTipoDocumento,
		ETD.NumeroDocumento AS NumeroDocumento,
		-----------------------
		A.ID AS IdAsiento,
		AN.ID AS IdAnio,
		AN.Nombre AS NombreAnio,
		M.ID AS IdMes,
		M.Nombre AS NombreMes,
		RIGHT('00' + Ltrim(Rtrim(M.Valor)),2) AS ValorMes,
		A.Orden AS OrdenCabecera,
		A.IdOrigen,
		O.Nombre AS NombreOrigen,
		O.Abreviatura AS AbreviaturaOrigen,
		A.Nombre AS GlosaCabecera,
		------------ DETALLE -------------
		AD.ID AS IdAsientoDetalle,
		AD.IdPlanCuenta,
		AD.IdEntidad,
		AD.IdTipoComprobante,
		UPPER(AD.Serie) AS Serie,
		AD.Orden AS OrdenDetalle,
		CONCAT(O.Abreviatura + RIGHT('0000000' + LTRIM(RTRIM(A.Orden)),7), ' - ', A.Nombre) AS Comprobante,
		ISNULL(AD.Fecha, A.Fecha) AS FechaEmision, -- FECHA TIPO COMPROBANTE
		--AD.Nombre AS GlosaDetalle,
		A.Nombre AS GlosaDetalle,
		RIGHT('00000000' + Documento, 8) AS DocumentoDetalle,
		ISNULL(TCD.VentaSunat, A.TipoCambio) AS VentaSunatDetalle,
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END, 0)
			WHEN @IdMoneda = 2 THEN ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END, 0)
		END AS Debe,
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END, 0)
			WHEN @IdMoneda = 2 THEN ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END, 0)
		END AS Haber,
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END, 0)
			WHEN @IdMoneda = 2 THEN ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END, 0)
		END -
		CASE 
			WHEN @IdMoneda = 1 THEN ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END, 0)
			WHEN @IdMoneda = 2 THEN ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END, 0)
		END AS Saldo,
		CASE
			WHEN PC.IdMoneda = 2 AND @IdMoneda = 1 THEN ISNULL(CASE WHEN AD.IdDebeHaber = 2 THEN AD.ImporteDolares * -1 ELSE AD.ImporteDolares END, 0)
			ELSE 0
		END AS Dolares
	FROM ERP.Asiento A
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	LEFT JOIN [ERP].[TipoCambioDiario] TCD ON CAST(AD.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
	--------------------- ENTIDAD -----------------------
	INNER JOIN ERP.Entidad EN ON AD.IdEntidad = EN.ID
	INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = EN.ID
	INNER JOIN PLE.T2TipoDocumento TD ON TD.ID = ETD.IdTipoDocumento
	WHERE
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN 0 AND @VALOR_MES_HASTA AND
	A.IdEmpresa = @IdEmpresa AND
	(@IdEntidad = 0 OR AD.IdEntidad = @IdEntidad) AND 
	PC.EstadoAnalisis = 1 AND
	ISNULL(A.FlagBorrador, 0) = 0 AND
	A.Flag = 1 AND
	(CAST(LEFT(PC.CuentaContable + @TOTAL_CEROS, @MAX_LEN) AS INT) BETWEEN @CC_DESDE AND @CC_HASTA OR @FlagAllCuenta = 1) AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida) AND
	(@IdPlanCuenta = 0 OR PC.ID = @IdPlanCuenta) AND
	(@IdEntidadDetalle = 0 OR EN.ID = @IdEntidadDetalle)
	ORDER BY 
	PC.CuentaContable,
	CAST(AN.Nombre AS INT), 
	M.Valor,
	AD.Fecha,
	AD.Documento
END