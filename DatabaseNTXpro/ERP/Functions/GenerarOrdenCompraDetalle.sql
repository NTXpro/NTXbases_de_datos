
CREATE FUNCTION [ERP].[GenerarOrdenCompraDetalle](
@IdCompra	INT
)
RETURNS INT
AS
BEGIN
	DECLARE @OrdenDetalle INT = (SELECT MAX(Orden) FROM [ERP].[CompraDetalle] WHERE IdCompra = @IdCompra)
	
	IF @OrdenDetalle IS NULL
		BEGIN
			SET @OrdenDetalle = 1
		END
	ELSE
		BEGIN
			SET @OrdenDetalle = @OrdenDetalle + 1
		END

	RETURN 	@OrdenDetalle
END
