CREATE PROCEDURE [ERP].[Usp_Sel_Inventario_Formato]
@IdEmpresa INT,
@IdEstablecimiento INT,
@IdAlmacen INT,
@IdMoneda INT,
@FechaHasta DATETIME
AS
BEGIN

	SELECT
		E.ID AS IdEstablecimiento,
		E.Nombre AS NombreEstablecimiento,
		E.Direccion AS DireccionEstablecimiento
	FROM ERP.ValeDetalle VD
	INNER JOIN ERP.Vale V ON VD.IdVale = V.ID
	INNER JOIN Maestro.ValeEstado VE ON V.IdValeEstado = VE.ID
	INNER JOIn ERP.Producto P ON VD.IdProducto = P.ID
	INNER JOIN ERP.Almacen A ON V.IdAlmacen = A.ID
	INNER JOIN ERP.Establecimiento E ON A.IdEstablecimiento = E.ID
	INNER JOIN Maestro.Moneda M ON V.IdMoneda = M.ID
	WHERE
	VE.Abreviatura NOT IN ('A') AND
	ISNULL(V.FlagBorrador, 0) = 0 AND
	V.Flag = 1 AND
	----------
	V.IdEmpresa = @IdEmpresa AND
	P.IdEmpresa = @IdEmpresa AND
	(@IdEstablecimiento = 0 OR E.ID = @IdEstablecimiento) AND
	(@IdAlmacen = 0 OR A.ID = @IdAlmacen) AND
	CAST(V.Fecha AS DATE) <= CAST(@FechaHasta AS DATE)
	GROUP BY 
	E.ID,
	E.Nombre,
	E.Direccion

END
