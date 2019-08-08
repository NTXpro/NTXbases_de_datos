
CREATE PROC [ERP].[Usp_Sel_Vendedor_Borrador_Pagination]
@IdEmpresa INT
AS
BEGIN
		SELECT
				V.ID,
				EN.Nombre,
				V.FechaRegistro,
				V.FechaEliminado,
				ETD.NumeroDocumento
		FROM ERP.Vendedor V
		INNER JOIN ERP.Trabajador T
			ON T.ID = V.IdTrabajador
		INNER JOIN ERP.Entidad EN
			ON EN.ID = T.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = EN.ID
		WHERE IdEmpresa = @IdEmpresa AND V.FlagBorrador = 1

END

