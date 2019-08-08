CREATE FUNCTION [ERP].[StockDisponibleProducto](
@IdEmpresa INT,
@IdProducto INT,
@Almacen INT
)
RETURNS DECIMAL(15,5)
AS
BEGIN
	DECLARE @RETORNO DECIMAL(15,5);
SELECT TOP 1 @RETORNO = A.SaldoCantidad from 
(SELECT
						ROW_NUMBER() OVER(PARTITION BY VD.IdProducto, VD.NumeroLote ORDER BY V.Fecha, V.Orden) AS RowNumber,
						P.ID AS IdProducto,
						VD.NumeroLote,
						SUM(ISNULL(CASE WHEN TM.Abreviatura = 'I' THEN VD.Cantidad ELSE VD.Cantidad * -1 END, 0)) OVER(PARTITION BY VD.IdProducto, VD.NumeroLote ORDER BY V.Fecha, V.Orden) as SaldoCantidad
						FROM ERP.ValeDetalle VD
						INNER JOIN ERP.Vale V ON VD.IdVale = V.ID
						INNER JOIN Maestro.ValeEstado VE ON V.IdValeEstado = VE.ID
						INNER JOIN Maestro.TipoMovimiento TM ON V.IdTipoMovimiento = TM.ID
						INNER JOIn ERP.Producto P ON VD.IdProducto = P.ID
						INNER JOIN ERP.Almacen A ON V.IdAlmacen = A.ID
						WHERE
						VE.Abreviatura NOT IN ('A') AND
						ISNULL(V.FlagBorrador, 0) = 0 AND
						V.Flag = 1 AND
						V.IdEmpresa = @IdEmpresa AND
						P.IdEmpresa = @IdEmpresa AND
						A.ID = @Almacen AND
						VD.IdProducto = @IdProducto) A ORDER BY A.RowNumber DESC		
	
	RETURN ISNULL(@RETORNO,0)
END