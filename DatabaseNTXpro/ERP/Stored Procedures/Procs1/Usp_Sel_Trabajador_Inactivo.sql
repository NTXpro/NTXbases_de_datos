
CREATE PROC [ERP].[Usp_Sel_Trabajador_Inactivo]
@IdEmpresa int
AS
BEGIN

		SELECT	T.ID,
				EN.Nombre,
				T.FechaRegistro,
				T.FechaEliminado,
				ETD.NumeroDocumento,
				TD.Nombre AS NombreTipoDocumento
		FROM ERP.Trabajador T
		INNER JOIN ERP.Entidad EN
			ON EN.ID = T.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = EN.ID
		INNER JOIN PLE.T2TipoDocumento TD
			ON TD.ID = ETD.IdTipoDocumento
		WHERE T.FlagBorrador = 0 AND T.IdEmpresa = @IdEmpresa AND T.Flag = 0

END
