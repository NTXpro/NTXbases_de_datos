CREATE PROCEDURE [ERP].[Usp_Sel_Vendedor_Export]
@Flag bit
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
		WHERE V.Flag = @Flag AND V.FlagBorrador = 0
END
