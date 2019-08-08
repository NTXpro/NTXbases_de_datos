CREATE PROC [ERP].[Usp_Sel_ValeDetalle_By_Vale] --'37'
@IdVale VARCHAR(250)
AS
BEGIN
	
	DECLARE @Table TABLE (ID INT IDENTITY,IdPlanCuenta INT,Glosa VARCHAR(150),FlagAfecto BIT,Total DECIMAL(14,5));

	INSERT INTO @Table(IdPlanCuenta,Glosa,FlagAfecto,Total)
	SELECT DISTINCT (SELECT [ERP].[ObtenerPlanCuentaAsientoByFecha] (PRO.IdPlanCuentaCompra,VA.Fecha,VA.IdEmpresa)),PC.Nombre,VD.FlagAfecto,SUM(VD.SubTotal)
	FROM ERP.ValeDetalle VD
	INNER JOIN ERP.Vale VA ON VA.ID = VD.IdVale
	INNER JOIN ERP.Producto PRO ON PRO.ID = VD.IdProducto
	INNER JOIN ERP.PlanCuenta PC ON PC.ID = PRO.IdPlanCuentaCompra
	WHERE VD.IdVale IN (SELECT DATA FROM ERP.Fn_SplitContenido(@IdVale,','))
	GROUP BY PRO.IdPlanCuentaCompra,VA.Fecha,VA.IdEmpresa,VD.FlagAfecto,PC.Nombre

	SELECT ID,IdPlanCuenta,Glosa,FlagAfecto,Total
	FROM @Table

END