CREATE FUNCTION [ERP].[GenerarNombreAsientoDetalleTesoreria](
@IdTipoComprobante	INT,
@Serie CHAR(4),
@Documento CHAR(8),
@NombreCliente VARCHAR(250)
)
RETURNS VARCHAR(250)
AS
BEGIN
	DECLARE @NombreAsientoDetalle VARCHAR(250)
	
	DECLARE @Abreviatura VARCHAR(5)= (SELECT Abreviatura FROM [PLE].[T10TipoComprobante] WHERE ID = @IdTipoComprobante);

	IF @Abreviatura = NULL
	BEGIN
		SET @NombreAsientoDetalle = @Abreviatura + @Serie + '/' + @Documento + ' ' + @NombreCliente
	END
	ELSE
	BEGIN
		SET @NombreAsientoDetalle = @NombreCliente
	END

	RETURN 	@NombreAsientoDetalle

END
