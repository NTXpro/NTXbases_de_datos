CREATE FUNCTION [ERP].[GenerarOrdenAnticipo] (@IdTipoComprobante INT ,@IdMes INT ,@IdAnio INT) RETURNS INT
AS
BEGIN
		DECLARE @OrdenAnticipo INT;

		DECLARE @Numero INT = (SELECT COUNT(ID) FROM ERP.AnticipoCompra WHERE Flag = 1 AND FlagBorrador = 0 AND YEAR(FechaEmision)= @IdAnio AND MONTH(FechaEmision)=@IdMes AND IdTipoComprobante = @IdTipoComprobante)


		IF (@Numero = 0)
		BEGIN
			SET @OrdenAnticipo = 1;
		END
	ELSE
		BEGIN
			SET @OrdenAnticipo = @Numero + 1;
		END

		RETURN @OrdenAnticipo
	

END
