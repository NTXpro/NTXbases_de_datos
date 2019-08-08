CREATE PROC [ERP].[Usp_Sel_PlanCuenta_Producto]
@IdEmpresa INT,
@Anio INT
AS
BEGIN
	DECLARE @MaximoValor INT = (SELECT TOP 1 MAX(GR.Longitud) FROM Maestro.Grado GR
														   INNER JOIN Maestro.Anio AN
														   ON GR.IdAnio = AN.ID
														   WHERE GR.IdEmpresa = @IdEmpresa AND AN.Nombre = @Anio)

	SELECT PC.ID,
		   PC.Nombre,
		   PC.CuentaContable
	FROM ERP.PlanCuenta PC
	INNER JOIN Maestro.Anio AN
	ON AN.ID = PC.IdAnio
	WHERE PC.IdGrado IN (SELECT ID FROM Maestro.Grado WHERE Longitud = @MaximoValor and idempresa = @IdEmpresa) AND
	(CuentaContable LIKE '5%' OR
	CuentaContable LIKE '7%')
	AND IdEmpresa = @IdEmpresa AND AN.Nombre = @Anio
	ORDER BY PC.CuentaContable

END