CREATE PROC [ERP].[Usp_Sel_Entidad_Borrador_Pagination]
AS
BEGIN

	SELECT	E.ID,
			E.Nombre "NombreCompleto",
			TD.Abreviatura "NombreTipoDocumento",
			ETD.NumeroDocumento
	FROM ERP.Entidad E
	INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = E.ID
	INNER JOIN [PLE].[T2TipoDocumento] TD
		ON TD.ID = ETD.IdTipoDocumento
	LEFT JOIN ERP.Cliente C
		ON C.IdEntidad = E.ID
	LEFT JOIN ERP.Proveedor P
		ON P.IdEntidad = E.ID
	LEFT JOIN ERP.Empresa EMP
		ON EMP.IdEntidad = E.ID
	LEFT JOIN ERP.Trabajador T
		ON T.IdEntidad = E.ID
	LEFT JOIN PLE.T3Banco B
		ON B.IdEntidad = E.ID
	WHERE E.FlagBorrador = 1 AND C.ID IS NULL AND P.ID IS NULL AND EMP.ID IS NULL AND T.ID IS NULL AND B.ID IS NULL
	ORDER BY 1 DESC

END

