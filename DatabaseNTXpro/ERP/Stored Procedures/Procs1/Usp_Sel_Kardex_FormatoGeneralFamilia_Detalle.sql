
CREATE PROCEDURE [ERP].[Usp_Sel_Kardex_FormatoGeneralFamilia_Detalle]
@IdEmpresa INT,
@IdEstablecimiento INT,
@IdAlmacen INT,
@IdMoneda INT,
@FechaDesde DATETIME,
@FechaHasta DATETIME,
@IdProducto INT,
@IdProyecto INT
AS
BEGIN
	
	SELECT
		TEMP.IdValeDetalle,
		TEMP.IdProducto,
		TEMP.NombreProducto,
		TEMP.Abreviatura,
		TEMP.NumeroVale,
		TEMP.DocumentoReferencia,
		TEMP.DocumentoTransferencia,
		TEMP.FechaMovimiento,
		TEMP.IdEstablecimiento,
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
		iif(TEMP.SaldoCantidad=0, TEMP.PrecioUnitario, TEMP.SaldoMonto/TEMP.SaldoCantidad) as PrecioPromedio
	FROM   
	(SELECT 
		VD.ID AS IdValeDetalle,
		P.ID AS IdProducto,
		P.Nombre AS NombreProducto,
		TM.ID AS IdTipoMovimiento,
		TM.Abreviatura,
		V.Documento AS NumeroVale,
		CONCAT(VR.Serie, ' ' ,VR.Documento) AS DocumentoReferencia,
		CASE WHEN TM.Abreviatura = 'I' THEN
		 (SELECT TOP 1 vt2.Documento FROM ERP.ValeTransferencia vt2 INNER JOIN  ERP.Vale v2 ON vt2.IdValeDestino = v2.ID WHERE  v2.id = v.id)
         WHEN  TM.Abreviatura = 'S' THEN
         (SELECT TOP 1 vt2.Documento FROM ERP.ValeTransferencia vt2 INNER JOIN  ERP.Vale v2 ON vt2.IdValeOrigen = v2.ID WHERE  v2.id = v.id)
		 END
		 AS DocumentoTransferencia,
		V.Fecha AS FechaMovimiento,
		V.Orden,
		E.ID AS IdEstablecimiento,
		A.ID AS IdAlmacen,
		A.Nombre AS NombreAlmacen,
		EN.Nombre AS NombreEntidad,
		TOPE.Nombre AS NombreConcepto,
		VD.Fecha AS FechaVencimiento,
		VD.NumeroLote,
		VD.Cantidad,
		--CASE WHEN V.IdMoneda = 2 THEN VD.PrecioUnitario * V.TipoCambio ELSE VD.PrecioUnitario END AS PrecioUnitario,
		--VD.PrecioUnitario,
		--CASE WHEN TOPE.FlagCostear = 1 THEN VD.PrecioPromedio ELSE VD.PrecioPromedio END AS PrecioUnitario,
		CASE WHEN TOPE.FlagCostear = 1 THEN VD.PrecioPromedio ELSE VD.PrecioUnitario END AS PrecioUnitario,
		--SUM(CASE WHEN TM.Abreviatura = 'I' THEN VD.Cantidad * VD.PrecioPromedio ELSE (VD.Cantidad * VD.PrecioPromedio) * -1 END) 
		SUM(CASE WHEN TM.Abreviatura = 'I' THEN VD.Cantidad * VD.PrecioPromedio ELSE (VD.Cantidad * VD.PrecioUnitario) * -1 END) 
		OVER(PARTITION BY VD.IdProducto ORDER BY V.Fecha, V.Orden) AS SaldoMonto,
		ISNULL((CASE WHEN TM.Abreviatura = 'I' THEN VD.Cantidad END), 0) AS Ingreso,
		ISNULL((CASE WHEN TM.Abreviatura = 'S' THEN VD.Cantidad END), 0) AS Salida,
		SUM(ISNULL(CASE WHEN TM.Abreviatura = 'I' THEN VD.Cantidad ELSE VD.Cantidad * -1 END, 0)) OVER(PARTITION BY VD.IdProducto ORDER BY V.Fecha, V.Orden) as SaldoCantidad,
		vd.PrecioPromedio
	FROM ERP.ValeDetalle VD
	INNER JOIN ERP.Vale V ON VD.IdVale = V.ID
	INNER JOIN Maestro.ValeEstado VE ON V.IdValeEstado = VE.ID
	INNER JOIN PLE.T12TipoOperacion TOPE ON V.IdConcepto = TOPE.ID
	INNER JOIN Maestro.TipoMovimiento TM ON V.IdTipoMovimiento = TM.ID
	INNER JOIN ERP.Producto P ON VD.IdProducto = P.ID
	INNER JOIN ERP.Almacen A ON V.IdAlmacen = A.ID
	INNER JOIN ERP.Establecimiento E ON A.IdEstablecimiento = E.ID
	--LEFT JOIN ERP.TipoCambioDiario TCD ON CAST(V.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
	LEFT JOIN ERP.Entidad EN ON V.IdEntidad = EN.ID
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
	(@IdProyecto = 0 OR V.IdProyecto = @IdProyecto) AND
	A.ID = @IdAlmacen AND
	CAST(V.Fecha AS DATE) <= CAST(@FechaHasta AS DATE) AND P.ID = @IdProducto) TEMP
	WHERE TEMP.FechaMovimiento >= CAST(@FechaDesde AS DATE)


END