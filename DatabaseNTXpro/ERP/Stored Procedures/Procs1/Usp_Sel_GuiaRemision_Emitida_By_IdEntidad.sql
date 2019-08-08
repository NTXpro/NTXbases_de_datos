CREATE PROC ERP.Usp_Sel_GuiaRemision_Emitida_By_IdEntidad -- 1, 82, '0001', '00000007'
@IdEmpresa INT,
@IdEntidad INT,
@Serie VARCHAR(4),
@Documento VARCHAR(8)
AS
BEGIN
	SELECT	GR.ID,
			GR.Serie,
			GR.Documento,
			GR.Total,
			TC.Nombre NombreTipoComprobante
	FROM ERP.GuiaRemision GR
	LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = GR.IdTipoComprobante
	WHERE GR.IdEmpresa = @IdEmpresa AND GR.IdEntidad = @IdEntidad 
	 AND (@Serie = '' OR GR.Serie = @Serie) AND (@Documento = '' OR GR.Documento = @Documento)
	AND GR.IdGuiaRemisionEstado = 2
END