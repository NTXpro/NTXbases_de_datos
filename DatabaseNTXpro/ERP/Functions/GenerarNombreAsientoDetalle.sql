
create FUNCTION [ERP].[GenerarNombreAsientoDetalle](
@IdComprobante	INT
)
RETURNS VARCHAR(250)
AS
BEGIN
	DECLARE @NombreAsientoDetalle VARCHAR(250)
	
	DECLARE @IdTipoComprobante INT = (SELECT IdTipoComprobante FROM ERP.Comprobante WHERE ID = @IdComprobante)
	DECLARE @Serie CHAR(4) = (SELECT Serie FROM ERP.Comprobante WHERE ID = @IdComprobante)
	DECLARE @Documento CHAR(8) = (SELECT Documento FROM ERP.Comprobante WHERE ID = @IdComprobante)
	DECLARE @NombreCliente VARCHAR(250) = (SELECT E.Nombre
										FROM ERP.Comprobante C 
										INNER JOIN ERP.Cliente CLI
											ON CLI.ID = C.IdCliente
										INNER JOIN ERP.Entidad E
											ON E.ID = CLI.IdEntidad
										WHERE C.ID = @IdComprobante)

	IF @IdTipoComprobante = 2 --FACTURA
		BEGIN
			SET @NombreAsientoDetalle = 'FAC' + @Serie + '/' + @Documento + ' ' + @NombreCliente
		END
	ELSE IF @IdTipoComprobante = 4 --BOLETA
		BEGIN
			SET @NombreAsientoDetalle = 'BOL' + @Serie + '/' + @Documento + ' ' + @NombreCliente
		END
	ELSE IF @IdTipoComprobante = 8 --NOTA CREDITO
		BEGIN
			SET @NombreAsientoDetalle = 'NCR' + @Serie + '/' + @Documento + ' ' + @NombreCliente
		END
	ELSE IF @IdTipoComprobante = 9  --NOTA DEBITO
		BEGIN
			SET @NombreAsientoDetalle = 'NDE' + @Serie + '/' + @Documento + ' ' + @NombreCliente
		END
	ELSE IF  @IdTipoComprobante = 183 --ANTICIPO
		BEGIN
			SET @NombreAsientoDetalle = 'ANT' + @Serie + '/' + @Documento + ' ' + @NombreCliente
		END
	ELSE IF  @IdTipoComprobante = 13 --TICKET
		BEGIN
			SET @NombreAsientoDetalle = 'TIC' + @Serie + '/' + @Documento + ' ' + @NombreCliente
		END

	RETURN 	@NombreAsientoDetalle

END
