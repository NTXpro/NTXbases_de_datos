CREATE PROC [ERP].[Usp_Sel_Banco_Inactivo]
AS
BEGIN

	SELECT B.ID,
		   B.IdEntidad,
		   B.CodigoSunat,
		   E.Nombre,
		   ETD.NumeroDocumento,
		   B.FechaRegistro
	FROM PLE.T3Banco B INNER JOIN ERP.Entidad E
		ON E.ID = B.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = E.ID
	WHERE B.Flag = 0 AND B.FlagBorrador = 0
END
