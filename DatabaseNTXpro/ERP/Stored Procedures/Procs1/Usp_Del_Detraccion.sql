CREATE PROC [ERP].[Usp_Del_Detraccion]
@IdDetraccion			INT
AS
BEGIN
	UPDATE [ERP].[CompraDetraccion] SET Comprobante = NULL , FechaDetraccion = NULL
	WHERE ID = @IdDetraccion
END
