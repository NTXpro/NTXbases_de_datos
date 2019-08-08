CREATE PROCEDURE [ERP].[Usp_Sel_Kardex_FormatoReducido] --1,1,1,'01/08/2017','20/08/2017',0
@IdEmpresa INT,
@IdAlmacen INT,
@IdMoneda INT,
@FechaDesde VARCHAR(10),
@FechaHasta VARCHAR(10),
@IdProducto INT,
@IdProyecto INT
AS
BEGIN

	DECLARE @COLUMNAS AS NVARCHAR(MAX);
    DECLARE @QUERY  AS NVARCHAR(MAX);

	SET @COLUMNAS = STUFF((SELECT  ',' + QUOTENAME(CONCAT(TM.Abreviatura, '|', TOPE.Nombre)) 
							FROM PLE.T12TipoOperacion TOPE 
							INNER JOIN Maestro.TipoMovimiento TM ON TOPE.IdTipoMovimiento = TM.ID
							WHERE (TOPE.FlagBorrador = 0 OR TOPE.FlagBorrador IS NULL) AND TOPE.Flag = 1						
							GROUP BY TM.Abreviatura, TOPE.Nombre, TM.ID, TOPE.ID
							ORDER BY TM.ID, TOPE.ID
							FOR XML PATH(''), TYPE
							).value('.', 'NVARCHAR(MAX)'),1,1,'');
	
	SET @QUERY = 'DECLARE @TABLE TABLE (
					ID INT PRIMARY KEY NOT NULL,
					Nombre VARCHAR(MAX),
					IdPadre VARCHAR(MAX));

					WITH CTE AS (
					SELECT 
						F1.ID, 
						F1.Nombre, 
						CAST(F1.ID AS VARCHAR(MAX)) AS IdPadre, 
						F1.IdFamiliaPadre
					FROM ERP.Familia F1 
					WHERE F1.IdFamiliaPadre IS NULL
					UNION ALL
					SELECT 
						F2.ID, 
						F2.Nombre, 
						CTE.IdPadre, 
						F2.IdFamiliaPadre
					FROM ERP.Familia F2
					INNER JOIN CTE ON F2.IdFamiliaPadre = CTE.ID
					)
					INSERT INTO @TABLE (ID, Nombre, IdPadre)
					SELECT 
						ID, 
						Nombre,
						IdPadre
					FROM CTE;
	
					SELECT ID, Nombre, ' + @COLUMNAS + ' FROM
					(SELECT
						F.ID,
						F.Nombre,
						CONCAT(TM.Abreviatura, ''|'', TOPE.Nombre) AS NombreOperacion, -- (CONCEPTOS PARA APLICACIÓN)
						--SUM(VD.Total) AS Total
						SUM((CASE 
							WHEN V.IdMoneda = 1 THEN
								CASE 
									WHEN ' + CAST(@IdMoneda AS VARCHAR(10)) + ' = 1 THEN VD.PrecioUnitario
									ELSE VD.PrecioUnitario / TCD.VentaSunat
								END
							ELSE 
								CASE 
									WHEN ' + CAST(@IdMoneda AS VARCHAR(10)) + ' = 1 THEN VD.PrecioUnitario * TCD.VentaSunat
									ELSE VD.PrecioUnitario
								END
						END) * VD.Cantidad) AS Total
					FROM ERP.ValeDetalle VD
					INNER JOIN ERP.Vale V ON VD.IdVale = V.ID
					-----------------------------------------
					INNER JOIN Maestro.ValeEstado VE ON V.IdValeEstado = VE.ID
					INNER JOIN ERP.Producto P ON VD.IdProducto = P.ID
					INNER JOIN ERP.FamiliaProducto FP ON P.ID = FP.IdProducto
					INNER JOIN @TABLE TF ON FP.IdFamilia = TF.ID
					INNER JOIN ERP.Familia F ON	TF.IdPadre = F.ID	
					INNER JOIN ERP.Almacen A ON V.IdAlmacen = A.ID
					INNER JOIN ERP.TipoCambioDiario TCD ON CAST(V.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
					----------------------------------------------
					INNER JOIN PLE.T12TipoOperacion TOPE ON V.IdConcepto = TOPE.ID
					INNER JOIN Maestro.TipoMovimiento TM ON V.IdTipoMovimiento = TM.ID
					WHERE
					VE.Abreviatura NOT IN (''A'') AND
					ISNULL(V.FlagBorrador, 0) = 0 AND
					V.Flag = 1 AND
					V.IdEmpresa = ' + CAST(@IdEmpresa AS VARCHAR(10)) + ' AND
					P.IdEmpresa = ' + CAST(@IdEmpresa AS VARCHAR(10)) + ' AND
					(' + CAST(@IdAlmacen AS VARCHAR(10)) + ' = 0 OR A.ID = ' + CAST(@IdAlmacen AS VARCHAR(10)) + ') AND
					(' + CAST(@IdProyecto AS VARCHAR(10)) + ' = 0 OR V.IdProyecto = ' + CAST(@IdProyecto AS VARCHAR(10)) + ') AND
					CAST(V.Fecha AS DATE) BETWEEN CONVERT(DATE, ''' + @FechaDesde + ''', 103) AND CONVERT(DATE, ''' + @FechaHasta + ''', 103) AND
					(' + CAST(@IdProducto AS VARCHAR(10)) + ' = 0 OR P.ID = ' + CAST(@IdProducto AS VARCHAR(10)) + ')
					GROUP BY
					F.ID, F.Nombre, CONCAT(TM.Abreviatura, ''|'', TOPE.Nombre)) TEMP
					PIVOT
					(
						SUM(TEMP.Total)
						FOR TEMP.NombreOperacion IN (' + @COLUMNAS + ')
					) AS P ORDER BY ID, Nombre';

	EXECUTE(@QUERY);
END