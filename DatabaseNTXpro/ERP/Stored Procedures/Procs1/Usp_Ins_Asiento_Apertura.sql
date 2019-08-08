CREATE PROC [ERP].[Usp_Ins_Asiento_Apertura]
@IdEmpresa INT,
@IdEntidad INT,
@IdAnio INT,
@IdAnioHasta INT,
@ValorMesHasta INT, /*VALOR MES HASTA DONDE SE GENERA EL ASIENTO*/
@ValorMes INT, /*VALOR MES HASTA CON CUAL SE REGISTRARA EL ASIENTO*/
@IdOrigen INT,
@Fecha DATETIME, /*FECHA DE TIPO DE CAMBIO*/
@TipoCambio DECIMAL(14,5),
@IdMoneda INT, /*SOLES POR DEFECTO -> EL ENVIO ES DESDE LA APLICACIÓN*/
@UsuarioRegistro VARCHAR(250),
@FechaRegistro DATETIME
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000

	DECLARE @DataInvalida TABLE(ID INT NOT NULL);
	DECLARE @DataInvalidaPC TABLE(ID INT NOT NULL);
	DECLARE @NOMBRE_ORIGEN VARCHAR(200) = (SELECT Nombre FROM Maestro.Origen WHERE ID = @IdOrigen);
	DECLARE @NOMBRE_ANIO VARCHAR(200) = (SELECT Nombre FROM Maestro.Anio WHERE ID = @IdAnio);
	DECLARE @ID_MES INT = (SELECT ID FROM Maestro.Mes WHERE Valor = @ValorMes);
	DECLARE @ID_PERIODO INT = (SELECT ID FROM ERP.Periodo WHERE IdAnio = @IdAnio AND IdMes = @ID_MES);

	/************************************************************************************************/
	DECLARE @MAX_LEN INT = (SELECT MAX(LEN(CuentaContable)) FROM ERP.PlanCuenta WHERE IdEmpresa = @IdEmpresa AND IdAnio = @IdAnioHasta);
	---
	DECLARE @CADENA VARCHAR(30) = '000000000000000000000000000000';
	DECLARE @TOTAL_CEROS VARCHAR(30) = (SELECT SUBSTRING(@CADENA, 1, @MAX_LEN));
	DECLARE @CC_DESDE INT = CAST(LEFT('1' + @TOTAL_CEROS, @MAX_LEN) AS INT);
	---
	DECLARE @CADENA_2 VARCHAR(30) = '999999999999999999999999999999';
	DECLARE @TOTAL_CEROS_2 VARCHAR(30) = (SELECT SUBSTRING(@CADENA_2, 1, @MAX_LEN));
	DECLARE @CC_HASTA INT = CAST(LEFT('5' + @TOTAL_CEROS_2, @MAX_LEN) AS INT)
	/************************************************************************************************/

	DECLARE @ORDEN_GENERADA INT;
	DECLARE @ORDEN_EXISTENTE INT = (SELECT COUNT(1) FROM ERP.Asiento WHERE IdPeriodo = @ID_PERIODO AND IdOrigen = @IdOrigen AND IdEmpresa = @IdEmpresa)
	IF(@ORDEN_EXISTENTE > 0)
	BEGIN
		SET @ORDEN_GENERADA = (SELECT MAX(ISNULL(Orden, 0)) + 1 FROM ERP.Asiento WHERE IdPeriodo = @ID_PERIODO AND IdOrigen = @IdOrigen AND IdEmpresa = @IdEmpresa);
	END
	ELSE
	BEGIN
		SET @ORDEN_GENERADA = 1;
	END
	
	DELETE FROM ERP.AsientoDetalle WHERE IdAsiento = (SELECT ID FROM ERP.Asiento WHERE IdPeriodo = @ID_PERIODO AND IdOrigen = @IdOrigen AND IdEmpresa = @IdEmpresa);
	DELETE FROM ERP.Asiento WHERE IdPeriodo = @ID_PERIODO AND IdOrigen = @IdOrigen AND IdEmpresa = @IdEmpresa

	INSERT INTO @DataInvalida
	SELECT 
	A.ID AS ID
	FROM ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	WHERE 
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnioHasta AND
	M.Valor BETWEEN 0 AND @ValorMesHasta
	GROUP BY A.ID
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL

	/*INSERT INTO @DataInvalidaPC
	SELECT DISTINCT PCD.IdPlanCuentaDestino1 
	FROM ERP.PlanCuentaDestino PCD
	INNER JOIN ERP.PlanCuenta PC ON PCD.IdPlanCuentaDestino1 = PC.ID AND PC.IdEmpresa = @IdEmpresa AND PC.IdAnio = @IdAnioHasta
	UNION
	SELECT DISTINCT PCD.IdPlanCuentaDestino2
	FROM ERP.PlanCuentaDestino PCD
	INNER JOIN ERP.PlanCuenta PC ON PCD.IdPlanCuentaDestino2 = PC.ID AND PC.IdEmpresa = @IdEmpresa AND PC.IdAnio = @IdAnioHasta*/

	DECLARE @ID_ASIENTO INT;
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
		   ,UsuarioModifico
		   ,FechaModificado
           ,[FlagEditar]
           ,[FlagBorrador]
 ,[Flag])
     VALUES
           (@NOMBRE_ORIGEN + ' DEL AÑO ' + @NOMBRE_ANIO,
            @ORDEN_GENERADA,
            @Fecha,
			@IdEmpresa,
			@ID_PERIODO,
			@IdOrigen,
            @IdMoneda,
            @TipoCambio,
            @UsuarioRegistro,
            @FechaRegistro,
			@UsuarioRegistro,
            @FechaRegistro,
            1,
            0,
            1)
	SET @ID_ASIENTO = CAST(SCOPE_IDENTITY() AS int)

	INSERT INTO [ERP].[AsientoDetalle] (
		IdAsiento,
		IdPlanCuenta,
		Nombre,
		IdEntidad,
		IdTipoComprobante,
		Serie,
		Documento,
		IdProyecto,
		ImporteSoles,
		ImporteDolares,
		IdDebeHaber,
		Fecha)
	--============================================================================================================================================================
	-- AGRUPAMIENTO POR 1ER CASO | ANALISIS = 0 Y PROYECTO = 0 | SOLO SE AGRUPA POR PLAN DE CUENTA
    --============================================================================================================================================================
	SELECT 
		@ID_ASIENTO,
		PC.ID AS IdPlanCuenta,
		PC.Nombre AS NombrePlanCuenta,
		NULL AS IdEntidad,
		NULL AS IdTipoComprobante,
		NULL AS Serie,
		NULL AS Documento,
		NULL AS IdProyecto,
		(CASE
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) > ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 
				(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0))
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) < ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 
				(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0))
		END) AS ImporteSoles,
		--NULL AS ImporteDolares,
		(CASE
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) > ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 
				(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END), 0))
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) < ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 
				(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END), 0))
		END) AS ImporteDolares,
		(CASE
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) > ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 1
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) < ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 2
		END) AS IdDebeHaber,
		@Fecha
	FROM
	ERP.AsientoDetalle AD
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	WHERE
	P.IdAnio = @IdAnioHasta AND
	M.Valor BETWEEN 0 AND @ValorMesHasta AND
	A.IdEmpresa = @IdEmpresa AND
	(PC.EstadoAnalisis = 0 OR PC.EstadoAnalisis IS NULL) AND
	(PC.EstadoProyecto = 0 OR PC.EstadoProyecto IS NULL) AND
	CAST(LEFT(PC.CuentaContable + @TOTAL_CEROS, @MAX_LEN) AS INT) BETWEEN @CC_DESDE AND @CC_HASTA AND -- ADD
	A.FlagBorrador = 0 AND
	A.Flag = 1 AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida)
	GROUP BY PC.ID, PC.Nombre
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) -
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) <> 0 AND
	PC.ID NOT IN (SELECT ID FROM @DataInvalidaPC)
	--============================================================================================================================================================
	UNION ALL -- AGRUPAMIENTO POR 2DO CASO | ANALISIS = 1 Y PROYECTO = 0 | AGRUPAMIENTO POR PLAN DE CUENTA Y 4 CAMPOS ADICIONALES
	--============================================================================================================================================================
	SELECT 
		@ID_ASIENTO,
		PC.ID AS IdPlanCuenta,
		PC.Nombre AS NombrePlanCuenta,
		AD.IdEntidad,
		AD.IdTipoComprobante,
		AD.Serie,
		AD.Documento,
		NULL AS IdProyecto,
		(CASE
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) > ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 
				(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0))
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) < ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 
				(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0))
		END) AS ImporteSoles,
		(CASE
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) > ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 
				(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END), 0))
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) < ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 
				(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END), 0))
		END) AS ImporteDolares,
		(CASE
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) > ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 1
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) < ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 2
		END) AS IdDebeHaber,
		@Fecha
	FROM
	ERP.AsientoDetalle AD
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN [ERP].[Asiento] A ON AD.IdAsiento = A.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	WHERE
	P.IdAnio = @IdAnioHasta AND
    M.Valor BETWEEN 0 AND @ValorMesHasta AND
    A.IdEmpresa = @IdEmpresa AND
	PC.EstadoAnalisis = 1 AND
	(PC.EstadoProyecto = 0 OR PC.EstadoProyecto IS NULL) AND
	CAST(LEFT(PC.CuentaContable + @TOTAL_CEROS, @MAX_LEN) AS INT) BETWEEN @CC_DESDE AND @CC_HASTA AND -- ADD
	A.FlagBorrador = 0 AND
    A.Flag = 1 AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida)
	GROUP BY PC.ID, PC.Nombre, PC.CuentaContable, AD.IdEntidad, AD.IdTipoComprobante, AD.Serie, AD.Documento
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) -
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) <> 0 AND
	PC.ID NOT IN (SELECT ID FROM @DataInvalidaPC)
	--============================================================================================================================================================
	UNION ALL -- AGRUPAMIENTO POR 3ER CASO | ANALISIS = 0 Y PROYECTO = 1 | AGRUPAMIENTO POR PLAN DE CUENTA Y PROYECTO
	--============================================================================================================================================================
	SELECT 
		@ID_ASIENTO,
		PC.ID AS IdPlanCuenta,
		PC.Nombre AS NombrePlanCuenta,
		NULL AS IdEntidad,
		NULL AS IdTipoComprobante,
		NULL AS Serie,
		NULL AS Documento,
		AD.IdProyecto,
		(CASE
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) > ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 
				(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0))
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) < ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 
				(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0))
		END) AS ImporteSoles,
		--NULL AS ImporteDolares,
		(CASE
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) > ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 
				(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END), 0))
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) < ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 
				(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END), 0))
		END) AS ImporteDolares,
		(CASE
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) > ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 1
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) < ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 2
		END) AS IdDebeHaber,
		@Fecha
	FROM
	ERP.AsientoDetalle AD
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	WHERE
	P.IdAnio = @IdAnioHasta AND
	M.Valor BETWEEN 0 AND @ValorMesHasta AND
	A.IdEmpresa = @IdEmpresa AND
	(PC.EstadoAnalisis = 0 OR PC.EstadoAnalisis IS NULL) AND
	PC.EstadoProyecto = 1 AND
	CAST(LEFT(PC.CuentaContable + @TOTAL_CEROS, @MAX_LEN) AS INT) BETWEEN @CC_DESDE AND @CC_HASTA AND -- ADD
	A.FlagBorrador = 0 AND
	A.Flag = 1 AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida)
	GROUP BY PC.ID, PC.Nombre, AD.IdProyecto
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) -
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) <> 0 AND
	PC.ID NOT IN (SELECT ID FROM @DataInvalidaPC)
	--============================================================================================================================================================
	UNION ALL -- AGRUPAMIENTO POR 4TO CASO | ANALISIS = 1 Y PROYECTO = 1 | AGRUPAMIENTO POR PLAN DE CUENTA Y 5 CAMPOS ADICIONALES
	--============================================================================================================================================================
	SELECT 
		@ID_ASIENTO,
		PC.ID AS IdPlanCuenta,
		PC.Nombre AS NombrePlanCuenta,
		AD.IdEntidad,
		AD.IdTipoComprobante,
		AD.Serie,
		AD.Documento,
		AD.IdProyecto,
		(CASE
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) > ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 
				(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0))
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) < ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 
				(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0))
		END) AS ImporteSoles,
		(CASE
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) > ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 
				(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END), 0))
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) < ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 
				(ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteDolares END), 0) - ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteDolares END), 0))
		END) AS ImporteDolares,
		(CASE
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) > ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 1
			WHEN ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) < ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) THEN 2
		END) AS IdDebeHaber,
		@Fecha
	FROM
	ERP.AsientoDetalle AD
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN [ERP].[Asiento] A ON AD.IdAsiento = A.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	WHERE
	P.IdAnio = @IdAnioHasta AND
    M.Valor BETWEEN 0 AND @ValorMesHasta AND
    A.IdEmpresa = @IdEmpresa AND
	PC.EstadoAnalisis = 1 AND
	PC.EstadoProyecto = 1 AND
	CAST(LEFT(PC.CuentaContable + @TOTAL_CEROS, @MAX_LEN) AS INT) BETWEEN @CC_DESDE AND @CC_HASTA AND -- ADD
	A.FlagBorrador = 0 AND
    A.Flag = 1 AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida)
	GROUP BY PC.ID, PC.Nombre, PC.CuentaContable, AD.IdEntidad, AD.IdTipoComprobante, AD.Serie, AD.Documento, AD.IdProyecto 
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) -
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) <> 0 AND
	PC.ID NOT IN (SELECT ID FROM @DataInvalidaPC)

	UPDATE AD
	SET AD.IdPlanCuenta = PC2.ID
	FROM ERP.AsientoDetalle AD
	INNER JOIN ERP.PlanCuenta PC on AD.IdPlanCuenta = PC.ID
	INNER JOIN ERP.PlanCuenta PC2 on PC.CuentaContable = PC2.CuentaContable and PC2.IdEmpresa = @IdEmpresa and PC2.IdAnio = @IdAnio
	WHERE AD.IdAsiento = @ID_ASIENTO
	
	DECLARE @FechaParamCCGP DATETIME
	DECLARE @ValorCCGP VARCHAR(25)
	DECLARE @IdCuentaContableCCGP INT	
	DECLARE @CuentaContableCCGP VARCHAR(255)
	DECLARE @IdDebeHaberCCGP INT
	DECLARE @ImporteSolesCCGP DECIMAL(14, 5)

	SELECT @ImporteSolesCCGP = SUM(CASE 
					WHEN IdDebeHaber = 1 THEN ImporteSoles
					ELSE ImporteSoles * -1 
			   END)
	FROM ERP.AsientoDetalle
	WHERE IdAsiento = @ID_ASIENTO
	
	IF @ImporteSolesCCGP != 0 
	BEGIN
	
		SELECT @FechaParamCCGP = CAST(Nombre + RIGHT(CONCAT('00', CASE 
																	WHEN @ValorMes > 12 THEN 12
																	WHEN @ValorMes = 0 THEN 1
																	ELSE @ValorMes
																END), 2) + '01' AS DATETIME)
		FROM Maestro.Anio
		WHERE ID = @IdAnio

		SELECT @ValorCCGP = [ERP].[ObtenerValorParametroByAbreviaturaFecha](@IdEmpresa, 'CCGP', @FechaParamCCGP)

		SELECT @IdCuentaContableCCGP = ID, @CuentaContableCCGP = Nombre	
		FROM ERP.PlanCuenta
		WHERE IdAnio = @IdAnio
		AND CuentaContable = @ValorCCGP	

		SELECT @IdDebeHaberCCGP = (CASE WHEN @ImporteSolesCCGP > 0 THEN 2 ELSE 1 END)
	
		INSERT INTO ERP.AsientoDetalle(IdAsiento, Orden, IdPlanCuenta, Nombre, IdDebeHaber, IdProyecto, Fecha, ImporteSoles, ImporteDolares)
		VALUES(@ID_ASIENTO, NULL, @IdCuentaContableCCGP, @CuentaContableCCGP, @IdDebeHaberCCGP, NULL, @Fecha, (CASE WHEN @IdDebeHaberCCGP = 1 THEN @ImporteSolesCCGP * -1 ELSE @ImporteSolesCCGP END), (CAST((CASE WHEN @IdDebeHaberCCGP = 1 THEN @ImporteSolesCCGP * -1 ELSE @ImporteSolesCCGP END) / @TipoCambio AS DECIMAL(14, 2))))	
		
	END

	SELECT @ID_ASIENTO
END