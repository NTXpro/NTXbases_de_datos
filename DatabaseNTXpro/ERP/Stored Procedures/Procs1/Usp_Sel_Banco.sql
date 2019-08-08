CREATE PROC [ERP].[Usp_Sel_Banco]
AS
BEGIN

	SELECT B.ID,
		   B.IdEntidad,
		   B.CodigoSunat,
		   E.Nombre,
		   ETD.NumeroDocumento,
		   CodigoSunat,
		   FlagSunat,
		   B.IdEntidad
	FROM PLE.T3Banco B LEFT JOIN ERP.Entidad E
		ON E.ID = B.IdEntidad
	LEFT JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = E.ID
	WHERE B.Flag = 1 AND B.FlagBorrador = 0
	
END