
CREATE PROC [ERP].Usp_Sel_ComparadorReferencia_By_IdComparador
@IdComparador INT
AS
BEGIN
SELECT RR.ID
    ,RR.IdComparador
    ,RR.IdReferenciaOrigen
    ,RR.IdReferencia
    ,RR.IdTipoComprobante
	,TC.Nombre NombreTipoComprobante
    ,RR.Serie
    ,RR.Documento
    ,RR.FlagInterno
FROM [ERP].[ComparadorReferencia] RR
LEFT JOIN [PLE].[T10TipoComprobante] TC ON TC.ID = RR.IdTipoComprobante
WHERE IdComparador = @IdComparador 
END