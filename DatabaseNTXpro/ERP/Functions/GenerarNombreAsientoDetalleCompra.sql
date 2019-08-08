

CREATE FUNCTION [ERP].[GenerarNombreAsientoDetalleCompra](@IdComprobante INT)
RETURNS VARCHAR(500)
AS
BEGIN
	DECLARE @NombreAsientoDetalle VARCHAR(500)

	DECLARE @IdTipoComprobante INT = (SELECT IdTipoComprobante FROM ERP.Compra WHERE ID = @IdComprobante)
	DECLARE @Serie VARCHAR(8) = (SELECT Serie FROM ERP.Compra WHERE ID = @IdComprobante)
	DECLARE @Documento VARCHAR(20) =(SELECT Numero FROM ERP.Compra WHERE ID=@IdComprobante)
	
	DECLARE @TipoComprobante VARCHAR(20) = ISNULL((SELECT	Abreviatura 
													FROM [PLE].[T10TipoComprobante]
													WHERE ID = @IdTipoComprobante),'')
	
	DECLARE @TipoDocumento VARCHAR(20) = ISNULL((SELECT	TD.Abreviatura 
													FROM ERP.Compra C
													INNER JOIN ERP.Proveedor PRO
													ON PRO.ID = C.IdProveedor
													INNER JOIN ERP.Entidad ENT
													ON ENT.ID = PRO.IdEntidad
													INNER JOIN ERP.EntidadTipoDocumento ETD
													ON ETD.IdEntidad = ENT.ID	
													INNER JOIN PLE.T2TipoDocumento TD
													ON TD.ID = ETD.IdTipoDocumento
													WHERE C.ID = @IdComprobante),'')

	DECLARE @DocumentoEntidad VARCHAR(20) = (SELECT ETD.NumeroDocumento 
													FROM ERP.Compra C
													INNER JOIN ERP.Proveedor PRO
													ON PRO.ID = C.IdProveedor
													INNER JOIN ERP.Entidad ENT
													ON ENT.ID = PRO.IdEntidad
													INNER JOIN ERP.EntidadTipoDocumento ETD
													ON ETD.IdEntidad = ENT.ID
													WHERE C.ID = @IdComprobante)

	DECLARE @NombreCliente VARCHAR(250) = (SELECT E.Nombre
												FROM ERP.Compra C
												INNER JOIN ERP.Proveedor PRO
												ON PRO.ID = C.IdProveedor
												INNER JOIN ERP.Entidad E
												ON E.ID = PRO.IdEntidad
												WHERE C.ID = @IdComprobante)

	DECLARE @Descripcion VARCHAR(250) = (SELECT C.Descripcion FROM ERP.Compra C WHERE C.ID = @IdComprobante)

	IF @IdTipoComprobante = 2 --FACTURA
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@NombreCliente,'/FAC/',@Descripcion);
		END
	ELSE IF @IdTipoComprobante = 4 --BOLETA
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@NombreCliente,'/BOL/',@Descripcion);
		END
	ELSE IF @IdTipoComprobante = 8 --NOTA CREDITO
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@NombreCliente,'/NCR/',@Descripcion);
		END
	ELSE IF @IdTipoComprobante = 9  --NOTA DEBITO
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@NombreCliente,'/NDE/',@Descripcion);
		END
	ELSE IF  @IdTipoComprobante = 183 --ANTICIPO
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@NombreCliente,'/ANT/',@Descripcion);
		END
	ELSE IF @IdTipoComprobante = 3 -- RECIBO POR HONORARIO
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@NombreCliente,'/RH/',@Descripcion);
		END
	ELSE IF  @IdTipoComprobante = 13 --TICKET
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@NombreCliente,'/TIC/',@Descripcion);
		END
	ELSE IF  @IdTipoComprobante = 58 --COMPROBANTE DE NO DOMICILIADO
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@NombreCliente,'/CND/',@Descripcion);
		END
	ELSE 
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@NombreCliente,'/'+ISNULL(@TipoComprobante,'')+'/',@Descripcion);
		END
	RETURN 	@NombreAsientoDetalle
END
