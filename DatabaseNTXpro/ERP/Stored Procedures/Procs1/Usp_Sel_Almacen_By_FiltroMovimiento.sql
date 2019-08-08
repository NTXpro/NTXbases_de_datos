
CREATE PROC [ERP].[Usp_Sel_Almacen_By_FiltroMovimiento]
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
	SELECT DISTINCT	A.ID,
					(A.Nombre + ' - ' + EA.Direccion) AS Nombre,
					EA.ID IdEstablecimiento,
					EA.Nombre NombreEstablecimiento,
					EA.Direccion
	FROM ERP.Vale V 
	INNER JOIN (SELECT DISTINCT IdVale FROM ERP.ValeDetalle VDD WHERE @IdProducto = 0 OR VDD.IdProducto = @IdProducto) VD ON VD.IdVale = V.ID
	INNER JOIN ERP.Almacen A ON V.IdAlmacen = A.ID AND V.IdEmpresa = @IdEmpresa
	LEFT JOIN ERP.Establecimiento EA ON EA.ID = A.IdEstablecimiento
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
