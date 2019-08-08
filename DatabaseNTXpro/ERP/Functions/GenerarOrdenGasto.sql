CREATE FUNCTION ERP.GenerarOrdenGasto (@IdTipoComprobante INT ,@IdMes INT ,@IdAnio INT) RETURNS INT
AS
BEGIN
		DECLARE @OrdenGasto INT;

		DECLARE @Numero INT = (SELECT COUNT(ID) FROM ERP.Gasto WHERE Flag = 1 AND FlagBorrador = 0 AND YEAR(FechaEmision)= @IdAnio AND MONTH(FechaEmision)=@IdMes AND IdTipoComprobante = @IdTipoComprobante)


		IF (@Numero = 0)
		BEGIN
			SET @OrdenGasto = 1;
		END
	ELSE
		BEGIN
			SET @OrdenGasto = @Numero + 1;
		END

		RETURN @OrdenGasto
	

END
