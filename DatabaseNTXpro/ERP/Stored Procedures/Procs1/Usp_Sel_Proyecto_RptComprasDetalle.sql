CREATE PROCEDURE ERP.Usp_Sel_Proyecto_RptComprasDetalle
@IdProyecto INT,
@FechaDesde DATETIME,
@FechaHasta DATETIME
AS
	SELECT C.IdTipoComprobante, C.Serie, C.Numero, C.TipoCambio, C.FechaEmision,
			CASE 
				WHEN P.IdMoneda = 1 AND C.IdMoneda = 1 THEN CD.Importe
				WHEN P.IdMoneda = 2 AND C.IdMoneda = 2 THEN CD.Importe
				WHEN P.IdMoneda = 2 AND C.IdMoneda = 1 THEN CD.Importe / C.TipoCambio
				WHEN P.IdMoneda = 1 AND C.IdMoneda = 2 THEN CD.Importe * C.TipoCambio
				ELSE 0 END Importe,
			EN.Nombre NombreProveedor,
			C.Descripcion DescripcionCompra
	FROM ERP.Compra C
	INNER JOIN ERP.CompraDetalle CD ON C.ID = CD.IdCompra
	INNER JOIN ERP.Proyecto P ON P.ID = CD.IdProyecto
	LEFT JOIN ERP.Proveedor PR ON C.IdProveedor = PR.ID
	LEFT JOIN ERP.Entidad EN ON PR.IdEntidad = EN.ID
	WHERE C.Flag = 1
	AND C.FlagBorrador = 0
	AND CD.IdProyecto = @IdProyecto
	AND (@FechaDesde IS NULL OR @FechaDesde <= C.FechaEmision)
	AND (@FechaHasta IS NULL OR @FechaHasta >= C.FechaEmision)