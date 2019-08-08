CREATE PROC [ERP].[Usp_Sel_Cotizacion_Borrador]
@IdEmpresa INT
AS
BEGIN
		
		SELECT	C.ID,
				C.Serie,
				C.Documento,
				C.Fecha,
				C.IdCotizacionEstado,
				C.Total,
				E.Nombre
		FROM ERP.Cotizacion C LEFT JOIN ERP.Cliente CLI
			ON CLI.ID = C.IdCliente
		LEFT JOIN ERP.Entidad E
			ON E.ID = CLI.IdEntidad
		WHERE C.FlagBorrador = 1 AND C.IdEmpresa = @IdEmpresa

END
