CREATE FUNCTION [ERP].[Fn_Parametro_Intervalo]
(    
    @IdEmpresa INT,
    @IdAnio INT
)
RETURNS @ReturnValue TABLE(
	ID INT IDENTITY PRIMARY KEY,
	IdPeriodo INT,
	ValorAnterior DECIMAL(14,5),
	Valor DECIMAL(14,5),
	Abreviatura VARCHAR(50),
	Flag BIT
)
AS
BEGIN 

	INSERT INTO @ReturnValue
	SELECT TOP 1
		P.ID AS IdPeriodo,
		NULL AS ValorAnterior,
		CAST(PA.Valor AS DECIMAL(14,5)) AS Valor,
		'ISPAD' AS Abreviatura,
		0 AS Flag
	FROM ERP.Periodo P
	INNER JOIN Maestro.Anio A ON P.IdAnio = A.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	INNER JOIN ERP.Parametro PA ON P.ID = PA.IdPeriodo AND PA.Abreviatura IN ('ISPAD') AND PA.IdEmpresa = @IdEmpresa
	WHERE
	CAST(A.Nombre AS INT) < (SELECT CAST(Nombre AS INT) FROM Maestro.Anio WHERE ID = @IdAnio)
	ORDER BY CAST(CONCAT(A.Nombre, RIGHT('00' + LTRIM(RTRIM(M.Valor)), 2)) AS INT) DESC;

	INSERT INTO @ReturnValue
	SELECT
		P.ID AS IdPeriodo,
		NULL AS ValorAnterior,
		CAST(PA.Valor AS DECIMAL(14,5)) AS Valor,
		'ISPAD' AS Abreviatura,
		0 AS Flag
	FROM ERP.Periodo P
	INNER JOIN Maestro.Anio A ON P.IdAnio = A.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	LEFT JOIN ERP.Parametro PA ON P.ID = PA.IdPeriodo AND PA.Abreviatura IN ('ISPAD') AND PA.IdEmpresa = @IdEmpresa
	WHERE
	P.IdAnio = @IdAnio
	ORDER BY M.Valor

	INSERT INTO @ReturnValue
	SELECT 
		IdPeriodo,
		LAG(Grupo) OVER(PARTITION BY Abreviatura ORDER BY ID) AS ValorAnterior,
		Valor,
		Abreviatura,
		1
	FROM
	(SELECT
		TEMP.ID,
		TEMP.IdPeriodo,
		TEMP.Valor,
		TEMP.Abreviatura,
		SUM(TEMP.Valor) OVER(PARTITION BY Grupo ORDER BY ID) AS Grupo
	FROM
	(SELECT 	
		ID,
		IdPeriodo,
		ValorAnterior,
		Valor,
		Abreviatura,
		SUM( Valor ) OVER( PARTITION BY Abreviatura ORDER BY ID ) AS Grupo
	FROM @ReturnValue) AS TEMP) AS TEMP

	DELETE FROM @ReturnValue WHERE Flag = 0;

    RETURN;
END
