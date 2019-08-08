CREATE PROCEDURE [ERP].[Usp_Sel_Entidad_By_Nombre_Documento]
@NombreDocumento VARCHAR(20)
AS
BEGIN
	SELECT	EN.ID,
			EN.Nombre AS NombreCompleto,
			EN.FechaRegistro,
			P.Nombre,
			P.ApellidoPaterno,
			P.ApellidoMaterno,
			ETD.IdTipoDocumento,
			ETD.NumeroDocumento,
			TD.Abreviatura AS NombreTipoDocumento
	FROM ERP.Entidad EN
	LEFT JOIN ERP.Persona P ON P.IdEntidad = EN.ID
	INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = EN.ID
	INNER JOIN PLE.T2TipoDocumento TD ON TD.ID = ETD.IdTipoDocumento
	WHERE 
	EN.Flag = 1 AND 
	EN.FlagBorrador = 0
	AND (@NombreDocumento = '' OR (EN.Nombre LIKE '%' + @NombreDocumento + '%' OR ETD.NumeroDocumento LIKE '%' + @NombreDocumento + '%'))
END