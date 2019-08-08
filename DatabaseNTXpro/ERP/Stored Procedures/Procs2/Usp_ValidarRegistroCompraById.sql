CREATE PROC [ERP].[Usp_ValidarRegistroCompraById]
@IdCompra INT
AS
BEGIN
	
		DECLARE @IdProveedor INT =(SELECT IdProveedor FROM ERP.Compra WHERE ID = @IdCompra)
		DECLARE @IdMoneda INT = (SELECT IdMoneda FROM ERP.Compra WHERE ID = @IdCompra)
		DECLARE @IdTipoComprobante INT =(SELECT IdTipoComprobante From ERP.Compra WHERE ID=@IdCompra)
		DECLARE @Serie VARCHAR(20) = (SELECT Serie FROM ERP.Compra WHERE ID=@IdCompra)
		DECLARE @Documento VARCHAR(20) =(SELECT Numero FROM ERP.Compra WHERE ID = @IdCompra)

		EXEC [ERP].[Usp.ValidarRegistroCompra] @IdProveedor,@IdMoneda,@IdTipoComprobante,@Serie,@Documento
END
