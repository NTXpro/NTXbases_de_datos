CREATE FUNCTION ERP.FN_StockProducto_Empresa
(
	@IdEmpresa INT,
	@IdAlmacen INT
)
RETURNS TABLE
AS
	RETURN (
		SELECT SUM(CASE
					WHEN V.IdTipoMovimiento = 1 THEN VD.Cantidad
					ELSE VD.Cantidad * -1 END) Stock, VD.IdProducto
		FROM ERP.ValeDetalle VD
		INNER JOIN ERP.Vale V ON VD.IdVale = V.ID
		INNER JOIN Maestro.ValeEstado VE ON V.IdValeEstado = VE.ID
		WHERE V.Flag = 1
		AND V.IdValeEstado != 2
		AND V.FlagBorrador = 0
		AND V.IdEmpresa = @IdEmpresa
		AND (V.IdAlmacen = @IdAlmacen OR @IdAlmacen = 0)
		GROUP BY VD.IdProducto
	)