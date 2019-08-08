CREATE FUNCTION [ERP].[Fn_PlanCuenta_MaxValue_Periodo]
(    
    @IdEmpresa INT,
    @IdAnio INT,
	@ParametroGanancia VARCHAR(100),
	@ParametroPerdida VARCHAR(100)
)
RETURNS @ReturnValue TABLE 
(
	ID INT IDENTITY PRIMARY KEY,
	IdPeriodo INT,
	IdPlanCuentaAnterior INT,
	IdPlanCuenta INT,
	Abreviatura VARCHAR(50),
	Flag BIT
) 
AS
BEGIN 

	INSERT INTO @ReturnValue
	SELECT TOP 1
		P.ID AS IdPeriodo,
		NULL AS IdPlanCuentaAnterior,
		PC.ID AS IdPlanCuenta,
		@ParametroGanancia AS Abreviatura,
		0 AS Flag
	FROM ERP.Periodo P
	INNER JOIN Maestro.Anio A ON P.IdAnio = A.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	INNER JOIN ERP.Parametro PA ON P.ID = PA.IdPeriodo AND PA.Abreviatura IN (@ParametroGanancia) AND PA.IdEmpresa = @IdEmpresa
	INNER JOIN ERP.PlanCuenta PC ON PA.Valor = PC.CuentaContable AND PC.IdEmpresa = @IdEmpresa AND PC.IdAnio = @IdAnio 
	WHERE
	CAST(A.Nombre AS INT) < (SELECT CAST(Nombre AS INT) FROM Maestro.Anio WHERE ID = @IdAnio)
	ORDER BY CAST(CONCAT(A.Nombre, RIGHT('00' + LTRIM(RTRIM(M.Valor)), 2)) AS INT) DESC;

	INSERT INTO @ReturnValue
	SELECT
		P.ID AS IdPeriodo,
		NULL AS IdPlanCuentaAnterior,
		PC.ID AS IdPlanCuenta,
		@ParametroGanancia AS Abreviatura,
		0 AS Flag
	FROM ERP.Periodo P
	INNER JOIN Maestro.Anio A ON P.IdAnio = A.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	LEFT JOIN ERP.Parametro PA ON P.ID = PA.IdPeriodo AND PA.Abreviatura IN (@ParametroGanancia) AND PA.IdEmpresa = @IdEmpresa
	LEFT JOIN ERP.PlanCuenta PC ON PA.Valor = PC.CuentaContable AND PC.IdEmpresa = @IdEmpresa AND PC.IdAnio = @IdAnio
	WHERE
	P.IdAnio = @IdAnio
	ORDER BY M.Valor

	INSERT INTO @ReturnValue
	SELECT TOP 1
		P.ID AS IdPeriodo,
		NULL AS IdPlanCuentaAnterior,
		PC.ID AS IdPlanCuenta,
		@ParametroPerdida AS Abreviatura,
		0 AS Flag
	FROM ERP.Periodo P
	INNER JOIN Maestro.Anio A ON P.IdAnio = A.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	INNER JOIN ERP.Parametro PA ON P.ID = PA.IdPeriodo AND PA.Abreviatura IN (@ParametroPerdida) AND PA.IdEmpresa = @IdEmpresa
	INNER JOIN ERP.PlanCuenta PC ON PA.Valor = PC.CuentaContable AND PC.IdEmpresa = @IdEmpresa AND PC.IdAnio = @IdAnio
	WHERE
	CAST(A.Nombre AS INT) < (SELECT CAST(Nombre AS INT) FROM Maestro.Anio WHERE ID = @IdAnio)
	ORDER BY CAST(CONCAT(A.Nombre, RIGHT('00' + LTRIM(RTRIM(M.Valor)), 2)) AS INT) DESC;

	INSERT INTO @ReturnValue
	SELECT
		P.ID AS IdPeriodo,
		NULL AS IdPlanCuentaAnterior,
		PC.ID AS IdPlanCuenta,
		@ParametroPerdida AS Abreviatura,
		0
	FROM ERP.Periodo P
	INNER JOIN Maestro.Anio A ON P.IdAnio = A.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	LEFT JOIN ERP.Parametro PA ON P.ID = PA.IdPeriodo AND PA.Abreviatura IN (@ParametroPerdida) AND PA.IdEmpresa = @IdEmpresa
	LEFT JOIN ERP.PlanCuenta PC ON PA.Valor = PC.CuentaContable AND PC.IdEmpresa = @IdEmpresa AND PC.IdAnio = @IdAnio
	WHERE
	P.IdAnio = @IdAnio
	ORDER BY M.Valor

	INSERT INTO @ReturnValue
	SELECT 
		IdPeriodo,
		LAG(Grupo) OVER(PARTITION BY Abreviatura ORDER BY ID) AS IdPlanCuentaAnterior,
		IdPlanCuenta,
		Abreviatura,
		1
	FROM
	(SELECT
		TEMP.ID,
		TEMP.IdPeriodo,
		TEMP.IdPlanCuenta,
		TEMP.Abreviatura,
		SUM(TEMP.IdPlanCuenta) OVER(PARTITION BY Grupo ORDER BY ID) AS Grupo
	FROM
	(SELECT 	
		ID,
		IdPeriodo,
		IdPlanCuentaAnterior,
		IdPlanCuenta,
		Abreviatura,
		SUM( IdPlanCuenta ) OVER( PARTITION BY Abreviatura ORDER BY ID ) AS Grupo
	FROM @ReturnValue) AS TEMP) AS TEMP

	DELETE FROM @ReturnValue WHERE Flag = 0;

    RETURN;
END
