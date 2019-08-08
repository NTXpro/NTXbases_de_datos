CREATE PROC [ERP].[Usp_Sel_Entidad_Inactivo]
AS
BEGIN

	SELECT	E.ID,
			E.Nombre "NombreCompleto",
			TD.Abreviatura "NombreTipoDocumento",
			ETD.NumeroDocumento,
			TP.Nombre
	FROM ERP.Entidad E
	INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = E.ID
	INNER JOIN [PLE].[T2TipoDocumento] TD
		ON TD.ID = ETD.IdTipoDocumento
	INNER JOIN [Maestro].[TipoPersona] TP
		ON TP.ID = E.IdTipoPersona
	WHERE E.FlagBorrador = 0	AND E.Flag=0
	ORDER BY 1 DESC

END
