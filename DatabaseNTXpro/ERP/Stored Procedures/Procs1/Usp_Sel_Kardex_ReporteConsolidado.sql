CREATE PROCEDURE [ERP].[Usp_Sel_Kardex_ReporteConsolidado] --1, 1, 2, 1, 1, '1/01/2018', '12/07/2018', 0, '0,1,14,15,16,2,17,3,4,18,19,12,20,21,13,22,23,24'
@IdEmpresa INT,
@IdTipoFormato INT,
@IdEstablecimiento INT,
@IdAlmacen INT,
@IdMoneda INT,
@FechaDesde DATETIME,
@FechaHasta DATETIME,
@IdProducto INT,
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
		ROW_NUMBER() OVER (PARTITION BY TEMP.IdEstablecimiento, TEMP.IdAlmacen, TEMP.IdProducto ORDER BY TEMP.FechaMovimiento, TEMP.Orden) AS RowNumber,
		TEMP.IdProducto,
		TEMP.NombreProducto,
		TEMP.CodigoReferenciaProducto,
		TEMP.NombreUnidadMedida,
		TEMP.IdTipoMovimiento,
		TEMP.Abreviatura,
		TEMP.NumeroVale,
		TEMP.DocumentoReferencia,
		TEMP.FechaMovimiento,
		TEMP.Orden,
		TEMP.IdEstablecimiento,
		TEMP.NombreEstablecimiento,
		TEMP.DireccionEstablecimiento,
		TEMP.IdAlmacen,
		TEMP.NombreAlmacen,
		TEMP.NombreEntidad,
		TEMP.NombreConcepto,
		TEMP.FechaVencimiento,
		TEMP.NumeroLote,
		TEMP.Cantidad,
		TEMP.Ingreso,
		TEMP.Salida,
		TEMP.SaldoCantidad,
		TEMP.PrecioUnitario,
		TEMP.PrecioUnitario * Cantidad AS Total,
		TEMP.SaldoMonto,
		TEMP.SaldoMonto / CASE WHEN TEMP.SaldoCantidad <= 0 THEN 1 ELSE TEMP.SaldoCantidad END AS PrecioPromedio
	FROM
	(SELECT 
		P.ID AS IdProducto,
		CASE WHEN @IdTipoFormato = 1 THEN P.Nombre ELSE CONCAT(T.Ruta, ' | ', P.Nombre) END AS NombreProducto,
		P.CodigoReferencia AS CodigoReferenciaProducto,
		UM.Nombre AS NombreUnidadMedida,
		TM.ID AS IdTipoMovimiento,
		TM.Abreviatura,
		V.Documento AS NumeroVale,
		CONCAT(VR.Serie, ' ' ,VR.Documento) AS DocumentoReferencia,
		V.Fecha AS FechaMovimiento,
		V.Orden,
		E.ID AS IdEstablecimiento,
		E.Nombre AS NombreEstablecimiento,
		E.Direccion AS DireccionEstablecimiento,
		A.ID AS IdAlmacen,
		A.Nombre AS NombreAlmacen,
		EN.Nombre AS NombreEntidad,
		TOPE.Nombre AS NombreConcepto,
		VD.Fecha AS FechaVencimiento,
		VD.NumeroLote,		
		VD.Cantidad,
		SUM(CASE WHEN TM.Abreviatura = 'I' THEN VD.Cantidad * VD.PrecioUnitario ELSE (VD.Cantidad * VD.PrecioUnitario) * -1 END) 
		OVER(PARTITION BY E.ID, A.ID, VD.IdProducto ORDER BY V.Fecha, V.Orden) AS SaldoMonto,
		ISNULL((CASE WHEN TM.Abreviatura = 'I' THEN VD.Cantidad END), 0) AS Ingreso,
		ISNULL((CASE WHEN TM.Abreviatura = 'S' THEN VD.Cantidad END), 0) AS Salida,
		SUM(ISNULL(CASE WHEN TM.Abreviatura = 'I' THEN VD.Cantidad ELSE VD.Cantidad * -1 END, 0)) OVER(PARTITION BY E.ID, A.ID, VD.IdProducto ORDER BY V.Fecha, V.Orden) as SaldoCantidad,
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
		LEFT JOIN Maestro.Marca M ON M.ID = P.IdMarca
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
		P.IdEmpresa = @IdEmpresa AND
		(@IdEstablecimiento = 0 OR E.ID = @IdEstablecimiento) AND
		(@IdAlmacen = 0 OR A.ID = @IdAlmacen) AND
		(
		(@IdTipoFormato = 1 AND (@IdProducto = 0 OR P.ID = @IdProducto)) OR
		(@IdTipoFormato = 2 AND T.ID IN (SELECT Data FROM [ERP].[Fn_SplitContenido](@IdsFamilia, ',')))
		) AND
		CAST(V.Fecha AS DATE) <= CAST(@FechaHasta AS DATE)) TEMP
	)

	SELECT
		T1.RowNumber,
		T2.PrecioUnitarioInicial,
		T2.SaldoInicialC,
		T2.IngresoC,
		T2.SalidaC,
		T2.IngresoM,
		T2.SalidaM,
		CASE WHEN RowNumber = T2.RowNumberMax THEN T1.SaldoMonto ELSE 0 END SaldoFinalM,
		CASE WHEN RowNumber = T2.RowNumberMax THEN T1.PrecioPromedio ELSE 0 END PrecioPromedioCM,
		T1.IdEstablecimiento,
		T1.NombreEstablecimiento,
		T1.DireccionEstablecimiento,
		T1.IdAlmacen,
		T1.NombreAlmacen,
		T1.IdProducto,
		T1.NombreProducto,
		T1.CodigoReferenciaProducto,
		CONCAT(T1.Abreviatura, ' - ', T1.NumeroVale) AS NumeroVale,
		T1.DocumentoReferencia,
		T1.NombreUnidadMedida,
		CONVERT(varchar(10), T1.FechaMovimiento, 103) AS FechaMovimiento,
		T1.FechaVencimiento,
		T1.NumeroLote,
		T1.NombreEntidad,
		T1.NombreConcepto,
		T1.Ingreso,
		T1.Salida,
		T1.SaldoCantidad,
		T1.PrecioUnitario,
		T1.Total,
		T1.SaldoMonto,
		T1.PrecioPromedio,
		CASE WHEN CAST(T1.FechaMovimiento AS DATE) >= CAST(@FechaDesde AS DATE) THEN 0 ELSE 1 END AS FlagVisible,
		CASE WHEN CAST(T1.FechaMovimiento AS DATE) >= CAST(@FechaDesde AS DATE) THEN 1 ELSE 0 END AS Contar
	FROM Kardex T1
	LEFT JOIN (SELECT
				IdEstablecimiento,
				IdAlmacen,
				IdProducto,	
				MAX(RowNumber) AS RowNumberMax,
				MAX(CASE WHEN FechaMovimiento < CAST(@FechaDesde AS DATE) THEN PrecioUnitario ELSE 0 END) AS PrecioUnitarioInicial,
				SUM(CASE WHEN FechaMovimiento < CAST(@FechaDesde AS DATE) THEN Ingreso ELSE 0 END) -
				SUM(CASE WHEN FechaMovimiento < CAST(@FechaDesde AS DATE) THEN Salida ELSE 0 END) AS SaldoInicialC,
				SUM(CASE WHEN FechaMovimiento >= CAST(@FechaDesde AS DATE) THEN Ingreso ELSE 0 END) AS IngresoC,
				SUM(CASE WHEN FechaMovimiento >= CAST(@FechaDesde AS DATE) THEN Salida ELSE 0 END) AS SalidaC,
				SUM(CASE WHEN FechaMovimiento >= CAST(@FechaDesde AS DATE) THEN CASE WHEN Abreviatura = 'I' THEN Total ELSE 0 END ELSE 0 END) AS IngresoM,
				SUM(CASE WHEN FechaMovimiento >= CAST(@FechaDesde AS DATE) THEN CASE WHEN Abreviatura = 'S' THEN Total ELSE 0 END ELSE 0 END) AS SalidaM
				FROM Kardex
				GROUP BY IdEstablecimiento, IdAlmacen, IdProducto) T2 ON
				T1.IdEstablecimiento = T2.IdEstablecimiento AND
				T1.IdAlmacen = T2.IdAlmacen AND
				T1.IdProducto = T2.IdProducto
	/*WHERE
	CAST(T1.FechaMovimiento AS DATE) >= CAST(@FechaDesde AS DATE)*/
END