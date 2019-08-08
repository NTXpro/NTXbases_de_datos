CREATE PROC [ERP].[ValidarCompraDetraccion]  
@IdCompra	INT
AS 
BEGIN

	SELECT CO.ID,
		   CO.Orden,
		   CD.Comprobante,
		   CD.Importe,
		   CD.FechaDetraccion
	FROM ERP.Compra CO
	LEFT JOIN ERP.CompraDetraccion CD 
	ON CO.ID = CD.IdCompra
	LEFT JOIN [ERP].[Percepcion] PER
	ON PER.IdCompra = CO.ID
	WHERE CD.IdCompra = @IdCompra
END
