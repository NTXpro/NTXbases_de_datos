CREATE FUNCTION [ERP].[ObtenerTotalHaber_By_Asiento](
@IdAsiento INT
)
RETURNS DECIMAL(15,5)
AS
BEGIN
	DECLARE @IdMoneda INT
	DECLARE @HABER DECIMAL(15,5);

	SELECT @IdMoneda = IdMoneda
	FROM ERP.Asiento
	WHERE ID = @IdAsiento
	
	IF @IdMoneda = 1
		BEGIN
			SELECT @HABER = SUM(ImporteSoles) 
			FROM ERP.AsientoDetalle
			WHERE IdAsiento = @IdAsiento AND IdDebeHaber = 2/*HABER*/
		END
	ELSE
		BEGIN
			SELECT @HABER = SUM(ImporteDolares) 
			FROM ERP.AsientoDetalle
			WHERE IdAsiento = @IdAsiento AND IdDebeHaber = 2/*HABER*/
		END

	RETURN ISNULL(@HABER,0)
END



