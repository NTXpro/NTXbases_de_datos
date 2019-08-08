CREATE FUNCTION [ERP].[ObtenerFechaCompraReferencia](@IdCompra INT)
RETURNS VARCHAR(50)
AS
BEGIN
		DECLARE @Fecha VARCHAR(50) = (SELECT TOP 1 CAST(C.FechaEmision AS DATE)
									FROM ERP.CompraReferencia R
									INNER JOIN ERP.Compra C
									ON R.IdReferencia = C.ID
									INNER JOIN ERP.Compra CM
									ON CM.ID = R.IdCompra
									LEFT JOIN PLE.T10TipoComprobante T10
									ON C.IdTipoComprobante = T10.ID 
									WHERE R.IdCompra = @IdCompra)
		RETURN CAST(@Fecha AS VARCHAR(50))
END
