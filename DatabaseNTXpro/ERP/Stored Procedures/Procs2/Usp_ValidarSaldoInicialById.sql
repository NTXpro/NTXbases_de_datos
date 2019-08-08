CREATE PROC ERP.Usp_ValidarSaldoInicialById
@IdSaldoInicial INT
AS
BEGIN
		DECLARE @IdProveedor INT =(SELECT IdProveedor FROM ERP.SaldoInicial WHERE ID = @IdSaldoInicial)
		DECLARE @IdMoneda INT = (SELECT IdMoneda FROM ERP.SaldoInicial WHERE ID = @IdSaldoInicial)
		DECLARE @IdTipoComprobante INT =(SELECT IdTipoComprobante From ERP.SaldoInicial WHERE ID=@IdSaldoInicial)
		DECLARE @Serie VARCHAR(20) = (SELECT Serie FROM ERP.SaldoInicial WHERE ID=@IdSaldoInicial)
		DECLARE @Documento VARCHAR(20) =(SELECT Documento FROM ERP.SaldoInicial WHERE ID = @IdSaldoInicial)

		EXEC ERP.Usp_ValidadSaldoInicial @IdProveedor,@IdMoneda,@IdTipoComprobante,@Serie,@Documento
END
