CREATE PROC [ERP].[Usp_Upd_CompraDetraccion]
@IdCompraDetraccion INT,
@Comprobante VARCHAR(50),
@Importe DECIMAL,
@FechaDetraccion DATETIME
AS
BEGIN
	
	UPDATE ERP.CompraDetraccion SET Comprobante = @Comprobante , Importe = @Importe ,FechaDetraccion=@FechaDetraccion WHERE ID = @IdCompraDetraccion 

END
