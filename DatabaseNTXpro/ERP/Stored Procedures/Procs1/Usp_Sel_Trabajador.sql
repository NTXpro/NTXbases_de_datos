CREATE PROC [ERP].[Usp_Sel_Trabajador]
@IdEmpresa INT
AS
BEGIN
		
	SELECT	T.ID,
			EN.Nombre AS NombreCompleto,
			T.FechaRegistro,
			P.Nombre,
			P.ApellidoPaterno,
			P.ApellidoMaterno,
		   ETD.NumeroDocumento,
		   TD.Nombre AS NombreTipoDocumento,
		   T.IdEntidad
	FROM ERP.Trabajador T
	INNER JOIN ERP.Entidad EN
	ON EN.ID = T.IdEntidad
	LEFT JOIN ERP.Persona P
	ON P.IdEntidad = EN.ID
	INNER JOIN ERP.EntidadTipoDocumento ETD
	ON ETD.IdEntidad = EN.ID
	INNER JOIN PLE.T2TipoDocumento TD
	ON TD.ID = ETD.IdTipoDocumento
	WHERE T.Flag = 1 AND T.FlagBorrador = 0 AND T.IdEmpresa = @IdEmpresa

END
