
CREATE FUNCTION [ERP].[ObtenerNombreComprobante_By_IdTipoComprobanteSerieDocumento](@IdTipoComprobante INT,@Serie VARCHAR(4),@Documento VARCHAR(20))
RETURNS VARCHAR(250)
AS
BEGIN

	DECLARE @NombreTipoComprobante VARCHAR(250) = (SELECT Nombre FROM PLE.T10TipoComprobante WHERE ID = @IdTipoComprobante)

	DECLARE @Result VARCHAR(250)=  SUBSTRING(ISNULL(@NombreTipoComprobante,''),0,4) + '-' + ISNULL(@Serie,'')+ '-'  + ISNULL(@Documento,'');

	RETURN 	UPPER(@Result)
END


