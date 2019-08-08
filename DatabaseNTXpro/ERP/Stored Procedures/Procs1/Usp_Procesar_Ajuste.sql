CREATE PROC [ERP].[Usp_Procesar_Ajuste]
@IdEmpresa INT,
@IdAnio INT,
@IdMesDesde INT,
@IdMesHasta INT,
@IdOrigen INT,
@FlagAllCuenta BIT,
@CuentaContableDesde VARCHAR(50),
@CuentaContableHasta VARCHAR(50),
@IdMonedaSoles INT,
@IdSistema INT,
@Identificador VARCHAR(50),
@UsuarioRegistro VARCHAR(250)
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000;

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

	END;

	BEGIN -- ELIMINAR ASIENTOS (CABECERA-DETALLE) DE ORIGEN AJUSTE DE CAMBIO 

	DECLARE @DROP_ASIENTO TABLE(ID INT NOT NULL);
	INSERT INTO @DROP_ASIENTO
	SELECT A.ID FROM ERP.Asiento A
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

	DELETE FROM ERP.AsientoDetalle WHERE IdAsiento IN (SELECT ID FROM @DROP_ASIENTO)
	DELETE FROM ERP.Asiento WHERE ID IN (SELECT ID FROM @DROP_ASIENTO)

	END;

	DECLARE @CONTADOR INT = CASE WHEN @MES_DESDE = 0 THEN 1 ELSE @MES_DESDE END; 
	WHILE (@CONTADOR <= @MES_HASTA)
	BEGIN  

		BEGIN -- CALCULAR E INSERTAR ASIENTOS TEMPORALES (ENTIDAD, TIPO DOCUMENTO, SERIE Y DOCUMENTO) 
	
		INSERT INTO @TABLE_TEMP

		SELECT
			TEMP.Nombre,
			TEMP_TC.Fecha,
			TEMP.IdEmpresa,
			P.ID AS IdPeriodo,
			TEMP.IdOrigen,	
			TEMP.IdMoneda,
			TEMP_TC.VentaSunat As TipoCambio,
			--------------------------------------------------------------------
			TEMP.IdPlanCuenta,
			(CASE WHEN TEMP.Saldo > 0 THEN 'GANANCIA POR AJUSTE DE CUENTA' WHEN TEMP.Saldo < 0 THEN 'PERDIDA POR AJUSTE DE CUENTA' ELSE ''END) AS NombreDetalle,
			TEMP.IdEntidad,
			TEMP.IdTipoComprobante,
			TEMP.Serie,
			TEMP.Documento,
			(CASE WHEN TEMP.Saldo > 0 THEN 2 WHEN TEMP.Saldo < 0 THEN 1 ELSE 0 END) AS IdDebeHaber,
			ABS(TEMP.Saldo) AS ImporteSoles,
			0 AS ImporteDolares,
			(CASE WHEN TEMP.Saldo > 0 THEN 'CGPAC' WHEN TEMP.Saldo < 0 THEN 'CPPAC' ELSE '' END) AS Abreviatura,
			@Identificador
		FROM
		(SELECT
			'AJUSTE DE CUENTA' AS Nombre,
			@IdEmpresa AS IdEmpresa,
			@CONTADOR Valor,
			@IdOrigen AS IdOrigen,
			@IdMonedaSoles AS IdMoneda,
			-------------------------------------------
			PC.ID AS IdPlanCuenta,
			PC.CuentaContable,
			AD.IdEntidad, 
			NULL AS IdTipoComprobante, --AD.IdTipoComprobante,
			AD.Serie, 
			AD.Documento,
			(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)) AS Saldo
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
		PC.IdMoneda = @IdMonedaSoles AND
		PC.EstadoAnalisis = 1 AND
		A.FlagBorrador = 0 AND
		A.Flag = 1 AND
		A.ID NOT IN (SELECT ID FROM @DataInvalida)
		GROUP BY 
			PC.CuentaContable,
			AD.IdEntidad,
			--AD.IdTipoComprobante, 
			AD.Serie, 
			AD.Documento,
			PC.ID,
			P.IdAnio
		HAVING
		--(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN ROUND(AD.ImporteDolares, 2) END), 0) - 
		-- ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN ROUND(AD.ImporteDolares, 2) END), 0)) = 0 AND
		(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) - 
		 ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)) != 0
		) AS TEMP
		INNER JOIN [ERP].[Fn_TipoCambio_MaxValue_Periodo](@IdAnio) TEMP_TC ON TEMP.Valor = TEMP_TC.Valor
		INNER JOIN Maestro.Mes M ON TEMP.Valor = M.Valor
		INNER JOIN ERP.Periodo P ON M.ID = P.IdMes AND P.IdAnio = @IdAnio
		INNER JOIN [ERP].[Fn_Parametro_Intervalo](@IdEmpresa, @IdAnio) PAI ON P.ID = PAI.IdPeriodo
		WHERE ABS(TEMP.Saldo) <= (CASE WHEN PAI.Valor IS NULL THEN PAI.ValorAnterior ELSE PAI.Valor END)

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
				 1 AS Orden,
				 T.Fecha,
				 T.IdEmpresa,
				 T.IdPeriodo,
				 T.IdOrigen,
				 T.IdMoneda,
				 T.TipoCambio,
				 @UsuarioRegistro,
				 GETDATE(),
				 0 AS FlagEditar, -- ESTA OPCIÓN AUN NO ESTA DEFINIDA Y SE REALIZARA FUTURAMENTE
				 0 AS FlagBorrador,
				 1 AS Flag,
				 CONCAT(@Identificador, @CONTADOR)
			FROM @TABLE_TEMP T
			GROUP BY T.Nombre, T.Fecha, T.IdEmpresa, T.IdPeriodo, T.IdOrigen, T.IdMoneda, T.TipoCambio 

		END;

		BEGIN -- INSERTAR ASIENTO DETALLE

			INSERT INTO [ERP].[AsientoDetalle] (
				IdAsiento,
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
				A.ID,
				T.IdPlanCuenta,
				E.Nombre,--T.NombreDetalle,
				T.IdEntidad,
				T.IdTipoComprobante,
				T.Serie,
				T.Documento,
				T.ImporteSoles,
				T.ImporteDolares,
				T.IdDebeHaber,
				T.Fecha,
				CONCAT(@Identificador, @CONTADOR)
			FROM @TABLE_TEMP AS T
			INNER JOIN ERP.Asiento A ON CONCAT(@Identificador, @CONTADOR) = A.IdentificadorProceso
			INNER JOIN ERP.Entidad E ON T.IdEntidad = E.ID
			ORDER BY T.ID

		END;

		BEGIN -- INSERTAR PARCHE AGRUPADO POR ASIENTO - PERIODO

			INSERT INTO [ERP].[AsientoDetalle] (
				IdAsiento,
				IdPlanCuenta,
				Fecha,
				Nombre,
				IdDebeHaber,
				ImporteSoles,
				ImporteDolares)	
			SELECT 
				TEMP.IdAsiento,
				(CASE WHEN TP.IdPlanCuenta IS NULL THEN TP.IdPlanCuentaAnterior ELSE TP.IdPlanCuenta END) AS IdPlanCuenta,
				TEMP.Fecha,
				(CASE WHEN TEMP.Saldo > 0 THEN 'GANANCIA POR AJUSTE DE CUENTA' WHEN TEMP.Saldo < 0 THEN 'PERDIDA POR AJUSTE DE CUENTA' ELSE '' END) AS NombreDetalle,
				(CASE WHEN TEMP.Saldo > 0 THEN 2 WHEN TEMP.Saldo < 0 THEN 1 ELSE 0 END) AS IdDebeHaber,
				ABS(TEMP.Saldo) AS ImporteSoles,
				0 AS ImporteDolares
			FROM
			(SELECT   
				AD.IdAsiento,
				A.IdPeriodo,
				A.Fecha,
				ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) AS DEBE,
				ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) AS HABER,
				(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)) AS Saldo
			FROM ERP.AsientoDetalle AD
			INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
			INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
			INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
			WHERE
			A.IdentificadorProceso LIKE '%' + CONCAT(@Identificador, @CONTADOR) + '%' AND 
			A.IdEmpresa = @IdEmpresa AND
			P.IdAnio = @IdAnio AND
			M.Valor BETWEEN 0 AND @CONTADOR AND
			A.Flag = 1 AND
			A.FlagBorrador = 0 AND
			A.ID NOT IN (SELECT ID FROM @DataInvalida)
			GROUP BY AD.IdAsiento, A.IdPeriodo, A.Fecha) TEMP
			INNER JOIN [ERP].[Fn_PlanCuenta_MaxValue_Periodo](@IdEmpresa, @IdAnio, 'CGPAC', 'CPPAC') TP ON TEMP.IdPeriodo = TP.IdPeriodo AND 
			(CASE WHEN TEMP.Saldo > 0 THEN 'CGPAC' WHEN TEMP.Saldo < 0 THEN 'CPPAC' ELSE '' END) = TP.Abreviatura

		END

		BEGIN -- ACTUALIZAR ORDEN DE ASIENTO DETALLE POR ASIENTO - PERIODO (SOLO ASIENTO PROCESADOS EN ESTE QUERY)

			UPDATE AD SET 
				AD.Orden = TEMP.Orden,
				AD.IdentificadorProceso = NULL
			FROM ERP.AsientoDetalle AD
			INNER JOIN
			(SELECT
			 AD.ID,
			 (ROW_NUMBER() OVER(PARTITION BY AD.IdAsiento ORDER BY AD.IdAsiento ASC)) AS Orden
			 FROM ERP.AsientoDetalle AD
			 INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
			 INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
			 INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
			 WHERE
			 A.IdentificadorProceso LIKE '%' + CONCAT(@Identificador, @CONTADOR) + '%' AND
			 A.IdOrigen = @IdOrigen AND 
			 A.IdEmpresa = @IdEmpresa AND
			 P.IdAnio = @IdAnio AND
			 M.Valor = @CONTADOR AND
			 A.Flag = 1 AND
			 A.FlagBorrador = 0 AND
			 A.ID NOT IN (SELECT ID FROM @DataInvalida)) AS Temp ON AD.ID = TEMP.ID

		END;

		DELETE FROM @TABLE_TEMP;
		SET @CONTADOR += 1;
	END

	SELECT 1;
END
