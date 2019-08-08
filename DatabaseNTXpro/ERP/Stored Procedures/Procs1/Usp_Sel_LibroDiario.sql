CREATE PROCEDURE ERP.Usp_Sel_LibroDiario
@IdAnio INT,
@IdMes INT,
@IdEmpresa INT
AS
	DECLARE @DataInvalida TABLE(ID INT NOT NULL);

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

	SELECT O.Abreviatura + RIGHT('0000000' + CAST(AD.Orden AS VARCHAR(255)), 7) CorrelativoAsiento,
			A.Fecha AsientoFecha,
			AD.Nombre AsientoDetalleNombre,
			PC.CuentaContable,
			PC.Nombre NombrePlanCuenta,
			CASE WHEN IdDebeHaber = 1 THEN ImporteSoles
			ELSE 0 END Debe,
			CASE WHEN IdDebeHaber = 2 THEN ImporteSoles
			ELSE 0 END Haber
	FROM ERP.AsientoDetalle AD
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN Maestro.Origen O ON O.ID = A.IdOrigen
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	WHERE P.IdAnio = @IdAnio
	AND P.IdMes = @IdMes
	AND A.Flag = 1
	AND A.IdEmpresa = @IdEmpresa
	AND A.ID NOT IN (SELECT ID FROM @DataInvalida)
	AND A.FlagBorrador = 0
	ORDER BY A.Fecha, O.Abreviatura, A.Orden ASC