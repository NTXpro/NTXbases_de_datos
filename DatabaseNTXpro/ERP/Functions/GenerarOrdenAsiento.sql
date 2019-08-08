
CREATE FUNCTION [ERP].[GenerarOrdenAsiento](
@IdPeriodo	INT,
@IdEmpresa	INT,
@IdOrigen	INT
)
RETURNS INT
AS
BEGIN
	DECLARE @Orden INT = (SELECT MAX(Orden) FROM ERP.Asiento WHERE IdPeriodo = @IdPeriodo AND IdEmpresa = @IdEmpresa 
							AND IdOrigen = @IdOrigen AND FlagBorrador = 0)
	
	IF @Orden IS NULL
		BEGIN
			SET @Orden = 1
		END
	ELSE
		BEGIN
			SET @Orden = @Orden + 1
		END

	RETURN 	@Orden

END
