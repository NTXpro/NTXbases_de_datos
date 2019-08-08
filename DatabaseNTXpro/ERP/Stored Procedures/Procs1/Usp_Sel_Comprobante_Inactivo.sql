
CREATE PROC [ERP].[Usp_Sel_Comprobante_Inactivo]
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
		WHERE C.FlagBorrador = 0 AND C.IdTipoComprobante = @IdTipoComprobante AND C.IdEmpresa = @IdEmpresa AND C.Flag=1

END
