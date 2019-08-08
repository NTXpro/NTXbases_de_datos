CREATE FUNCTION [ERP].[GenerarNombreAsientoDetalleCuentaPagar] (@IdCuentaPagar INT)
RETURNS VARCHAR(250)
AS
BEGIN

		DECLARE @NombreAsientoDetalle VARCHAR(250);

		DECLARE @AbreviaturaComprobante VARCHAR(250);
		DECLARE @IdTipoComprobante INT = (SELECT IdTipoComprobante FROM ERP.CuentaPagar WHERE ID = @IdCuentaPagar);
		DECLARE @Serie VARCHAR(8) = (SELECT Serie FROM ERP.CuentaPagar WHERE ID = @IdCuentaPagar);
		DECLARE @Documento VARCHAR(20) =(SELECT Numero FROM ERP.CuentaPagar WHERE ID = @IdCuentaPagar);

		DECLARE @TipoDocumento VARCHAR(20) = (SELECT TD.Abreviatura 
													FROM ERP.CuentaPagar C
													INNER JOIN ERP.Entidad ENT
													ON ENT.ID = C.IdEntidad
													INNER JOIN ERP.EntidadTipoDocumento ETD
													ON ETD.IdEntidad = ENT.ID	
													INNER JOIN PLE.T2TipoDocumento TD
													ON TD.ID = ETD.IdTipoDocumento
													WHERE C.ID = @IdCuentaPagar)
		DECLARE @DocumentoEntidad VARCHAR(20) = (SELECT ETD.NumeroDocumento 
													FROM ERP.CuentaPagar C
													INNER JOIN ERP.Entidad ENT
													ON ENT.ID = C.IdEntidad
													INNER JOIN ERP.EntidadTipoDocumento ETD
													ON ETD.IdEntidad = ENT.ID
													WHERE C.ID = @IdCuentaPagar)
		DECLARE @NombreCliente VARCHAR(250) = (SELECT ENT.Nombre
													FROM ERP.CuentaPagar CP
													INNER JOIN ERP.Entidad ENT
													ON ENT.ID = CP.IdEntidad
													WHERE CP.ID = @IdCuentaPagar)
		IF @IdTipoComprobante = 2 --FACTURA
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@TipoDocumento,'/',@DocumentoEntidad,'/',@NombreCliente,'/FAC/',@Serie,'/',@Documento);
		END
	ELSE IF @IdTipoComprobante = 4 --BOLETA
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@TipoDocumento,'/',@DocumentoEntidad,'/',@NombreCliente,'/BOL/',@Serie,'/',@Documento);
		END
	ELSE IF @IdTipoComprobante = 8 --NOTA CREDITO
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@TipoDocumento,'/',@DocumentoEntidad,'/',@NombreCliente,'/NCR/',@Serie,'/',@Documento);
		END
	ELSE IF @IdTipoComprobante = 9  --NOTA DEBITO
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@TipoDocumento,'/',@DocumentoEntidad,'/',@NombreCliente,'/NDE/',@Serie,'/',@Documento);
		END
	ELSE IF  @IdTipoComprobante = 183 --ANTICIPO
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@TipoDocumento,'/',@DocumentoEntidad,'/',@NombreCliente,'/ANT/',@Serie,'/',@Documento);
		END
	ELSE IF  @IdTipoComprobante = 13 --TICKET
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@TipoDocumento,'/',@DocumentoEntidad,'/',@NombreCliente,'/TIC/',@Serie,'/',@Documento);
		END
	ELSE IF  @IdTipoComprobante = 178 --LETRA
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@TipoDocumento,'/',@DocumentoEntidad,'/',@NombreCliente,'/LET/',@Serie,'/',@Documento);
		END
	ELSE IF  @IdTipoComprobante = 200 --NOTA CREDITO DUAS
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@TipoDocumento,'/',@DocumentoEntidad,'/',@NombreCliente,'/NCRD/',@Serie,'/',@Documento);
		END
	ELSE 
		BEGIN
			SELECT @AbreviaturaComprobante = ISNULL(Abreviatura, '-')
			FROM PLE.T10TipoComprobante
			WHERE ID = @IdTipoComprobante

			SET @NombreAsientoDetalle = CONCAT(@TipoDocumento,'/',@DocumentoEntidad,'/',@NombreCliente,'/', UPPER(@AbreviaturaComprobante), '/', @Serie,'/',@Documento);
		END		

		RETURN 	@NombreAsientoDetalle

END