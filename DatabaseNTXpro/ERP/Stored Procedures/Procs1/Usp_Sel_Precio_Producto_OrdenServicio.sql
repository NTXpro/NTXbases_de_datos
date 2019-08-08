﻿
CREATE PROC [ERP].[Usp_Sel_Precio_Producto_OrdenServicio]
@IdProducto INT,
@IdProveedor INT
AS
BEGIN
	DECLARE @PrecioUnitario DECIMAL(14,5) = (SELECT TOP 1  PrecioUnitario
											 FROM ERP.OrdenServicioDetalle OCD
											INNER JOIN ERP.OrdenServicio OC ON OC.ID = OCD.IdOrdenServicio
											WHERE OCD.IdProducto = @IdProducto AND OC.IdProveedor = @IdProveedor
											ORDER BY OC.Documento DESC)
	SELECT ISNULL(@PrecioUnitario,0)
END