CREATE PROCEDURE [ERP].[Usp_Sel_Importacion_ImportarReferenciaInterna] --'15,46,47,48,49,57,58'
@Ids VARCHAR(MAX)
AS
BEGIN
	DECLARE @ID_REFERENCIA_ORIGEN INT = (SELECT TOP 1 ID FROM Maestro.ReferenciaOrigen WHERE Codigo = 'LOGOC');

	SELECT DISTINCT 
		@ID_REFERENCIA_ORIGEN AS IdReferenciaOrigen,
		OD.ID AS IdReferencia,
		OD.IdTipoComprobante,
		OD.Serie,
		OD.Documento,
		UPPER(TC.Abreviatura) AS AbreviaturaTipoComprobante
	FROM ERP.OrdenCompradetalle OCD
	INNER JOIN ERP.OrdenCompra OD ON OCD.IdOrdenCompra = OD.ID
	INNER JOIN PLE.T10TipoComprobante TC ON OD.IdTipoComprobante = TC.ID
	WHERE OCD.ID IN (SELECT Data FROM [ERP].[Fn_SplitContenido](@Ids, ','))
END
