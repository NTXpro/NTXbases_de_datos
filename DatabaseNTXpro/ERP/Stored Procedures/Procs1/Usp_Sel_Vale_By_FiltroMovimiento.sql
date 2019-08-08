
CREATE PROC [ERP].[Usp_Sel_Vale_By_FiltroMovimiento]
@IdEmpresa INT,
@IdMoneda INT,
@IdAlmacen INT,
@IdTipoMovimiento INT,
@IdConcepto INT,
@IdEntidad INT,
@IdProyecto INT,
@IdProducto INT,
@FechaDesde DATETIME,
@FechaHasta DATETIME
AS
BEGIN
	SELECT	V.ID,
			A.Nombre NombreAlmacen,
			V.Fecha,
			V.IdTipoMovimiento,
			TM.Nombre NombreTipoMovimiento,
			V.Documento,
			E.Nombre NombreEntidad,
			P.Nombre NombreProyecto,
			UPPER(M.Nombre) NombreMoneda,
			TTO.Nombre NombreConcepto,
			V.TipoCambio,
			CASE WHEN M.ID = @IdMoneda THEN
				V.Total 
			WHEN M.ID = 1 AND @IdMoneda = 2 THEN
				(V.Total / V.TipoCambio)
			WHEN M.ID = 2 AND @IdMoneda = 1 THEN
				(V.Total * V.TipoCambio)
			END Total
	FROM ERP.Vale V 
	INNER JOIN (SELECT DISTINCT IdVale FROM ERP.ValeDetalle VDD WHERE @IdProducto = 0 OR VDD.IdProducto = @IdProducto) VD ON VD.IdVale = V.ID 
	LEFT JOIN ERP.Almacen A ON V.IdAlmacen = A.ID AND V.IdEmpresa = @IdEmpresa
	LEFT JOIN Maestro.TipoMovimiento TM ON TM.ID = V.IdTipoMovimiento
	LEFT JOIN ERP.Entidad E ON E.ID = V.IdEntidad
	LEFT JOIN ERP.Proyecto P ON P.ID = V.IdProyecto
	LEFT JOIN Maestro.Moneda M ON M.ID = V.IdMoneda
	LEFT JOIN PLE.T12TipoOperacion TTO ON TTO.ID = V.IdConcepto
	WHERE V.FlagBorrador = 0 AND V.IdValeEstado != 2 
	AND (@IdAlmacen = 0 OR V.IdAlmacen = @IdAlmacen)
	AND (@IdTipoMovimiento = 0 OR V.IdTipoMovimiento = @IdTipoMovimiento)
	AND (@IdConcepto = 0 OR V.IdConcepto = @IdConcepto)
	AND (@IdEntidad = 0 OR V.IdEntidad = @IdEntidad)
	AND (@IdProyecto = 0 OR V.IdProyecto = @IdProyecto)
	AND CAST(FECHA AS DATE) >= CAST(@FechaDesde AS DATE) 
	AND CAST(FECHA AS DATE) <= CAST(@FechaHasta AS DATE)
END
