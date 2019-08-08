CREATE PROC ERP.Usp_Sel_ListaPrecio_By_IdProducto
@IdProducto INT,
@IdListaPrecio INT
AS
BEGIN
	
	SELECT L.PorcentajeDescuento PorcentajeDescuentoMaximo,
		   LPC.PrecioUnitario,
		   LPC.PorcentajeDescuento
	FROM ERP.ListaPrecio L INNER JOIN ERP.ListaPrecioDetalle LPC
		ON LPC.IdListaPrecio = L.ID
	WHERE LPC.IdProducto = @IdProducto AND LPC.IdListaPrecio = @IdListaPrecio
	

END