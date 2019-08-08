
CREATE FUNCTION [ERP].[GenerarOrdenCompra](
@IdPeriodo	INT,
@IdEmpresa INT
)
RETURNS INT
AS
BEGIN
	DECLARE @Orden INT = (SELECT MAX(Orden) FROM [ERP].[Compra] WHERE IdPeriodo = @IdPeriodo AND IdEmpresa = @IdEmpresa)
	
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
