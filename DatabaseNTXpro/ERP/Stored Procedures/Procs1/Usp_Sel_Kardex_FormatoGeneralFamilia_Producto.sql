CREATE PROCEDURE [ERP].[Usp_Sel_Kardex_FormatoGeneralFamilia_Producto]
@IdEmpresa INT,
@IdTipoFormato INT,
@IdEstablecimiento INT,
@IdAlmacen INT,
@IdMoneda INT,
@FechaDesde DATETIME,
@FechaHasta DATETIME,
@IdProducto INT,
@IdProyecto INT,
@IdsFamilia VARCHAR(MAX)
AS
BEGIN

	DECLARE @TABLE TABLE (
		ID INT PRIMARY KEY NOT NULL,
		Nombre VARCHAR(MAX),
		Ruta VARCHAR(MAX)
	);

	IF (@IdTipoFormato = 2)
	BEGIN
		WITH CTE AS (
		SELECT 
			F1.ID, 
			F1.Nombre, 
			F1.Nombre AS Ruta, 
			F1.IdFamiliaPadre
		FROM ERP.Familia F1 
		WHERE F1.IdFamiliaPadre IS NULL
		UNION ALL
		SELECT 
			F2.ID, 
			F2.Nombre, 
			CAST(CTE.Ruta + ' | ' + F2.Nombre AS VARCHAR(MAX)), 
			F2.IdFamiliaPadre
		FROM ERP.Familia F2
		INNER JOIN CTE ON F2.IdFamiliaPadre = CTE.ID
		)
		INSERT INTO @TABLE (ID, Nombre, Ruta)
		SELECT 
			ID, 
			Nombre, 
			Ruta
		FROM CTE;
	END;

	WITH KARDEX AS (
	SELECT
		ROW_NUMBER() OVER (PARTITION BY TEMP.IdProducto ORDER BY TEMP.FechaMovimiento, TEMP.Orden) AS RowNumber,
		TEMP.IdValeDetalle,
		TEMP.IdProducto,
		TEMP.NombreProducto,
		TEMP.CodigoReferenciaProducto,
		TEMP.IdUnidadMedida,
		TEMP.NombreUnidadMedida,
		TEMP.IdTipoMovimiento,
		TEMP.Abreviatura,
		TEMP.NumeroVale,
		TEMP.DocumentoReferencia,
		TEMP.FechaMovimiento,
		TEMP.Orden,
		TEMP.IdEstablecimiento,
		TEMP.NombreEstablecimiento,
		TEMP.IdAlmacen,
		TEMP.NombreAlmacen,
		TEMP.NombreEntidad,
		TEMP.NombreConcepto,
		TEMP.Cantidad,
		TEMP.Ingreso,
		TEMP.Salida,
		TEMP.SaldoCantidad,
		TEMP.PrecioUnitario,
		TEMP.PrecioUnitario * Cantidad AS Total,
		TEMP.SaldoMonto,
		CASE WHEN TEMP.SaldoCantidad <= 0 THEN PrecioUnitario ELSE TEMP.SaldoMonto / TEMP.SaldoCantidad END AS PrecioPromedio
	FROM
	(SELECT 
		VD.ID AS IdValeDetalle,
		P.ID AS IdProducto,
		CASE WHEN @IdTipoFormato = 1 THEN P.Nombre ELSE CONCAT(T.Ruta, ' | ', P.Nombre) END AS NombreProducto,
		P.CodigoReferencia AS CodigoReferenciaProducto,
		UM.ID AS IdUnidadMedida,
		UM.Nombre AS NombreUnidadMedida,
		TM.ID AS IdTipoMovimiento,
		TM.Abreviatura,
		V.Documento AS NumeroVale,
		CONCAT(VR.Serie, ' ' ,VR.Documento) AS DocumentoReferencia,
		V.Fecha AS FechaMovimiento,
		V.Orden,
		E.ID AS IdEstablecimiento,
		E.Nombre AS NombreEstablecimiento,
		A.ID AS IdAlmacen,
		A.Nombre AS NombreAlmacen,
		EN.Nombre AS NombreEntidad,
		TOPE.Nombre AS NombreConcepto,
		VD.Cantidad,
		SUM(CASE WHEN TM.Abreviatura = 'I' THEN VD.Cantidad * VD.PrecioPromedio ELSE (VD.Cantidad * VD.PrecioUnitario) * -1 END) 
		OVER(PARTITION BY VD.IdProducto ORDER BY V.Fecha, V.Orden) AS SaldoMonto,
		ISNULL((CASE WHEN TM.Abreviatura = 'I' THEN VD.Cantidad END), 0) AS Ingreso,
		ISNULL((CASE WHEN TM.Abreviatura = 'S' THEN VD.Cantidad END), 0) AS Salida,
		SUM(ISNULL(CASE WHEN TM.Abreviatura = 'I' THEN VD.Cantidad ELSE VD.Cantidad * -1 END, 0)) OVER(PARTITION BY VD.IdProducto ORDER BY V.Fecha, V.Orden) as SaldoCantidad,
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
		END AS PrecioUnitario
		FROM ERP.ValeDetalle VD
		INNER JOIN ERP.Vale V ON VD.IdVale = V.ID
		INNER JOIN Maestro.ValeEstado VE ON V.IdValeEstado = VE.ID
		INNER JOIN PLE.T12TipoOperacion TOPE ON V.IdConcepto = TOPE.ID
		INNER JOIN Maestro.TipoMovimiento TM ON V.IdTipoMovimiento = TM.ID
		INNER JOIN ERP.Producto P ON VD.IdProducto = P.ID
		INNER JOIN ERP.Almacen A ON V.IdAlmacen = A.ID
		INNER JOIN ERP.Establecimiento E ON A.IdEstablecimiento = E.ID
		LEFT JOIN ERP.TipoCambioDiario TCD ON CAST(V.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
		LEFT JOIN ERP.Entidad EN ON V.IdEntidad = EN.ID
		LEFT JOIN [PLE].[T6UnidadMedida] UM ON UM.ID = P.IdUnidadMedida
		LEFT JOIN ERP.FamiliaProducto FP ON P.ID = FP.IdProducto
		LEFT JOIN @TABLE T ON FP.IdFamilia = T.ID
		LEFT JOIN (SELECT
					IdVale, 
					Serie,
					Documento
				FROM ERP.ValeReferencia 
				WHERE ID IN (SELECT MIN(ID) FROM ERP.ValeReferencia WHERE FlagInterno = 1 GROUP BY IdVale)) VR ON V.ID = VR.IdVale
		WHERE
		VE.Abreviatura NOT IN ('A') AND
		ISNULL(V.FlagBorrador, 0) = 0 AND
		V.Flag = 1 AND
		--------------
		V.IdEmpresa = @IdEmpresa AND
		(@IdProyecto = 0 OR V.IdProyecto = @IdProyecto) AND
		P.IdEmpresa = @IdEmpresa AND
		E.ID = @IdEstablecimiento AND
		A.ID = @IdAlmacen AND
		(
		(@IdTipoFormato = 1 AND (@IdProducto = 0 OR P.ID = @IdProducto)) OR
		(@IdTipoFormato = 2 AND T.ID IN (SELECT Data FROM [ERP].[Fn_SplitContenido](@IdsFamilia, ',')))
		) AND
		CAST(V.Fecha AS DATE) <= CAST(@FechaHasta AS DATE)) TEMP
	)

	SELECT
		CASE WHEN K.FechaMovimiento >= CAST(@FechaDesde AS DATE) THEN 0 ELSE 1 END Flag,
		K.RowNumber,
		K.IdValeDetalle,
		K.IdEstablecimiento,
		K.IdAlmacen,
		K.IdProducto,
		K.NombreProducto,
		K.CodigoReferenciaProducto,
		CASE WHEN K.FechaMovimiento >= CAST(@FechaDesde AS DATE) THEN 0 ELSE K.SaldoCantidad END AS SaldoInicialCantidad,
		KTEMP.Ingreso AS IngresoCantidad,
		KTEMP.Salida AS SalidaCantidad,
		CASE WHEN KTEMP.Ingreso = 0 AND KTEMP.Salida = 0 THEN 0 ELSE KTEMP.SaldoFinal END AS SaldoFinalCantidad,
		CASE WHEN K.FechaMovimiento >= CAST(@FechaDesde AS DATE) THEN 0 ELSE K.SaldoCantidad END * K.PrecioUnitario AS SaldoInicialMonto,
		KTEMP.IngresoMonto,
		KTEMP.SalidaMonto,
		CASE WHEN KTEMP.IngresoMonto = 0 AND KTEMP.SalidaMonto = 0 THEN 0 ELSE KTEMP.SaldoFinalMonto END AS SaldoFinalMonto,
		KTEMP.PrecioPromedio,
		K.IdUnidadMedida,
		K.NombreUnidadMedida
	FROM Kardex K
	INNER JOIN (SELECT 
					T1.IdProducto,
					MAX(CASE WHEN T1.FechaMovimiento < CAST(@FechaDesde AS DATE) THEN T1.RowNumber ELSE 0 END) RowNumber,
					SUM(T1.Ingreso) - SUM(T1.Salida) SaldoFinal,
					SUM(CASE WHEN T1.FechaMovimiento >= CAST(@FechaDesde AS DATE) THEN T1.Ingreso ELSE 0 END) AS Ingreso,
					SUM(CASE WHEN T1.FechaMovimiento >= CAST(@FechaDesde AS DATE) THEN T1.Salida ELSE 0 END) AS Salida,
					SUM(CASE WHEN T1.FechaMovimiento >= CAST(@FechaDesde AS DATE) THEN CASE WHEN T1.Abreviatura = 'I' THEN T1.Total ELSE 0 END ELSE 0 END) AS IngresoMonto,
					SUM(CASE WHEN T1.FechaMovimiento >= CAST(@FechaDesde AS DATE) THEN CASE WHEN T1.Abreviatura = 'S' THEN T1.Total ELSE 0 END ELSE 0 END) AS SalidaMonto,
					SUM(CASE WHEN T1.Abreviatura = 'I' THEN T1.Total ELSE 0 END) -
					SUM(CASE WHEN T1.Abreviatura = 'S' THEN T1.Total ELSE 0 END) SaldoFinalMonto,
					SUM(CASE WHEN RowNumber = T2.RowNumberMax THEN PrecioPromedio ELSE 0 END) AS PrecioPromedio
				FROM Kardex T1
				INNER JOIN (SELECT
							IdProducto,
							MAX(RowNumber) AS RowNumberMax
							FROM Kardex
							GROUP BY IdProducto) T2 ON T1.IdProducto = T2.IdProducto
				GROUP BY 
				T1.IdProducto,
				T2.RowNumberMax) KTEMP ON K.IdProducto = KTEMP.IdProducto AND K.RowNumber >= KTEMP.RowNumber
	WHERE
	K.RowNumber = 1 OR CASE WHEN K.FechaMovimiento >= CAST(@FechaDesde AS DATE) THEN 0 ELSE 1 END = 1
	Order by K.NombreProducto

END