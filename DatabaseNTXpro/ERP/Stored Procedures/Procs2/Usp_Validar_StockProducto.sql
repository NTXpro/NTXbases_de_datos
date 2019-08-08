CREATE PROC [ERP].[Usp_Validar_StockProducto]
@DataResult VARCHAR(MAX) OUT,
@XMLVale	 XML,
@IdVale		 INT
AS
BEGIN
	DECLARE @IdEmpresa INT = (SELECT T.N.value('IdEmpresa[1]','INT') FROM @XMLVale.nodes('/ArchivoPlanoVale') AS T(N));
	DECLARE @OUPUT_DATA VARCHAR(MAX);
	DECLARE @ID_ALMACEN INT = (SELECT T.N.value('IdAlmacen[1]','INT') FROM @XMLVale.nodes('/ArchivoPlanoVale') AS T(N));
	DECLARE @TABLE_DETALLE TABLE (IdProducto INT, Lote VARCHAR(20), Cantidad DECIMAL(18,5));
		
	INSERT INTO @TABLE_DETALLE
	SELECT
		IdProducto,
		Lote,
		SUM(Cantidad)
	FROM
	(SELECT
		T.N.value('IdProducto[1]', 'INT') AS IdProducto,
		T.N.value('NumeroLote[1]', 'VARCHAR(50)') AS Lote,
		T.N.value('Cantidad[1]', 'DECIMAL(18,5)') AS Cantidad
	FROM 
	@XMLVale.nodes('/ListaArchivoPlanoValeDetalle/ArchivoPlanoValeDetalle') AS T(N)) TEMP
	GROUP BY IdProducto, Lote
		
	DECLARE @DETALLE_XML XML = (SELECT * FROM @TABLE_DETALLE FOR XML PATH('Detalle'), ROOT ('Detalle'));			
		

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
						A.ID = @ID_ALMACEN) TEMP) TT
						INNER JOIN @DETALLE_XML.nodes('/Detalle/Detalle') AS T(N) ON TT.IdProducto = T.N.value('IdProducto[1]', 'INT') AND TT.NumeroLote = T.N.value('Lote[1]', 'VARCHAR(20)')
						WHERE 
						TT.RowNumber = 1
						AND (SELECT COUNT(ID) FROM ERP.Receta r WHERE R.IdProducto =T.N.value('IdProducto[1]', 'INT') )=0
						AND
						TT.Stock - T.N.value('Cantidad[1]', 'DECIMAL(18,5)') < 0
						FOR XML PATH(''))
	

	SET @DataResult = ISNULL(REPLACE(SUBSTRING(@DataResult, 1, LEN(@DataResult) -1), ' ',''),'');

END