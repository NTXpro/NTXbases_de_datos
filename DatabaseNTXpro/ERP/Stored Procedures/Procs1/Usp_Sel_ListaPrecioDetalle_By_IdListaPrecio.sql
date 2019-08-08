
CREATE PROC [ERP].[Usp_Sel_ListaPrecioDetalle_By_IdListaPrecio] --4,'SER'
@IdListaPrecio INT,
@Nombre VARCHAR(250)
AS
BEGIN
	
	SELECT LPD.ID,
			IdListaPrecio,
			LPD.IdProducto,
			P.Nombre,
			PrecioUnitario,
			PorcentajeDescuento
	FROM ERP.ListaPrecioDetalle LPD INNER JOIN ERP.Producto P
		ON P.ID = LPD.IdProducto
	WHERE IdListaPrecio = @IdListaPrecio AND P.Flag = 1 AND P.FlagBorrador = 0 AND (@Nombre = '' OR  (@Nombre != '' AND P.Nombre LIKE '%'+ @Nombre + '%'))
	
END