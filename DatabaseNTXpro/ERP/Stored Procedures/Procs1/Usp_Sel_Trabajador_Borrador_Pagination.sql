
CREATE PROC [ERP].[Usp_Sel_Trabajador_Borrador_Pagination]
@IdEmpresa int
AS
BEGIN

		SELECT	T.ID,
				EN.Nombre,
				T.FechaRegistro,
				T.FechaEliminado,
				ETD.NumeroDocumento,
				TD.Nombre AS NombreTipoDocumento,
				V.ID IdVendedor
		FROM ERP.Trabajador T
		INNER JOIN ERP.Entidad EN
			ON EN.ID = T.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = EN.ID
		INNER JOIN PLE.T2TipoDocumento TD
			ON TD.ID = ETD.IdTipoDocumento
		LEFT JOIN ERP.Vendedor V
			ON V.IdTrabajador = T.ID
		WHERE T.FlagBorrador = 1 AND T.IdEmpresa = @IdEmpresa AND V.ID IS NULL

END
