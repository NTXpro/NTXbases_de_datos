CREATE PROCEDURE [ERP].[Usp_Sel_ReporteLibroMayor_PlanCuenta] --1, 9, 6
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT
AS
BEGIN

	DECLARE @VALOR_MES_HASTA INT = (SELECT Valor FROM Maestro.Mes WHERE ID = @IdMes)

	
	
	
	SELECT
		PC.ID AS IdPlanCuenta,
		PC.CuentaContable,
		REPLACE(REPLACE(PC.Nombre,CHAR(10),''),CHAR(13),'') AS NombreCuentaContable,
		SUM(ISNULL(CASE WHEN M.Valor < @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END END, 0)) AS SaldoDebe,
		SUM(ISNULL(CASE WHEN M.Valor < @VALOR_MES_HASTA THEN CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END END, 0)) AS SaldoHaber
	FROM
	ERP.Asiento A
	INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	WHERE
	P.IdAnio = @IdAnio AND
	
	M.Valor BETWEEN 0 AND @VALOR_MES_HASTA AND
	A.IdEmpresa = @IdEmpresa AND
	PC.IdEmpresa = @IdEmpresa AND
	
	ISNULL(A.FlagBorrador, 0) = 0 AND
	A.Flag = 1
	GROUP BY
		PC.ID,
		PC.CuentaContable,
		PC.Nombre
	ORDER BY PC.CuentaContable
END