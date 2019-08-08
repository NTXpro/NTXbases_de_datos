CREATE PROC [ERP].[Usp_Sel_CompraDetalle_By_IdCompra] 
@IdCompra INT
AS
BEGIN
	
		SELECT CD.ID,
			   CD.IdOperacion,
			   OP.Nombre						NombreOperacion,
			   CD.IdPlanCuenta,
			   CD.IdProyecto,
			   CD.Nombre,
			   CD.Importe,
			   CD.FlagAfecto,
			   PC.CuentaContable /*+ ' ' + PC.Nombre  NombrePlanCuenta*/,
			   PRO.Nombre							NombreProyecto
		FROM ERP.CompraDetalle CD
		INNER JOIN ERP.Compra CO
		ON CO.ID = CD.IdCompra
		LEFT JOIN ERP.PlanCuenta PC
		ON PC.ID = CD.IdPlanCuenta
		LEFT JOIN ERP.Proyecto PRO
		ON PRO.ID = CD.IdProyecto
		LEFT JOIN ERP.Operacion OP
		ON OP.ID = CD.IdOperacion
		WHERE CD.IdCompra = @IdCompra
END
