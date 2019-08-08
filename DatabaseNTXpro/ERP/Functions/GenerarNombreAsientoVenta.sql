
CREATE FUNCTION [ERP].[GenerarNombreAsientoVenta](
@IdComprobante	INT
)
RETURNS VARCHAR(250)
AS
BEGIN
	DECLARE @NombreAsiento VARCHAR(250)
	
	DECLARE @NombreCliente VARCHAR(250) = (SELECT E.Nombre
										FROM ERP.Comprobante C 
										INNER JOIN ERP.Cliente CLI ON CLI.ID = C.IdCliente
										INNER JOIN ERP.Entidad E ON E.ID = CLI.IdEntidad
										INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = CLI.IdEntidad
										INNER JOIN PLE.T2TipoDocumento TD ON TD.ID = ETD.IdTipoDocumento 
										WHERE C.ID = @IdComprobante);

	--DECLARE @NombreComprobante VARCHAR(250) = (SELECT UPPER(TC.Abreviatura) + '/'+C.Serie+'/'+C.Documento
	--											FROM ERP.Comprobante C 
	--											INNER JOIN PLE.T10TipoComprobante TC ON TC.ID = C.IdTipoComprobante
	--											WHERE C.ID = @IdComprobante);

	SET @NombreAsiento = @NombreCliente ;--+ '/'+@NombreComprobante
	
	RETURN 	@NombreAsiento

END
