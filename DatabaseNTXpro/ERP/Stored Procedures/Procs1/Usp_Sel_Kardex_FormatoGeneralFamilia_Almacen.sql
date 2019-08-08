CREATE PROCEDURE [ERP].[Usp_Sel_Kardex_FormatoGeneralFamilia_Almacen] --1,1,2,1, '2016-01-01 18:21:00.093', '2017-12-31 18:21:00.093' , 0, '0,1,2,3'
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

	SELECT 
		ROW_NUMBER() OVER (ORDER BY A.ID) AS RowNumber,
		A.IdEstablecimiento,
		A.ID AS IdAlmacen,
		A.Nombre AS NombreAlmacen
	FROM ERP.ValeDetalle VD
	INNER JOIN ERP.Vale V ON VD.IdVale = V.ID
	INNER JOIN Maestro.ValeEstado VE ON V.IdValeEstado = VE.ID
	INNER JOIn ERP.Producto P ON VD.IdProducto = P.ID
	INNER JOIN ERP.Almacen A ON V.IdAlmacen = A.ID
	INNER JOIN ERP.Establecimiento E ON A.IdEstablecimiento = E.ID
	INNER JOIN Maestro.Moneda M ON V.IdMoneda = M.ID
	LEFT JOIN ERP.FamiliaProducto FP ON P.ID = FP.IdProducto
	LEFT JOIN @TABLE T ON FP.IdFamilia = T.ID		
	WHERE
	VE.Abreviatura NOT IN ('A') AND
	ISNULL(V.FlagBorrador, 0) = 0 AND
	V.Flag = 1 AND
	--------------
	V.IdEmpresa = @IdEmpresa AND
	P.IdEmpresa = @IdEmpresa AND
	E.ID = @IdEstablecimiento AND
	(@IdAlmacen = 0 OR A.ID = @IdAlmacen) AND
	(@IdProyecto = 0 OR V.IdProyecto = @IdProyecto) AND
	CAST(V.Fecha AS DATE) <= CAST(@FechaHasta AS DATE) AND
	(
	(@IdTipoFormato = 1 AND (@IdProducto = 0 OR P.ID = @IdProducto)) OR
	(@IdTipoFormato = 2 AND T.ID IN (SELECT Data FROM [ERP].[Fn_SplitContenido](@IdsFamilia, ',')))
	)
	GROUP BY 
	A.ID,
	A.Nombre,
	A.IdEstablecimiento
	ORDER BY
	A.Nombre
END