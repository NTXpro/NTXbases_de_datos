CREATE PROC [ERP].[Usp_Sel_Producto_Borrador_Pagination]
@IdEmpresa INT
AS
BEGIN

	SELECT	
			PRO.ID,
			PRO.Nombre,
			PRO.FechaRegistro
	FROM [ERP].[Producto] PRO
	LEFT JOIN PLE.T6UnidadMedida T6U
	ON T6U.ID=PRO.IdUnidadMedida
	LEFT JOIN Maestro.Marca MA
	ON MA.ID= PRO.IdMarca 
	LEFT JOIN PLE.T5Existencia T5E
	ON T5E.ID=PRO.IdExistencia 
	LEFT JOIN Maestro.TipoProducto TP
	ON TP.ID=PRO.IdTipoProducto
	LEFT JOIN [ERP].[Empresa] EM
	ON EM.ID=PRO.IdEmpresa
	LEFT JOIN [ERP].[PlanCuenta] PC
	ON PC.ID=PRO.IdPlanCuenta
	WHERE PRO.FlagBorrador = 1 AND PRO.IdEmpresa = @IdEmpresa AND PRO.IdTipoProducto= 1
END
