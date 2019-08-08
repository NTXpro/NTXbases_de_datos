CREATE PROCEDURE [ERP].[Usp_Sel_LibroDiarioPLE]
@IdAnio INT,
@IdMes INT,
@IdEmpresa INT
AS
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	DECLARE @ValorMes INT;

	SELECT @ValorMes = Valor
	FROM Maestro.Mes
	WHERE ID = @IdMes

	INSERT INTO @DataInvalida
	SELECT 
	A.ID AS ID
	FROM ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	WHERE P.IdAnio = @IdAnio 
	AND P.IdMes = @IdMes
	AND A.IdEmpresa = @IdEmpresa
	AND O.Abreviatura NOT IN ('02','03')
	GROUP BY A.ID
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL
	
	SELECT AN.Nombre + RIGHT('00' + CAST((CASE 
											WHEN M.Valor > 12 THEN 12 
											WHEN M.Valor = 0 THEN 1 
											ELSE M.Valor END) AS VARCHAR(255)), 2) + '00' Periodo,
			CAST(ROW_NUMBER() OVER(PARTITION BY A.IdOrigen ORDER BY (SELECT NULL) ASC) AS VARCHAR(255)) + O.Abreviatura + RIGHT('0000000' + CAST(A.Orden AS VARCHAR(255)), 7) CUO,
			'M' + O.Abreviatura + RIGHT('0000000' + CAST(A.Orden AS VARCHAR(255)), 7) CorrelativoAC,
			PC.CuentaContable CuentaContable,
			MO.CodigoSunat Moneda,
			LTRIM(RTRIM(CAST(ISNULL(T2.CodigoSunat, '') AS VARCHAR(2)))) TipoDocEmisor,
			ISNULL(ETD.NumeroDocumento,'') NroDocEmisor,
			CASE
				WHEN T10.CodigoSunat IS NULL THEN '00'
				WHEN T10.CodigoSunat = 93 THEN '00'
				WHEN T10.CodigoSunat = 72 THEN '00'
				ELSE T10.CodigoSunat
			END TipoDocumentoAsociado,
			CASE
				WHEN T10.CodigoSunat = '50' THEN CAST(CAST(AD.Serie AS INT) AS VARCHAR(255))
				WHEN T10.CodigoSunat = '05' THEN '4'
				WHEN AD.Serie IS NULL THEN ''
				WHEN LEFT(AD.Serie, 1) = 'F' THEN UPPER(AD.Serie)
				WHEN LEFT(AD.Serie, 1) = 'B' THEN UPPER(AD.Serie)
				WHEN LEFT(AD.Serie, 1) = 'E' THEN UPPER(AD.Serie)
				WHEN LEFT(AD.Serie, 1) = 'T' THEN '0' + RIGHT(AD.Serie, 3)				
				ELSE AD.Serie END SerieAsociado,
			CASE 
				WHEN T10.CodigoSunat = 50 THEN CAST(CAST(AD.Documento AS INT) AS VARCHAR(255))
				ELSE ISNULL(NULLIF(RIGHT(AD.Documento, 8), ''), A.Orden) END NroDocumentoAsociado,
			A.Fecha FechaOperacion,
			AD.Nombre GlosaOperacion,
			CASE WHEN IdDebeHaber = 1
				THEN AD.ImporteSoles
					/*CASE WHEN A.IdMoneda = 1 THEN AD.ImporteSoles
					ELSE AD.ImporteDolares END*/
			ELSE 0 END Debe,
			CASE WHEN IdDebeHaber = 2
				THEN AD.ImporteSoles
					/*CASE WHEN A.IdMoneda = 1 THEN AD.ImporteSoles
					ELSE AD.ImporteDolares END*/
			ELSE 0 END Haber
	FROM ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID	
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	INNER JOIN Maestro.Moneda MO ON A.IdMoneda = MO.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	LEFT JOIN ERP.Entidad E ON E.ID = AD.IdEntidad
	LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID
	LEFT JOIN PLE.T2TipoDocumento T2 ON ETD.IdTipoDocumento = T2.ID
	LEFT JOIN PLE.T10TipoComprobante T10 ON T10.ID = AD.IdTipoComprobante
	WHERE A.Flag = 1
	AND A.FlagBorrador = 0
	AND (P.IdMes = @IdMes
			OR CASE WHEN @ValorMes = 1 THEN 0 ELSE -1 END = M.Valor
			OR CASE WHEN @ValorMes = 12 THEN 13 ELSE -1 END = M.Valor
			OR CASE WHEN @ValorMes = 12 THEN 14 ELSE -1 END = M.Valor
			OR CASE WHEN @ValorMes = 12 THEN 15 ELSE -1 END = M.Valor)
	AND P.IdAnio = @IdAnio
	AND A.IdEmpresa = @IdEmpresa
	AND A.ID NOT IN (SELECT ID FROM @DataInvalida)	
	ORDER BY O.Abreviatura, A.Orden ASC