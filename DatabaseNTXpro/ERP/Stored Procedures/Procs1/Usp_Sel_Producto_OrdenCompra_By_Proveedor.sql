
create PROC [ERP].[Usp_Sel_Producto_OrdenCompra_By_Proveedor] 
@IdProveedor INT
AS
BEGIN
		
	SELECT DISTINCT TOP 20	PRO.ID,
							PRO.Nombre,
							M.Nombre NombreMarca,
							UM.CodigoSunat CodigoSunatUnidadMedida,
							UM.Nombre NombreUnidadMedida,
							T5E.CodigoSunat,
							PRO.CodigoReferencia
	FROM [ERP].[Producto] PRO
	LEFT JOIN Maestro.Marca M
		ON M.ID = PRO.IdMarca
	LEFT JOIN [PLE].[T6UnidadMedida] UM
		ON UM.ID = PRO.IdUnidadMedida
	LEFT JOIN PLE.T5Existencia T5E
		ON PRO.IdExistencia=T5E.ID
	INNER JOIN ERP.OrdenCompraDetalle OCD
		ON PRO.ID = OCD.IdProducto
	INNER JOIN ERP.OrdenCompra OC
		ON OCD.IdOrdenCompra = OC.ID
	WHERE OC.IdProveedor = @IdProveedor AND OC.FlagBorrador = 0 AND OC.Flag = 1

END
