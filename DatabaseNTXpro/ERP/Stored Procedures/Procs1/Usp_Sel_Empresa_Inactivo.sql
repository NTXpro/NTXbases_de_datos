
CREATE PROC [ERP].[Usp_Sel_Empresa_Inactivo]
AS
BEGIN

	SELECT E.ID,
		   EN.Nombre,
		   E.FechaRegistro,
		   E.FechaEliminado,
		   ETD.NumeroDocumento,
		   TD.Nombre AS NombreTipoDocumento
	FROM ERP.Empresa E
	INNER JOIN ERP.Entidad EN
	ON EN.ID = E.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento ETD
	ON ETD.IdEntidad = EN.ID
	INNER JOIN PLE.T2TipoDocumento TD
	ON TD.ID = ETD.IdTipoDocumento
	WHERE E.Flag = 0 AND E.FlagBorrador = 0

END

