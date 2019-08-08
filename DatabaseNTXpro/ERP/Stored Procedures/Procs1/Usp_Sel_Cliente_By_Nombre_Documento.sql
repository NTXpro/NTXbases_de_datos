
CREATE PROC [ERP].[Usp_Sel_Cliente_By_Nombre_Documento]-- 1,'PP'
@IdEmpresa INT,
@NombreDocumento VARCHAR(250)
AS
BEGIN
		
	SELECT	C.ID,
			EN.Nombre AS NombreCompleto,
			C.FechaRegistro,
			P.Nombre,
			P.ApellidoPaterno,
			P.ApellidoMaterno,
			ETD.IdTipoDocumento,
			ETD.NumeroDocumento,
		   TD.Abreviatura AS NombreTipoDocumento
	FROM ERP.Cliente C
	INNER JOIN ERP.Entidad EN
		ON EN.ID = C.IdEntidad
	LEFT JOIN ERP.Persona P
		ON P.IdEntidad = EN.ID
	INNER JOIN ERP.EntidadTipoDocumento ETD
		ON ETD.IdEntidad = EN.ID
	INNER JOIN PLE.T2TipoDocumento TD
		ON TD.ID = ETD.IdTipoDocumento
	WHERE C.Flag = 1 AND C.FlagBorrador = 0 AND C.IdEmpresa = @IdEmpresa AND (@NombreDocumento = '' OR (EN.Nombre LIKE '%'+@NombreDocumento+'%' OR ETD.NumeroDocumento LIKE '%'+@NombreDocumento+'%'))

END

