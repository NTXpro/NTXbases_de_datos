CREATE PROC ERP.Usp_Upd_ListaPrecioDetalle
@ID INT,
@PrecioUnitario DECIMAL(14,5),
@PorcentajeDescuento INT
AS
BEGIN

	UPDATE ERP.ListaPrecioDetalle SET PrecioUnitario = @PrecioUnitario,PorcentajeDescuento = @PorcentajeDescuento
	WHERE ID = @ID
END