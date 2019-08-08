CREATE FUNCTION [ERP].[GenerarNombreAsientoCuentaCobrar] (@IdCuentaCobrar INT)
RETURNS VARCHAR(250)
AS
BEGIN

		DECLARE @NombreAsientoDetalle VARCHAR(250);

		DECLARE @IdTipoComprobante INT = (SELECT IdTipoComprobante FROM ERP.CuentaCobrar WHERE ID = @IdCuentaCobrar);
		DECLARE @Serie VARCHAR(8) = (SELECT Serie FROM ERP.CuentaCobrar WHERE ID = @IdCuentaCobrar);
		DECLARE @Documento VARCHAR(20) =(SELECT Numero FROM ERP.CuentaCobrar WHERE ID=@IdCuentaCobrar);
		DECLARE @TipoDocumento VARCHAR(20) = (SELECT	TD.Abreviatura 
													FROM ERP.CuentaCobrar C
													INNER JOIN ERP.Entidad ENT
													ON ENT.ID = C.IdEntidad
													INNER JOIN ERP.EntidadTipoDocumento ETD
													ON ETD.IdEntidad = ENT.ID	
													INNER JOIN PLE.T2TipoDocumento TD
													ON TD.ID = ETD.IdTipoDocumento
													WHERE C.ID = @IdCuentaCobrar)
		DECLARE @DocumentoEntidad VARCHAR(20) = (SELECT ETD.NumeroDocumento 
													FROM ERP.CuentaCobrar C
													INNER JOIN ERP.Entidad ENT
													ON ENT.ID = C.IdEntidad
													INNER JOIN ERP.EntidadTipoDocumento ETD
													ON ETD.IdEntidad = ENT.ID
													WHERE C.ID = @IdCuentaCobrar)

		DECLARE @NombreCliente VARCHAR(250) = (SELECT ENT.Nombre
													FROM ERP.CuentaCobrar CP
													INNER JOIN ERP.Entidad ENT
													ON ENT.ID = CP.IdEntidad
													WHERE CP.ID = @IdCuentaCobrar)
		
	IF @IdTipoComprobante = 8 --NOTA CREDITO
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@TipoDocumento,'/',@DocumentoEntidad,'/',@NombreCliente,'/NCR');
		END
	ELSE IF  @IdTipoComprobante = 183 --ANTICIPO
		BEGIN
			SET @NombreAsientoDetalle = CONCAT(@TipoDocumento,'/',@DocumentoEntidad,'/',@NombreCliente,'/ANT');
		END

		RETURN 	@NombreAsientoDetalle

END
