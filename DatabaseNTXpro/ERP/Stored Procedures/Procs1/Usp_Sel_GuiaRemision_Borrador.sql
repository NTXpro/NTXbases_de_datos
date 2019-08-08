CREATE PROC [ERP].[Usp_Sel_GuiaRemision_Borrador]
@IdEmpresa INT
AS
BEGIN
	SELECT GR.Serie,
		   GR.ID,
		   GR.Documento,
		   GR.Fecha,
		   GR.Total,
		   ENT.Nombre Entidad
	FROM ERP.GuiaRemision GR
	LEFT JOIN ERP.Entidad ENT ON ENT.ID = GR.IdEntidad
	WHERE GR.IdEmpresa = @IdEmpresa AND GR.FlagBorrador = 1
END
