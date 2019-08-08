CREATE PROC [ERP].[Usp_Sel_OrdenDetalle_By_OrdenServicio]
@IdOrdenServicio VARCHAR(250)
AS
BEGIN
	
	DECLARE @Table TABLE (ID INT IDENTITY,IdPlanCuenta INT,Glosa VARCHAR(150),FlagAfecto BIT,Total DECIMAL(14,5));

	INSERT INTO @Table(IdPlanCuenta,Glosa,FlagAfecto,Total)
	SELECT 
	DISTINCT (SELECT [ERP].[ObtenerPlanCuentaAsientoByFecha] (PRO.IdPlanCuenta,VA.Fecha,VA.IdEmpresa)),PC.Nombre,VD.FlagAfecto,SUM(VD.SubTotal)
	FROM ERP.OrdenServicioDetalle VD
	INNER JOIN ERP.OrdenServicio VA ON VA.ID = VD.IdOrdenServicio
	INNER JOIN ERP.Producto PRO ON PRO.ID = VD.IdProducto
	INNER JOIN ERP.PlanCuenta PC ON PC.ID = PRO.IdPlanCuenta
	WHERE VD.IdOrdenServicio IN (SELECT DATA FROM ERP.Fn_SplitContenido(@IdOrdenServicio,','))
	GROUP BY PRO.IdPlanCuenta,VA.Fecha,VA.IdEmpresa,VD.FlagAfecto,PC.Nombre

	SELECT ID,IdPlanCuenta,Glosa,FlagAfecto,Total
	FROM @Table

END