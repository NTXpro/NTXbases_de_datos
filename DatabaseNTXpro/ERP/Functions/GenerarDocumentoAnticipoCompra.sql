
CREATE FUNCTION [ERP].[GenerarDocumentoAnticipoCompra] (@IdTipoComprobante INT ,@IdMes INT ,@IdAnio INT) RETURNS VARCHAR(8)
AS
BEGIN
		DECLARE @DocumentoAnticipo VARCHAR(8);

		DECLARE @Numero INT = (SELECT COUNT(ID) FROM ERP.AnticipoCompra WHERE Flag = 1 AND FlagBorrador = 0 AND YEAR(FechaEmision)= @IdAnio AND MONTH(FechaEmision)=@IdMes AND IdTipoComprobante = @IdTipoComprobante)


		IF (@Numero = 0)
		BEGIN
			SET @Numero = 1;
			SET @DocumentoAnticipo = RIGHT('0000000' + CAST(@Numero AS VARCHAR(8)), 8)
		END
	ELSE
		BEGIN
			SET @Numero = @Numero + 1;
			SET @DocumentoAnticipo = RIGHT('0000000' + CAST(@Numero AS VARCHAR(8)), 8)
		END

		RETURN @DocumentoAnticipo
	

END
