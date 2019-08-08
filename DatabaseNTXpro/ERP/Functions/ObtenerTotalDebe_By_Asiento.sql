CREATE FUNCTION [ERP].[ObtenerTotalDebe_By_Asiento](
@IdAsiento INT
)
RETURNS DECIMAL(15,5)
AS
BEGIN
	DECLARE @IdMoneda INT
	DECLARE @DEBE DECIMAL(15,5);

	SELECT @IdMoneda = IdMoneda
	FROM ERP.Asiento
	WHERE ID = @IdAsiento

	IF @IdMoneda = 1
		BEGIN
			SELECT @DEBE = SUM(ImporteSoles)
			FROM ERP.AsientoDetalle
			WHERE IdAsiento = @IdAsiento AND IdDebeHaber = 1/*DEBE*/
		END
	ELSE
		BEGIN
			SELECT @DEBE = SUM(ImporteDolares)
			FROM ERP.AsientoDetalle
			WHERE IdAsiento = @IdAsiento AND IdDebeHaber = 1/*DEBE*/
		END
	
	RETURN ISNULL(@DEBE,0)
END

