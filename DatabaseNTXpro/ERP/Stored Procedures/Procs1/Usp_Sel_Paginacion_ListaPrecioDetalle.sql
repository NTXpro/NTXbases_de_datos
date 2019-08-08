
CREATE PROCEDURE [ERP].[Usp_Sel_Paginacion_ListaPrecioDetalle]
@IdListaPrecio INT,
@Nombre VARCHAR(250),
---------------------------------
@RowsPerPage		INT,		  -- CANTIDAD A MOSTRAR PORPAGINA
@Page				INT,	      -- NUMERO DE PAGINA
@SortColumn			VARCHAR(100), -- COLUMNA
@SortDirection		VARCHAR(100) -- ORDENAMIENTO
AS
BEGIN
WITH TEMP AS (
SELECT		LPD.ID,
			IdListaPrecio,
			LPD.IdProducto,
			P.Nombre,
			PrecioUnitario,
			PorcentajeDescuento,
			(SELECT [ERP].[ObtenerValorParametroByAbreviaturaFecha](P.IdEmpresa, 'VPU2', getdate())) AS FlagPrecioUnitario2Decimal
	FROM ERP.ListaPrecioDetalle LPD INNER JOIN ERP.Producto P
		ON P.ID = LPD.IdProducto
	WHERE IdListaPrecio = @IdListaPrecio AND P.Flag = 1 AND P.FlagBorrador = 0 AND (@Nombre = '' OR  (@Nombre != '' AND P.Nombre LIKE '%'+ @Nombre + '%'))
),COUNT_TEMP AS (
SELECT COUNT(ID) AS [TotalRow]
FROM TEMP
)
,RESULT_TEMP AS (
SELECT ROW_NUMBER() OVER (ORDER BY     
CASE WHEN (@SortColumn ='Nombre' AND @SortDirection = 'ASC' ) THEN Nombre END ASC, 
CASE WHEN (@SortColumn ='PrecioUnitario' AND @SortDirection = 'ASC' ) THEN PrecioUnitario END ASC, 
CASE WHEN (@SortColumn ='PorcentajeDescuento' AND @SortDirection = 'ASC' ) THEN PorcentajeDescuento END ASC, 

CASE WHEN (@SortColumn ='Nombre' AND @SortDirection = 'DESC' ) THEN Nombre END DESC, 
CASE WHEN (@SortColumn ='PrecioUnitario' AND @SortDirection = 'DESC' ) THEN PrecioUnitario END DESC, 
CASE WHEN (@SortColumn ='PorcentajeDescuento' AND @SortDirection = 'DESC' ) THEN PorcentajeDescuento END DESC,

CASE WHEN @SortColumn = '' THEN ID END DESC
  )  AS  ROW_NUM, 
	ID,
	Nombre,
	PrecioUnitario,
	PorcentajeDescuento,
	FlagPrecioUnitario2Decimal
  FROM TEMP
)

SELECT CAST(ROW_NUM as int) as ROW_NUM,
	ID,
	Nombre,
	PrecioUnitario,
	PorcentajeDescuento,
	FlagPrecioUnitario2Decimal,
	TotalRow
FROM RESULT_TEMP, COUNT_TEMP
WHERE ROW_NUM BETWEEN (@RowsPerPage * (@page - 1) + 1) AND @page * @RowsPerPage

END
