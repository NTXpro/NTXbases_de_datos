CREATE PROCEDURE [ERP].[Usp_Sel_Inventario_FormatoCuatroDetalleProducto]
@IdEmpresa INT,
@IdEstablecimiento INT,
@IdAlmacen INT,
@IdMoneda INT,
@FechaHasta DATETIME
AS
BEGIN

	WITH KARDEX AS (
	SELECT
		ROW_NUMBER() OVER (PARTITION BY TEMP.IdProducto ORDER BY TEMP.FechaMovimiento, TEMP.Orden) AS RowNumber,
		TEMP.IdValeDetalle,
		TEMP.IdProducto,
		TEMP.NombreProducto,
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
		P.Nombre AS NombreProducto,
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
		P.IdEmpresa = @IdEmpresa AND
		E.ID = @IdEstablecimiento AND
		A.ID = @IdAlmacen AND
		CAST(V.Fecha AS DATE) <= CAST(@FechaHasta AS DATE)) TEMP
	)

	SELECT
		K.IdEstablecimiento,
		K.IdAlmacen,
		K.IdProducto,
		K.NombreProducto,
		K.NombreUnidadMedida,
		CASE WHEN KTEMP.IngresoInicial = 0 AND KTEMP.SalidaInicial = 0 THEN 0 ELSE (KTEMP.IngresoInicial - KTEMP.SalidaInicial) END AS SaldoInicialCantidad,
		KTEMP.PrecioPromedioInicial,
		CASE WHEN KTEMP.IngresoMontoInicial = 0 AND KTEMP.SalidaMontoInicial = 0 THEN 0 ELSE (KTEMP.IngresoMontoInicial - KTEMP.SalidaMontoInicial) END AS SaldoInicialMonto,
		KTEMP.IngresoCantidad,
		KTEMP.IngresoMonto,
		KTEMP.SalidaCantidad,
		KTEMP.SalidaMonto,
		CASE WHEN KTEMP.IngresoFinal = 0 AND KTEMP.SalidaFinal = 0 THEN 0 ELSE (KTEMP.IngresoFinal - KTEMP.SalidaFinal) END AS SaldoFinalCantidad,
		KTEMP.PrecioPromedioFinal,
		CASE WHEN KTEMP.IngresoMontoFinal = 0 AND KTEMP.SalidaMontoFinal = 0 THEN 0 ELSE (KTEMP.IngresoMontoFinal - KTEMP.SalidaMontoFinal) END AS SaldoFinalMonto
	FROM Kardex K
	INNER JOIN (SELECT 
					T1.IdProducto,
					MAX(0) RowNumber,
					
					SUM(CASE WHEN YEAR(T1.FechaMovimiento) < YEAR(@FechaHasta) THEN T1.Ingreso ELSE 0 END) AS IngresoInicial,
					SUM(CASE WHEN YEAR(T1.FechaMovimiento) < YEAR(@FechaHasta) THEN T1.Salida ELSE 0 END) AS SalidaInicial,
					SUM(CASE WHEN YEAR(T1.FechaMovimiento) < YEAR(@FechaHasta) THEN CASE WHEN RowNumber = T2.RowNumberMax THEN PrecioPromedio ELSE 0 END ELSE 0 END) AS PrecioPromedioInicial,
					SUM(CASE WHEN YEAR(T1.FechaMovimiento) < YEAR(@FechaHasta) THEN CASE WHEN T1.Abreviatura = 'I' THEN T1.Total ELSE 0 END ELSE 0 END) AS IngresoMontoInicial,
					SUM(CASE WHEN YEAR(T1.FechaMovimiento) < YEAR(@FechaHasta) THEN CASE WHEN T1.Abreviatura = 'S' THEN T1.Total ELSE 0 END ELSE 0 END) AS SalidaMontoInicial,
					
					SUM(CASE WHEN YEAR(T1.FechaMovimiento) = YEAR(@FechaHasta) THEN T1.Ingreso ELSE 0 END) AS IngresoCantidad,
					SUM(CASE WHEN YEAR(T1.FechaMovimiento) = YEAR(@FechaHasta) THEN CASE WHEN T1.Abreviatura = 'I' THEN T1.Total ELSE 0 END ELSE 0 END) AS IngresoMonto,

					SUM(CASE WHEN YEAR(T1.FechaMovimiento) = YEAR(@FechaHasta) THEN T1.Salida ELSE 0 END) AS SalidaCantidad,
					SUM(CASE WHEN YEAR(T1.FechaMovimiento) = YEAR(@FechaHasta) THEN CASE WHEN T1.Abreviatura = 'S' THEN T1.Total ELSE 0 END ELSE 0 END) AS SalidaMonto,
					
					SUM(T1.Ingreso) AS IngresoFinal,
					SUM(T1.Salida) AS SalidaFinal,
					SUM(CASE WHEN RowNumber = T2.RowNumberMax THEN PrecioPromedio ELSE 0 END) AS PrecioPromedioFinal,
					SUM(CASE WHEN T1.Abreviatura = 'I' THEN T1.Total ELSE 0 END) AS IngresoMontoFinal,
					SUM(CASE WHEN T1.Abreviatura = 'S' THEN T1.Total ELSE 0 END) AS SalidaMontoFinal

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
	K.RowNumber = 1
	ORDER BY
	K.NombreProducto
END