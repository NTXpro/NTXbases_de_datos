CREATE PROC [ERP].[Usp_Sel_ProductoStock_By_CodigoNombre]
@IdEmpresa INT,
@IdAlmacen INT,
@IdMoneda INT,
@Fecha DATETIME,
@CodigoNombre VARCHAR(250),
@IdListaPrecio INT
AS
BEGIN

	SELECT 
		TT.IdValeDetalle,
		TT.FechaMovimiento,
		TT.Abreviatura,
		TT.NumeroVale,
		TT.IdTipoMovimiento,
		TT.IdAlmacen,
		TT.NombreAlmacen,
		TT.IdProducto,
		TT.CodigoReferencia,
		TT.NombreProducto,
		TT.Peso,
		TT.StockMinimo,
		TT.StockDeseable,
		TT.FlagIGVAfecto,
		TT.IdMarca,
		TT.NombreMarca,
		TT.IdUnidadMedida,
		TT.CodigoSunatUnidadMedida,
		TT.NombreUnidadMedida,
		TT.NumeroLote,
		(TT.Cantidad - TR.Cantidad) AS Cantidad,
		TT.Fecha,
		TT.SaldoMonto,
		TT.Ingreso,
		TT.Salida,
		TT.Stock,
		TT.PrecioUnitario,
		TT.PrecioPromedio,
		TT.PrecioLista,
		CASE WHEN TT.Stock <= TT.StockDeseable THEN
			CAST(1 AS BIT)
		ELSE
			CAST(0 AS BIT)
		END AS FlagRequiereStock,
		CASE WHEN TT.Stock <= TT.StockDeseable THEN
			TT.StockDeseable - TT.Stock
		ELSE
			0
		END AS APedirStockDeseable
	FROM
	(SELECT
		ROW_NUMBER() OVER (PARTITION BY TEMP.IdProducto, TEMP.NumeroLote ORDER BY TEMP.RowNumber DESC) AS RowNumber,
		TEMP.IdValeDetalle,
		TEMP.FechaMovimiento,
		TEMP.Abreviatura,
		TEMP.NumeroVale,
		TEMP.IdTipoMovimiento,
		TEMP.IdAlmacen,
		TEMP.NombreAlmacen,
		TEMP.IdProducto,
		TEMP.CodigoReferencia,
		TEMP.NombreProducto,
		Temp.Peso,
		Temp.StockMinimo,
		Temp.StockDeseable,
		TEMP.FlagIGVAfecto,
		TEMP.IdMarca,
		TEMP.NombreMarca,
		TEMP.IdUnidadMedida,
		TEMP.CodigoSunatUnidadMedida,
		TEMP.NombreUnidadMedida,
		TEMP.NumeroLote,
		TEMP.Cantidad,
		TEMP.Fecha,
		TEMP.SaldoMonto,
		TEMP.Ingreso,
		TEMP.Salida,
		TEMP.SaldoCantidad AS Stock,
		TEMP.PrecioUnitario,
		CASE WHEN TEMP.SaldoCantidad <= 0 THEN TEMP.PrecioUnitario ELSE TEMP.SaldoMonto/TEMP.SaldoCantidad END AS PrecioPromedio,
		TEMP.PrecioLista
	FROM
	(SELECT
		ROW_NUMBER() OVER(PARTITION BY VD.IdProducto, VD.NumeroLote ORDER BY V.Fecha, V.Orden) AS RowNumber,
		VD.ID AS IdValeDetalle,
		V.Fecha AS FechaMovimiento,
		V.Orden,
		TM.Abreviatura,
		V.Documento AS NumeroVale,
		TM.ID AS IdTipoMovimiento,
		A.ID AS IdAlmacen,
		A.Nombre AS NombreAlmacen,
		P.ID AS IdProducto,
		UPPER(P.CodigoReferencia) AS CodigoReferencia,
		P.Nombre AS NombreProducto,
		P.Peso,
		ISNULL(P.StockMinimo, 0) StockMinimo,
		ISNULL(P.StockDeseable, 0) StockDeseable,
		P.FlagIGVAfecto,
		M.ID AS IdMarca,
		M.Nombre NombreMarca,
		UM.ID AS IdUnidadMedida,
		UM.CodigoSunat CodigoSunatUnidadMedida,
		UM.Nombre NombreUnidadMedida,	
		VD.NumeroLote,
		VD.Cantidad,
		VD.Fecha,
		SUM(CASE WHEN TM.Abreviatura = 'I' THEN VD.Cantidad * VD.PrecioUnitario ELSE (VD.Cantidad * VD.PrecioUnitario) * -1 END) 
		OVER(PARTITION BY VD.IdProducto, VD.NumeroLote ORDER BY V.Fecha, V.Orden) AS SaldoMonto,
		ISNULL((CASE WHEN TM.Abreviatura = 'I' THEN VD.Cantidad END), 0) AS Ingreso,
		ISNULL((CASE WHEN TM.Abreviatura = 'S' THEN VD.Cantidad END), 0) AS Salida,
		SUM(ISNULL(CASE WHEN TM.Abreviatura = 'I' THEN VD.Cantidad ELSE VD.Cantidad * -1 END, 0)) OVER(PARTITION BY VD.IdProducto, VD.NumeroLote ORDER BY V.Fecha, V.Orden) as SaldoCantidad,
		CASE 
			WHEN V.IdMoneda = 1 THEN
				CASE 
					WHEN @IdMoneda = 1 THEN VD.PrecioUnitario
					ELSE VD.PrecioUnitario / TCD.VentaSunat
				END
			ELSE 
				CASE 
					WHEN @IdMoneda = 1 THEN VD.PrecioUnitario * TCD.VentaSunat
					ELSE VD.PrecioUnitario
				END
		END AS PrecioUnitario,
		LPC.PrecioUnitario AS PrecioLista
	FROM ERP.ValeDetalle VD
	INNER JOIN ERP.Vale V ON VD.IdVale = V.ID
	INNER JOIN Maestro.ValeEstado VE ON V.IdValeEstado = VE.ID
	LEFT JOIN ERP.Entidad EN ON V.IdEntidad = EN.ID
	INNER JOIN PLE.T12TipoOperacion TOPE ON V.IdConcepto = TOPE.ID
	INNER JOIN Maestro.TipoMovimiento TM ON V.IdTipoMovimiento = TM.ID
	INNER JOIn ERP.Producto P ON VD.IdProducto = P.ID
	INNER JOIN ERP.Almacen A ON V.IdAlmacen = A.ID
	LEFT JOIN ERP.TipoCambioDiario TCD ON CAST(V.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
	LEFT JOIN [PLE].[T6UnidadMedida] UM ON UM.ID = P.IdUnidadMedida
	LEFT JOIN Maestro.Marca M ON M.ID = P.IdMarca
	------ LISTA DE PRECIO ------
	LEFT JOIN ERP.ListaPrecioDetalle LPC ON (@IdListaPrecio = 0 AND P.ID = -1) OR (P.ID = LPC.IdProducto AND LPC.IdListaPrecio = @IdListaPrecio)
	WHERE
	VE.Abreviatura NOT IN ('A') AND
	ISNULL(V.FlagBorrador, 0) = 0 AND
	V.Flag = 1 AND
	V.IdEmpresa = @IdEmpresa AND
	P.IdEmpresa = @IdEmpresa AND
	A.ID = @IdAlmacen AND
	(@CodigoNombre IS NULL OR @CodigoNombre = '' OR (P.Nombre LIKE '%' + @CodigoNombre + '%' OR P.CodigoReferencia LIKE '%' + @CodigoNombre + '%')) AND
	V.FECHA<=@Fecha
	--ORDER BY V.Fecha, V.idTipoMovimiento
	) TEMP
	) TT
	LEFT JOIN (SELECT
					SUM(ISNULL(S_TR.Cantidad, 0)) AS Cantidad,
					S_TR.Lote,
					S_TR.IdProducto
				FROM
				(SELECT
					GRD.Cantidad,
					GRD.Lote,
					GRD.IdProducto
				FROM ERP.GuiaRemision GR
				INNER JOIN Maestro.GuiaRemisionEstado GRE ON GR.IdGuiaRemisionEstado = GRE.ID
				INNER JOIN ERP.GuiaRemisionDetalle GRD ON GR.ID = GRD.IdGuiaRemision
				INNER JOIN [XML].[T20MotivoTraslado] MT ON GR.IdMotivoTraslado = MT.ID
				INNER JOIN [PLE].[T12TipoOperacion] TOPE ON MT.IdTipoOperacion = TOPE.ID
				INNER JOIN Maestro.TipoMovimiento TM ON TOPE.IdTipoMovimiento = TM.ID
				WHERE
				GRE.Abreviatura = 'R' AND
				TM.Abreviatura = 'S' AND
				ISNULL(GR.FlagBorrador, 0) = 0 AND
				GR.Flag = 1

				UNION ALL

				SELECT
					CD.Cantidad,
					CD.NumeroLote AS Lote,
					CD.IdProducto 
				FROM ERP.Comprobante C
				INNER JOIN Maestro.ComprobanteEstado CE ON C.IdComprobanteEstado = CE.ID
				INNER JOIN ERP.ComprobanteDetalle CD ON C.ID = CD.IdComprobante
				WHERE
				CE.Abreviatura = 'R' AND
				C.FlagGenerarVale = 1 AND
				ISNULL(C.FlagBorrador, 0) = 0 AND
				C.Flag = 1) AS S_TR
				GROUP BY
				S_TR.Lote,
				S_TR.IdProducto) TR ON TT.NumeroLote = TR.Lote AND TT.IdProducto = TR.IdProducto
	WHERE 
	TT.RowNumber = 1 
	--AND TT.Stock > 0
END