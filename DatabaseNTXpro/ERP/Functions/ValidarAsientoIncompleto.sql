
CREATE FUNCTION [ERP].[ValidarAsientoIncompleto](
@IdAsiento INT
)
RETURNS BIT
AS
BEGIN
	DECLARE @RESULT BIT

	DECLARE @CountDetalleIncompleto INT = (SELECT COUNT(ID) FROM ERP.AsientoDetalle 
											WHERE IdAsiento = @IdAsiento AND IdPlanCuenta IS NULL)
	
	DECLARE @Debe DECIMAL(14,2) = (SELECT [ERP].[ObtenerTotalDebe_By_Asiento](@IdAsiento))
	DECLARE @Haber DECIMAL(14,2) = (SELECT [ERP].[ObtenerTotalHaber_By_Asiento](@IdAsiento))

	IF @CountDetalleIncompleto > 0 OR @Debe != @Haber
		BEGIN
			SET @RESULT = CAST(1 AS BIT)  
		END
	ELSE
		BEGIN
			SET @RESULT = CAST(0 AS BIT)  
		END

	RETURN @RESULT
END
