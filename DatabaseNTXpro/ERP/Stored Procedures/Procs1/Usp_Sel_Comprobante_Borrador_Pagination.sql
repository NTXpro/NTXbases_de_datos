
CREATE PROC [ERP].[Usp_Sel_Comprobante_Borrador_Pagination]
@IdTipoComprobante INT,
@IdEmpresa INT
AS
BEGIN
		
		SELECT	C.ID,
				C.Serie,
				C.Documento,
				C.Fecha,
				C.IdComprobanteEstado,
				C.Total,
				E.Nombre
		FROM ERP.Comprobante C LEFT JOIN ERP.Cliente CLI
			ON CLI.ID = C.IdCliente
		LEFT JOIN ERP.Entidad E
			ON E.ID = CLI.IdEntidad
		WHERE C.FlagBorrador = 1 AND C.IdTipoComprobante = @IdTipoComprobante AND C.IdEmpresa = @IdEmpresa

END
