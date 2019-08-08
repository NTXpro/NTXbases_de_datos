
CREATE PROC [ERP].[Usp_Sel_Cliente_Borrador_Pagination]
@IdEmpresa int
AS
BEGIN

		SELECT	C.ID,
				EN.Nombre,
				C.FechaRegistro,
				C.FechaEliminado,
				ETD.NumeroDocumento,
				TD.Nombre AS NombreTipoDocumento
		FROM ERP.Cliente C
		INNER JOIN ERP.Entidad EN
			ON EN.ID = C.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = EN.ID
		INNER JOIN PLE.T2TipoDocumento TD
			ON TD.ID = ETD.IdTipoDocumento
		WHERE C.FlagBorrador = 1 AND C.IdEmpresa = @IdEmpresa

END
