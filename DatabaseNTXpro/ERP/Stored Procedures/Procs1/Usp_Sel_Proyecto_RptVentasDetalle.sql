
CREATE PROCEDURE ERP.Usp_Sel_Proyecto_RptVentasDetalle
@IdProyecto INT,
@FechaDesde DATETIME,
@FechaHasta DATETIME
AS
	SELECT C.IdTipoComprobante, C.Serie, C.Documento, C.TipoCambio, C.Fecha,
			CASE 
				WHEN P.IdMoneda = 1 AND C.IdMoneda = 1 THEN C.Total
				WHEN P.IdMoneda = 2 AND C.IdMoneda = 2 THEN C.Total
				WHEN P.IdMoneda = 2 AND C.IdMoneda = 1 THEN C.Total / C.TipoCambio
				WHEN P.IdMoneda = 1 AND C.IdMoneda = 2 THEN C.Total * C.TipoCambio
				ELSE 0 END Importe
	FROM ERP.Comprobante C
	INNER JOIN ERP.Proyecto P ON P.ID = C.IdProyecto
	WHERE C.IdComprobanteEstado IN (1, 2)
	AND C.IdTipoComprobante IN (2, 3, 4, 13)
	AND C.Flag = 1
	AND C.FlagBorrador = 0
	AND C.IdProyecto = @IdProyecto
	AND (@FechaDesde IS NULL OR @FechaDesde <= C.Fecha)
	AND (@FechaHasta IS NULL OR @FechaHasta >= C.Fecha)
