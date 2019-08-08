
CREATE FUNCTION [ERP].[ObtenerImporteAsiento70_By_IdPlanCuenta](
@IdComprobante INT,
@IdPlanCuenta INT
)
RETURNS DECIMAL(14,5)
AS
BEGIN

	DECLARE @ImporteAsiento70 DECIMAL(14,5) =(SELECT SUM(CASE WHEN C.IdMoneda = 1 THEN
														CD.PrecioSubTotal - (CD.PrecioSubTotal * (C.PorcentajeDescuento / 100))
													ELSE
														(CD.PrecioSubTotal * C.TipoCambio) - ((CD.PrecioSubTotal * C.TipoCambio) * (C.PorcentajeDescuento / 100))
													end) 
											 FROM ERP.ComprobanteDetalle CD 
											 INNER JOIN ERP.Comprobante C
												ON C.ID = CD.IdComprobante
											 INNER JOIN ERP.Producto P
											 	ON P.ID = CD.IdProducto
											 WHERE CD.IdComprobante = @IdComprobante AND P.IdPlanCuenta = @IdPlanCuenta)

	RETURN ISNULL(@ImporteAsiento70,0)
END
