CREATE PROC [ERP].[Usp_Sel_Trabajador_Pagination]
@Flag BIT
AS
BEGIN

	SELECT t.ID,
		  --- EN.Nombre,
		   t.FechaRegistro,
		   t.FechaEliminado,
		   P.ApellidoMaterno,
		   P.ApellidoPaterno,
		   P.Nombre,
		   ETD.NumeroDocumento,
		   TD.Nombre AS NombreTipoDocumento
	FROM ERP.Trabajador t
	INNER JOIN ERP.Entidad EN
	ON EN.ID = t.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento ETD
	ON ETD.IdEntidad = EN.ID
	INNER JOIN ERP.Persona P
	ON P.IdEntidad=EN.ID
	INNER JOIN PLE.T2TipoDocumento TD
	ON TD.ID = ETD.IdTipoDocumento
	WHERE t.Flag = @Flag AND t.FlagBorrador = 0

END
