CREATE PROC [ERP].[Usp_ProcesarDestino]
@IdEmpresa INT,
@IdAnio INT,
@IdMesDesde INT,
@IdMesHasta INT,
@IdSistema INT
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000;

	DECLARE @MES_DESDE INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMesDesde);
	DECLARE @MES_HASTA INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMesHasta);
	SET @IdSistema = CASE WHEN @IdSistema = 0 THEN 9 ELSE @IdSistema END;

	DELETE AD FROM ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	WHERE 
	AD.FlagAutomatico = 1 AND
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN @MES_DESDE AND @MES_HASTA AND
	P.ID NOT IN (SELECT P.ID
					FROM ERP.PeriodoSistema PS
					INNER JOIN ERP.Periodo P ON PS.IdPeriodo = P.ID
					WHERE PS.IdSistema = @IdSistema AND PS.IdEmpresa = @IdEmpresa AND PS.FlagCierre = 1)

	INSERT INTO [ERP].[AsientoDetalle]
		([IdAsiento]
		,[Orden]
		,[IdPlanCuenta]
		,[Nombre]
		,[IdDebeHaber]
		,[IdProyecto]
		,[Fecha]
		,[ImporteSoles]
		,[ImporteDolares]
		,[IdEntidad]
		,[IdTipoComprobante]
		,[Serie]
		,[Documento]		
		,[Flag]
		,[FlagBorrador]
		,[FlagAutomatico])
	SELECT
		TEMP.IdAsiento,
		TEMP.Orden,
		TEMP.IdPlanCuenta,
		TEMP.Nombre,
		TEMP.IdDebeHaber,
		TEMP.IdProyecto,
		TEMP.Fecha,
		TEMP.ImporteSoles,
		TEMP.ImporteDolares,
		TEMP.IdEntidad,
		TEMP.IdTipoComprobante,
		TEMP.Serie,
		TEMP.Documento,
		TEMP.Flag,
		TEMP.FlagBorrador,
		TEMP.FlagAutomatico
	FROM
	(SELECT
		AD.IdAsiento,
		AD.Orden,
		PC.ID AS IdPlanCuenta,
		AD.Nombre,
		--DH.ID AS IdDebeHaber,
		--CASE WHEN AD.IdDebeHaber = 1 THEN 1 ELSE 2 END AS IdDebeHaber,
		CASE
			WHEN AD.IdTipoComprobante = 8 THEN 2
			ELSE
				CASE WHEN AD.IdDebeHaber = 1 THEN 1 ELSE 2
			END
		END AS IdDebeHaber,
		CASE PCAD.EstadoProyecto WHEN 1 THEN AD.IdProyecto ELSE NULL END AS IdProyecto,
		AD.Fecha,
		ROUND((PCD.Porcentaje * AD.ImporteSoles) / 100, 2) AS ImporteSoles,
		ROUND((PCD.Porcentaje * AD.ImporteDolares) / 100, 2) AS ImporteDolares,
		AD.IdEntidad,
		AD.IdTipoComprobante,
		AD.Serie,
		AD.Documento,
		AD.Flag,
		AD.FlagBorrador,
		1 AS FlagAutomatico
	FROM ERP.PlanCuentaDestino PCD
	INNER JOIN ERP.AsientoDetalle AD ON PCD.IdPlanCuentaOrigen = AD.IdPlanCuenta
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	LEFT JOIN ERP.PeriodoSistema PS ON P.ID = PS.IdPeriodo AND PS.IdEmpresa = @IdEmpresa
	LEFT JOIN ERP.PlanCuenta PCAD ON PCAD.ID = AD.IdPlanCuenta
	INNER JOIN ERP.PlanCuenta PC ON PCD.IdPlanCuentaDestino1 = PC.ID
	WHERE
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN @MES_DESDE AND @MES_HASTA AND
	(PS.IdSistema IS NULL OR PS.IdSistema = @IdSistema) AND
	(PS.FlagCierre IS NULL OR PS.FlagCierre = 0) AND
	A.Flag = 1 AND
	A.FlagBorrador = 0
	

	UNION ALL

	SELECT
		AD.IdAsiento,
		AD.Orden,
		PC.ID AS IdPlanCuenta,
		AD.Nombre,
		--DH.ID AS IdDebeHaber,
		--CASE WHEN AD.IdDebeHaber = 1 THEN 2 ELSE 1 END AS IdDebeHaber,
		CASE
			WHEN AD.IdTipoComprobante = 8 THEN 1
			ELSE
				CASE WHEN AD.IdDebeHaber = 1 THEN 2 ELSE 1
			END
		END AS IdDebeHaber,
		CASE PCAD.EstadoProyecto WHEN 1 THEN AD.IdProyecto ELSE NULL END AS IdProyecto,
		AD.Fecha,
		ROUND((PCD.Porcentaje * AD.ImporteSoles) / 100, 2) AS ImporteSoles,
		ROUND((PCD.Porcentaje * AD.ImporteDolares) / 100, 2) AS ImporteDolares,
		AD.IdEntidad,
		AD.IdTipoComprobante,
		AD.Serie,
		AD.Documento,
		AD.Flag,
		AD.FlagBorrador,
		1 AS FlagAutomatico
	FROM ERP.PlanCuentaDestino PCD
	INNER JOIN ERP.AsientoDetalle AD ON PCD.IdPlanCuentaOrigen = AD.IdPlanCuenta
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	LEFT JOIN ERP.PeriodoSistema PS ON P.ID = PS.IdPeriodo  AND PS.IdEmpresa = @IdEmpresa
	LEFT JOIN ERP.PlanCuenta PCAD ON PCAD.ID = AD.IdPlanCuenta
	INNER JOIN ERP.PlanCuenta PC ON PCD.IdPlanCuentaDestino2 = PC.ID
	WHERE
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN @MES_DESDE AND @MES_HASTA AND
	(PS.IdSistema IS NULL OR PS.IdSistema = @IdSistema) AND
	(PS.FlagCierre IS NULL OR PS.FlagCierre = 0) AND
	A.Flag = 1 AND
	A.FlagBorrador = 0) TEMP
	ORDER BY TEMP.IdAsiento

	UPDATE AD
	SET AD.Orden = TEMP.Orden
	FROM ERP.AsientoDetalle AD
	INNER JOIN
	(SELECT
	AD.ID,
	(ROW_NUMBER() OVER(PARTITION BY AD.IdAsiento ORDER BY AD.ID ASC)) AS Orden
	FROM ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	LEFT JOIN ERP.PeriodoSistema PS ON P.ID = PS.IdPeriodo
	WHERE
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN @MES_DESDE AND @MES_HASTA AND
	(PS.IdSistema IS NULL OR PS.IdSistema = @IdSistema) AND
	(PS.FlagCierre IS NULL OR PS.FlagCierre = 0) AND
	A.Flag = 1 AND
	A.FlagBorrador = 0) AS Temp ON AD.ID = TEMP.ID

	SELECT 1;
END