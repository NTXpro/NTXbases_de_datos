CREATE PROC [ERP].[Usp_Sel_GuiaRemision_By_Serie_Documento]
@IdEntidad INT,
@IdTipoComprobante INT,
@IdEmpresa INT,
@Serie VARCHAR(4),
@Documento VARCHAR(10)
AS
BEGIN

	SELECT GR.ID,
		   GR.IdTipoComprobante,
		   TC.Nombre NombreTipoComprobante,
		   GR.Serie,
		   GR.Documento,
		   RO.ID		IdOrigen
	FROM ERP.GuiaRemision GR
	INNER JOIN PLE.T10TipoComprobante TC
	ON TC.ID = GR.IdTipoComprobante
	LEFT JOIN Maestro.ReferenciaOrigen RO
	ON RO.Codigo = 'LOGGRE'
	WHERE GR.IdTipoComprobante = @IdTipoComprobante AND GR.Serie= @Serie AND GR.Documento = @Documento
	AND GR.FlagBorrador = 0 AND GR.Flag = 1 AND GR.IdEntidad = @IdEntidad
	
END
