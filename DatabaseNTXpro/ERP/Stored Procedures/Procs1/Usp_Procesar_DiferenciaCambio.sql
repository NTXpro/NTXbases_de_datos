CREATE PROC [ERP].[Usp_Procesar_DiferenciaCambio]
@IdEmpresa INT,
@IdAnio INT,
@IdMesDesde INT,
@IdMesHasta INT,
@IdOrigen INT,
@FlagAllCuenta BIT,
@CuentaContableDesde VARCHAR(25),
@CuentaContableHasta VARCHAR(25),
@IdSistema INT,
@IdMonedaSoles INT,
@IdMonedaDolares INT,
@Identificador VARCHAR(50),
@UsuarioRegistro VARCHAR(250)
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 720000;

	BEGIN -- DECLARACIONES
	
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	INSERT INTO @DataInvalida
	SELECT 
	A.ID AS ID
	FROM ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
	WHERE P.IdAnio = @IdAnio AND
	A.IdEmpresa = @IdEmpresa
	GROUP BY A.ID
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT A.ID FROM ERP.Asiento A
	INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	WHERE AD.ImporteSoles = 0 OR IdPlanCuenta IS NULL

	DECLARE @TABLE_TEMP TABLE(
		ID INT IDENTITY PRIMARY KEY,
		Nombre VARCHAR(255),
		Orden INT,
		Fecha DATETIME,
		IdEmpresa INT,
		IdPeriodo INT,
		IdOrigen INT,
		IdMoneda INT,
		TipoCambio DECIMAL(14,5),
		IdPlanCuenta INT,
		NombreDetalle VARCHAR(255),
		IdEntidad INT,
		IdTipoComprobante INT,
		Serie VARCHAR(10),
		Documento VARCHAR(50),
		IdDebeHaber INT,
		ImporteSoles DECIMAL(14,5),
		ImporteDolares DECIMAL(14,5),
		Abreviatura VARCHAR(50),
		Fase INT,
		Identificador VARCHAR(50));	

	DECLARE @MES_DESDE INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMesDesde);
	DECLARE @MES_HASTA INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMesHasta);
	/******************************************************************************/
	DECLARE @CADENA VARCHAR(30) = '000000000000000000000000000000';
	DECLARE @MAX_LEN INT = (SELECT MAX(LEN(CuentaContable)) FROM ERP.PlanCuenta);
	DECLARE @TOTAL_CEROS VARCHAR(30) = (SELECT SUBSTRING(@CADENA, 1, @MAX_LEN));
	DECLARE @CC_DESDE INT = CAST(LEFT(@CuentaContableDesde + @TOTAL_CEROS, @MAX_LEN) AS INT)
	DECLARE @CC_HASTA INT = CAST(LEFT(@CuentaContableHasta + @TOTAL_CEROS, @MAX_LEN) AS INT)
	/******************************************************************************/
	DECLARE @ID_PERIODO_ENERO INT  = (SELECT TOP 1 P.ID FROM ERP.Periodo P
										INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
										WHERE IdAnio = @IdAnio AND M.Valor = 1);

	END;

	BEGIN -- ELIMINAR ASIENTOS (CABECERA-DETALLE) DE ORIGEN DIFERENCIA DE CAMBIO 

	--DECLARE @DROP_ASIENTO TABLE(ID INT NOT NULL);
	--INSERT INTO @DROP_ASIENTO

	DELETE AD
	FROM ERP.Asiento A
	INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	WHERE 
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN @MES_DESDE AND @MES_HASTA AND
	O.ID = @IdOrigen  AND
	P.ID NOT IN (SELECT P.ID
				FROM ERP.PeriodoSistema PS
				INNER JOIN ERP.Periodo P ON PS.IdPeriodo = P.ID
				WHERE PS.IdSistema = @IdSistema AND PS.IdEmpresa = @IdEmpresa AND PS.FlagCierre = 1)

	DELETE A
	FROM ERP.Asiento A
	--INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	WHERE 
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN @MES_DESDE AND @MES_HASTA AND
	O.ID = @IdOrigen  AND
	P.ID NOT IN (SELECT P.ID
				FROM ERP.PeriodoSistema PS
				INNER JOIN ERP.Periodo P ON PS.IdPeriodo = P.ID
				WHERE PS.IdSistema = @IdSistema AND PS.IdEmpresa = @IdEmpresa AND PS.FlagCierre = 1)

	--DELETE FROM ERP.AsientoDetalle WHERE IdAsiento IN (SELECT ID FROM @DROP_ASIENTO)
	--DELETE FROM ERP.Asiento WHERE ID IN (SELECT ID FROM @DROP_ASIENTO)

	END;
	
	DECLARE @CONTADOR INT = CASE WHEN @MES_DESDE = 0 THEN 1 ELSE @MES_DESDE END; 
	WHILE (@CONTADOR <= @MES_HASTA)
	BEGIN  

		BEGIN -- CALCULAR E INSERTAR ASIENTOS TEMPORALES FASE 1 (CUENTA CONTABLE) 
	
		INSERT INTO @TABLE_TEMP
		SELECT
			TEMP.Nombre,
			0 AS Orden,
			TEMP_TC.Fecha,
			TEMP.IdEmpresa,
			P.ID AS IdPeriodo,
			TEMP.IdOrigen,	
			TEMP.IdMoneda,
			TEMP_TC.VentaSunat As TipoCambio,
			--------------------------------------------------------------------
			TEMP.IdPlanCuenta,
			CONCAT('AJUSTE T/C ', CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END, ' POR ', 
			CAST(ROUND(TEMP.SaldoDolares, 2) AS DECIMAL(18,2)),' DÓLARES') AS NombreDetalle,
			NULL,
			NULL,
			NULL,
			NULL,
			(CASE 
				WHEN ((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) > 0 THEN  1 --TEMP.IdDebeHaber_Contrario
				WHEN ((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) < 0 THEN  2 --TEMP.IdDebeHaber_Defecto
				ELSE 0
			END) AS IdDebeHaber,
			CAST(((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) AS DECIMAL(14,2)) AS ImporteSoles,
			0 AS ImporteDolares,
			(CASE 
				WHEN CAST(((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) AS DECIMAL(14,2)) > 0 THEN 'CGPDC'
				WHEN CAST(((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) AS DECIMAL(14,2)) < 0 THEN 'CPPDC'
				ELSE ''
			END) AS Abreviatura,
			1,
			@Identificador
		FROM
		(SELECT
			'AJUSTE POR DIFERENCIA DE CAMBIO' AS Nombre,
			@IdEmpresa AS IdEmpresa,
			@CONTADOR AS Valor,
			@IdOrigen AS IdOrigen,
			@IdMonedaSoles AS IdMoneda,
			-------------------------------------------
			PC.ID AS IdPlanCuenta,
			PC.CuentaContable, 
			PC.IdTipoCambio,
			CAST((ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)) AS DECIMAL(14,2)) AS Saldo,
			CAST((ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN ROUND(AD.ImporteDolares, 2) END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN ROUND(AD.ImporteDolares, 2) END), 0)) AS DECIMAL(14,2)) AS SaldoDolares
		FROM ERP.Asiento A
		INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
		INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
		INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
		INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
		WHERE
		A.IdEmpresa = @IdEmpresa AND
		P.IdAnio = @IdAnio AND
		M.Valor BETWEEN 0 AND @CONTADOR AND
		(CAST(LEFT(PC.CuentaContable + @TOTAL_CEROS, @MAX_LEN) AS INT) BETWEEN @CC_DESDE AND @CC_HASTA OR @FlagAllCuenta = 1) AND
		PC.IdMoneda = @IdMonedaDolares AND
		ISNULL(PC.EstadoAnalisis, 0) = 0 AND
		A.FlagBorrador = 0 AND
		A.Flag = 1 AND
		A.ID NOT IN (SELECT ID FROM @DataInvalida)
		GROUP BY
			PC.CuentaContable,
			PC.IdTipoCambio,
			PC.ID,
			P.IdAnio
		HAVING
		(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN ROUND(AD.ImporteDolares, 2) END), 0) - 
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN ROUND(AD.ImporteDolares, 2) END), 0)) = 0 ) AS TEMP
		INNER JOIN [ERP].[Fn_TipoCambio_MaxValue_Periodo](@IdAnio) TEMP_TC ON TEMP.Valor = TEMP_TC.Valor
		INNER JOIN Maestro.Mes M ON TEMP.Valor = M.Valor
		INNER JOIN ERP.Periodo P ON M.ID = P.IdMes AND P.IdAnio = @IdAnio
		WHERE CAST(((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) AS DECIMAL(14,2))  != 0

		END;

		BEGIN -- CALCULAR E INSERTAR ASIENTOS TEMPORALES FASE 2 (ENTIDAD, TIPO DOCUMENTO, SERIE Y DOCUMENTO) 
	
		INSERT INTO @TABLE_TEMP
		SELECT
			TEMP.Nombre,
			0 AS Orden,
			TEMP_TC.Fecha,
			TEMP.IdEmpresa,
			P.ID AS IdPeriodo,
			TEMP.IdOrigen,	
			TEMP.IdMoneda,
			TEMP_TC.VentaSunat As TipoCambio,
			--------------------------------------------------------------------
			TEMP.IdPlanCuenta,
			CONCAT('AJUSTE T/C ', CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END, ' POR ', 
			CAST(ROUND(TEMP.SaldoDolares, 2) AS DECIMAL(18,2)),' DÓLARES') AS NombreDetalle,
			TEMP.IdEntidad,
			NULL IdTipoComprobante,
			TEMP.Serie,
			TEMP.Documento,
			(CASE 
				WHEN CAST(((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) AS DECIMAL(14,2)) > 0 THEN  1 --TEMP.IdDebeHaber_Contrario
				WHEN CAST(((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) AS DECIMAL(14,2)) < 0 THEN  2 --TEMP.IdDebeHaber_Defecto
				ELSE 0
			END) AS IdDebeHaber,
			CAST(((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) AS DECIMAL(14,2)) AS ImporteSoles,
			0 AS ImporteDolares,
			(CASE 
				WHEN CAST(((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) AS DECIMAL(14,2)) > 0 THEN 'CGPDC'
				WHEN CAST(((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) AS DECIMAL(14,2)) < 0 THEN 'CPPDC'
				ELSE ''
			END) AS Abreviatura,
			2,
			@Identificador
		FROM
		(SELECT
			'AJUSTE POR DIFERENCIA DE CAMBIO' AS Nombre,
			@IdEmpresa AS IdEmpresa,
			@CONTADOR AS Valor,
			@IdOrigen AS IdOrigen,
			@IdMonedaSoles AS IdMoneda,
			-------------------------------------------
			PC.ID AS IdPlanCuenta,
			PC.CuentaContable,
			PC.IdTipoCambio,
			AD.IdEntidad,
			'' AS Serie,--ISNULL(AD.Serie, '') AS Serie, 
			ISNULL(AD.Documento, '') AS Documento,
			CAST((ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)) AS DECIMAL(14,2)) AS Saldo,
			CAST((ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN ROUND(AD.ImporteDolares, 2) END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN ROUND(AD.ImporteDolares, 2) END), 0)) AS DECIMAL(14,2)) AS SaldoDolares
		FROM ERP.Asiento A
		INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
		INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
		INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
		INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
		WHERE
		A.IdEmpresa = @IdEmpresa AND
		P.IdAnio = @IdAnio AND
		M.Valor BETWEEN 0 AND @CONTADOR AND
		(CAST(LEFT(PC.CuentaContable + @TOTAL_CEROS, @MAX_LEN) AS INT) BETWEEN @CC_DESDE AND @CC_HASTA OR @FlagAllCuenta = 1) AND
		PC.IdMoneda = @IdMonedaDolares AND
		PC.EstadoAnalisis = 1 AND
		A.FlagBorrador = 0 AND
		A.Flag = 1 AND
		A.ID NOT IN (SELECT ID FROM @DataInvalida)
		GROUP BY 
			PC.CuentaContable,
			PC.IdTipoCambio,
			AD.IdEntidad,
			--ISNULL(AD.Serie, ''), 
			--AD.IdTipoComprobante,
			ISNULL(AD.Documento, ''),
			PC.ID,
			P.IdAnio) AS TEMP
		INNER JOIN [ERP].[Fn_TipoCambio_MaxValue_Periodo](@IdAnio) TEMP_TC ON TEMP.Valor = TEMP_TC.Valor
		INNER JOIN Maestro.Mes M ON TEMP.Valor = M.Valor
		INNER JOIN ERP.Periodo P ON M.ID = P.IdMes AND P.IdAnio = @IdAnio
		WHERE CAST(((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) AS DECIMAL(14,2))  != 0

		END;
		
		BEGIN -- CALCULAR E INSERTAR ASIENTOS TEMPORALES FASE 3 (CUENTA CONTABLE) 
	
		INSERT INTO @TABLE_TEMP
		SELECT
			TEMP.Nombre,
			0 AS Orden,
			TEMP_TC.Fecha,
			TEMP.IdEmpresa,
			P.ID AS IdPeriodo,
			TEMP.IdOrigen,	
			TEMP.IdMoneda,
			TEMP_TC.VentaSunat As TipoCambio,
			--------------------------------------------------------------------
			TEMP.IdPlanCuenta,
			CONCAT('AJUSTE T/C ', CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END, ' POR ', 
			CAST(ROUND(TEMP.SaldoDolares, 2) AS DECIMAL(18,2)) ,' DÓLARES') AS NombreDetalle,
			NULL,
			NULL,
			NULL,
			NULL,
			(CASE 
				WHEN CAST(((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) AS DECIMAL(14,2)) > 0 THEN  1 --TEMP.IdDebeHaber_Contrario
				WHEN CAST(((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) AS DECIMAL(14,2)) < 0 THEN  2 --TEMP.IdDebeHaber_Defecto
				ELSE 0
			END) AS IdDebeHaber,
			CAST(((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) AS DECIMAL(14,2)) AS ImporteSoles,
			0 AS ImporteDolares,
			(CASE 
				WHEN CAST(((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) AS DECIMAL(14,2)) > 0 THEN 'CGPDC'
				WHEN CAST(((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) AS DECIMAL(14,2)) < 0 THEN 'CPPDC'
				ELSE ''
			END) AS Abreviatura,
			3,
			@Identificador
		FROM
		(SELECT
			'AJUSTE POR DIFERENCIA DE CAMBIO' AS Nombre,
			@IdEmpresa AS IdEmpresa,
			@CONTADOR AS Valor,
			@IdOrigen AS IdOrigen,
			@IdMonedaSoles AS IdMoneda,
			-------------------------------------------
			PC.ID AS IdPlanCuenta,
			PC.CuentaContable,
			PC.IdTipoCambio,
			CAST((ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)) AS DECIMAL(14,2)) AS Saldo,
			CAST((ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN ROUND(AD.ImporteDolares, 2) END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN ROUND(AD.ImporteDolares, 2) END), 0)) AS DECIMAL(14,2)) AS SaldoDolares
		FROM ERP.Asiento A
		INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
		INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
		INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
		INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
		WHERE
		A.IdEmpresa = @IdEmpresa AND
		P.IdAnio = @IdAnio AND
		M.Valor BETWEEN 0 AND @CONTADOR AND
		(CAST(LEFT(PC.CuentaContable + @TOTAL_CEROS, @MAX_LEN) AS INT) BETWEEN @CC_DESDE AND @CC_HASTA OR @FlagAllCuenta = 1) AND
		PC.IdMoneda = @IdMonedaDolares AND
		ISNULL(PC.EstadoAnalisis, 0) = 0 AND
		A.FlagBorrador = 0 AND
		A.Flag = 1 AND
		A.ID NOT IN (SELECT ID FROM @DataInvalida)
		GROUP BY
			PC.CuentaContable,
			PC.IdTipoCambio,
			PC.ID,
			P.IdAnio) AS TEMP
		INNER JOIN [ERP].[Fn_TipoCambio_MaxValue_Periodo](@IdAnio) TEMP_TC ON TEMP.Valor = TEMP_TC.Valor
		INNER JOIN Maestro.Mes M ON TEMP.Valor = M.Valor
		INNER JOIN ERP.Periodo P ON M.ID = P.IdMes AND P.IdAnio = @IdAnio
		WHERE CAST(((TEMP.SaldoDolares * CASE WHEN TEMP.IdTipoCambio = 1 THEN TEMP_TC.CompraSunat ELSE TEMP_TC.VentaSunat END) - TEMP.Saldo) AS DECIMAL(14,2))  != 0

		END;
		
		BEGIN -- INSERTAR ASIENTO DETALLE

			INSERT INTO [ERP].[AsientoDetalle] (
				IdAsiento,
				Orden,
				IdPlanCuenta,
				Nombre,
				IdEntidad,
				IdTipoComprobante,
				Serie,
				Documento,
				ImporteSoles,
				ImporteDolares,
				IdDebeHaber,
				Fecha,
				IdentificadorProceso)
			SELECT
				NULL AS IdAsiento,
				TEMP_ASIENTO.Orden,
				TEMP_ASIENTO.IdPlanCuenta,
				TEMP_ASIENTO.NombreDetalle,
				TEMP_ASIENTO.IdEntidad,
				TEMP_ASIENTO.IdTipoComprobante, 
				TEMP_ASIENTO.Serie, 
				TEMP_ASIENTO.Documento,
				TEMP_ASIENTO.ImporteSoles,
				TEMP_ASIENTO.ImporteDolares,
				TEMP_ASIENTO.IdDebeHaber,
				TEMP_ASIENTO.Fecha,
				CONCAT(TEMP_ASIENTO.ID, @Identificador, @CONTADOR)
			FROM
			(SELECT  
				T.ID,
				T.Nombre,
				1 AS Orden,
				T.Fecha,
				T.IdEmpresa,
				T.IdPeriodo,
				T.IdOrigen,
				T.IdMoneda,
				T.TipoCambio,
				T.IdPlanCuenta,
				T.NombreDetalle,
				T.IdEntidad,
				T.IdTipoComprobante,
				T.Serie,
				T.Documento,
				T.IdDebeHaber,
				ABS(T.ImporteSoles) AS ImporteSoles,
				T.ImporteDolares,
				T.IdPlanCuenta AS IdPlanCuentaOrigen,
				T.Identificador
			FROM @TABLE_TEMP AS T
			UNION ALL
			SELECT  
				T.ID,
				T.Nombre,
				2 AS Orden,
				T.Fecha,
				T.IdEmpresa,
				T.IdPeriodo,
				T.IdOrigen,
				T.IdMoneda,
				T.TipoCambio,
				(CASE WHEN TP.IdPlanCuenta IS NULL THEN TP.IdPlanCuentaAnterior ELSE TP.IdPlanCuenta END) AS IdPlanCuenta,
				(CASE 
					WHEN ImporteSoles < 0 THEN 'PERDIDA POR DIFERENCIA DE CAMBIO'
					WHEN ImporteSoles > 0 THEN 'GANANCIA POR DIFERENCIA DE CAMBIO'
				END) AS NombreDetalle,
				T.IdEntidad,
				T.IdTipoComprobante,
				T.Serie,
				T.Documento,
				(CASE T.IdDebeHaber WHEN 1 THEN 2 ELSE 1 END) AS IdDebeHaber,
				ABS(T.ImporteSoles) AS ImporteSoles,
				T.ImporteDolares,
				T.IdPlanCuenta AS IdPlanCuentaOrigen,
				T.Identificador
			FROM @TABLE_TEMP AS T
			INNER JOIN [ERP].[Fn_PlanCuenta_MaxValue_Periodo](@IdEmpresa, @IdAnio, 'CGPDC', 'CPPDC') TP ON T.IdPeriodo = TP.IdPeriodo AND T.Abreviatura = TP.Abreviatura
			) AS TEMP_ASIENTO
			ORDER BY ID, Orden

		END;

		BEGIN -- INSERTAR ASIENTO CABECERA

			INSERT INTO [ERP].[Asiento]
				([Nombre]
				,[Orden]
				,[Fecha]
				,[IdEmpresa]
				,[IdPeriodo]
				,[IdOrigen]
				,[IdMoneda]
				,[TipoCambio]
				,[UsuarioRegistro]
				,[FechaRegistro]
				,[FlagEditar]
				,[FlagBorrador]
				,[Flag]
				,[IdentificadorProceso])
			SELECT  
				 T.Nombre,
				 NULL AS Orden,
				 T.Fecha,
				 T.IdEmpresa,
				 T.IdPeriodo, --CASE WHEN M.Valor = 0 THEN @ID_PERIODO_ENERO ELSE T.IdPeriodo END,
				 T.IdOrigen,
				 T.IdMoneda,
				 T.TipoCambio,
				 @UsuarioRegistro,
				 GETDATE(),
				 0 AS FlagEditar, -- ESTA OPCIÓN AUN NO ESTA DEFINIDA Y SE REALIZARA FUTURAMENTE
				 0 AS FlagBorrador,
				 1 AS Flag,
				 CONCAT(T.ID, @Identificador, @CONTADOR)
			FROM @TABLE_TEMP T
			INNER JOIN ERP.Periodo P ON T.IdPeriodo = P.ID
			INNER JOIN Maestro.Mes M ON P.IdMes = M.ID

		END;

		BEGIN -- ASOCIAR ASIENTO DETALLE CON ASIENTOS CABECERA POR FOREANA
			UPDATE AD SET
			AD.IdAsiento = A.ID,
			AD.IdentificadorProceso = NULL
			FROM ERP.AsientoDetalle AS AD
			INNER JOIN ERP.Asiento A ON AD.IdentificadorProceso = A.IdentificadorProceso
			WHERE A.IdentificadorProceso LIKE '%' + @Identificador + '%'
		END;

		BEGIN -- ACTUALIZAR ORDEN DE ASIENTO CABECERA POR PERIODO (SOLO ASIENTO PROCESADOS EN ESTE QUERY)
			UPDATE A SET 
			A.Orden = TEMP.Orden,
			A.IdentificadorProceso = NULL
			FROM ERP.Asiento A
			INNER JOIN
			(SELECT
			A.ID,
			(ROW_NUMBER() OVER(PARTITION BY A.IdPeriodo ORDER BY A.ID ASC)) AS Orden
			FROM ERP.Asiento A
			INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
			INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
			WHERE
			A.IdentificadorProceso LIKE '%' + @Identificador + '%' AND 
			A.IdOrigen = @IdOrigen AND
			A.IdEmpresa = @IdEmpresa AND
			A.Flag = 1 AND
			A.FlagBorrador = 0 AND
			P.IdAnio = @IdAnio AND
			M.Valor = @CONTADOR) AS Temp ON A.ID = TEMP.ID
		END;

		DELETE FROM @TABLE_TEMP;

		SET @CONTADOR += 1
	END 

	SELECT 1;
END