CREATE PROCEDURE [ERP].[Ejemplo_LibroDiario] --1,9,6
@IdEmpresa INT,
@IdAnio INT,
@IdMes INT
AS
BEGIN
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
	WHERE 
	P.IdAnio = @IdAnio AND
	P.IdMes = @IdMes AND
	A.IdEmpresa = @IdEmpresa AND 
	O.Abreviatura NOT IN ('02','03')
	GROUP BY A.ID
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
	UNION
	SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL

	select 
	PivotTable.FechaStr,
	PivotTable.Glosa,
	isnull(PivotTable.[10],0) as [10],
	isnull(PivotTable.[12],0) as [12],
	isnull(PivotTable.[13],0) as [13],
	isnull(PivotTable.[14],0) as [14],
	isnull(PivotTable.[16],0) as [16],
	isnull(PivotTable.[18],0) as [18],
	isnull(PivotTable.[24],0) as [24],
	isnull(PivotTable.[33],0) as [33],
	isnull(PivotTable.[39],0) as [39],
	isnull(PivotTable.[40],0) as [40],
	isnull(PivotTable.[42],0) as [42],
	isnull(PivotTable.[44],0) as [44],
	isnull(PivotTable.[46],0) as [46],
	isnull(PivotTable.[47],0) as [47],
	isnull(PivotTable.[48],0) as [48],
	isnull(PivotTable.[50],0) as [50],
	isnull(PivotTable.[59],0) as [59],
	isnull(PivotTable.[60],0) as [60],
	isnull(PivotTable.[61],0) as [61],
	isnull(PivotTable.[62],0) as [62],
	isnull(PivotTable.[63],0) as [63],
	isnull(PivotTable.[64],0) as [64],
	isnull(PivotTable.[65],0) as [65],
	isnull(PivotTable.[67],0) as [67],
	isnull(PivotTable.[68],0) as [68],
	isnull(PivotTable.[90],0) as [90],
	isnull(PivotTable.[91],0) as [91],
	isnull(PivotTable.[92],0) as [92],
	isnull(PivotTable.[94],0) as [94],
	isnull(PivotTable.[97],0) as [97],
	isnull(PivotTable.[70],0) as [70],
	isnull(PivotTable.[75],0) as [75],
	isnull(PivotTable.[77],0) as [77],
	isnull(PivotTable.[79],0) as [79]
	from 
	(SELECT
	       
	     (A.ID) AS IdAsiento ,
		CONVERT(VARCHAR, A.Fecha, 103) AS FechaStr,
		A.Nombre AS Glosa,
	LEFT(PC.CuentaContable,2) AS Codigo,
		PC.Nombre AS Denominacion,
		sum(ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END, 0)  - 
		ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END, 0) )as Total
	FROM
	Maestro.Origen O
	INNER JOIN ERP.Asiento A ON O.ID = A.IdOrigen
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	WHERE
	
	A.FlagBorrador = 0 AND
	A.Flag = 1 AND
	A.IdEmpresa = @IdEmpresa AND
	P.IdAnio = @IdAnio AND
	P.IdMes = @IdMes AND
	A.ID NOT IN (SELECT ID FROM @DataInvalida)  
	--and A.ID = @IdAsiento
	GROUP BY
	 A.ID ,
		A.Fecha,
		A.Nombre ,
		PC.CuentaContable,
		PC.Nombre

		) AS SourceTable PIVOT(sum(Total) 
   FOR Codigo IN(
                 [10],[12],[13],[14],[16],[18],[24],[33],[39],
                 [40],[42],[43],[44],[46],[47],[48],
				 [50],[59],
				 [60],[61],[62],[63],[64],[65],[67],[68],[90],[91],[92],[94],[97],
				 [70],[75],[77],[79])) AS PivotTable
	
END