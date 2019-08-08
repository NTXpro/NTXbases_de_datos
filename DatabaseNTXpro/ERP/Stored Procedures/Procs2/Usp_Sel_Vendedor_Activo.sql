

CREATE PROC [ERP].[Usp_Sel_Vendedor_Activo]
@IdEmpresa INT
AS
BEGIN
		SELECT
				V.ID,
				EN.Nombre,
				t.IdEntidad
		FROM ERP.Vendedor V
		INNER JOIN ERP.Trabajador T
			ON T.ID = V.IdTrabajador
		INNER JOIN ERP.Entidad EN
			ON EN.ID = T.IdEntidad
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = EN.ID
		WHERE V.FlagBorrador = 0 AND V.Flag = 1 AND T.IdEmpresa = @IdEmpresa

END

