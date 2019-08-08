CREATE PROCEDURE [ERP].[Fn_Validar_StockProducto]
@IdEmpresa INT,
@IdAlmacen INT,
@IdVale INT,
@DetalleXML XML,
@DataResult VARCHAR(MAX) OUTPUT
AS
BEGIN
	SET @DataResult = (SELECT
							CAST(TT.IdProducto AS VARCHAR(MAX)) + '%' + 
							CAST(TT.NumeroLote AS VARCHAR(MAX)) + '%' +
							CAST(T.N.value('Cantidad[1]', 'DECIMAL(18,5)') AS VARCHAR(MAX)) + '%' + 
							CAST(TT.Stock AS VARCHAR(MAX)) + '|' AS 'data()'
						FROM
						(SELECT
							ROW_NUMBER() OVER (PARTITION BY TEMP.IdProducto, TEMP.NumeroLote ORDER BY TEMP.RowNumber DESC) AS RowNumber,
							TEMP.IdProducto,
							TEMP.NumeroLote,
							TEMP.SaldoCantidad AS Stock
						FROM
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
						V.ID <> @IdVale AND
						VE.Abreviatura NOT IN ('A') AND
						ISNULL(V.FlagBorrador, 0) = 0 AND
						V.Flag = 1 AND
						---------------
						V.IdEmpresa = @IdEmpresa AND
						P.IdEmpresa = @IdEmpresa AND
						A.ID = @IdAlmacen) TEMP) TT
						INNER JOIN @DetalleXML.nodes('/Detalle/Detalle') AS T(N) ON TT.IdProducto = T.N.value('IdProducto[1]', 'INT') AND TT.NumeroLote = T.N.value('Lote[1]', 'VARCHAR(20)')
						WHERE 
						TT.RowNumber = 1
						AND
						TT.Stock - T.N.value('Cantidad[1]', 'DECIMAL(18,5)') < 0
						FOR XML PATH(''))
	

	SET @DataResult = ISNULL(REPLACE(SUBSTRING(@DataResult, 1, LEN(@DataResult) -1), ' ',''),'');
END
