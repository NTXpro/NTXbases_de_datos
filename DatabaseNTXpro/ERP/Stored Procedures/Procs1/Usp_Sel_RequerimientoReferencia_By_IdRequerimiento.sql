
CREATE PROC ERP.Usp_Sel_RequerimientoReferencia_By_IdRequerimiento
@IdRequerimiento INT
AS
BEGIN
SELECT RR.ID
    ,RR.IdRequerimiento
    ,RR.IdReferenciaOrigen
    ,RR.IdReferencia
    ,RR.IdTipoComprobante
	,TC.Nombre NombreTipoComprobante
    ,RR.Serie
    ,RR.Documento
    ,RR.FlagInterno
FROM [ERP].[RequerimientoReferencia] RR
LEFT JOIN [PLE].[T10TipoComprobante] TC ON TC.ID = RR.IdTipoComprobante
WHERE IdRequerimiento = @IdRequerimiento 
END
