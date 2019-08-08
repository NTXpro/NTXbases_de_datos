CREATE PROCEDURE ERP.Usp_Sel_Producto_Stock
@IdEmpresa INT,
@IdAlmacen INT,
@CodigoNombre VARCHAR(250)
AS
	DECLARE @MostrarStockCero INT
	SELECT @MostrarStockCero = CAST(Valor AS INT)
	FROM ERP.Parametro 
	WHERE Abreviatura = 'SCPC'

	SELECT P.ID IdProducto,
			P.CodigoReferencia,
			P.Nombre NombreProducto,
			UM.Nombre NombreUnidadMedida,
			M.Nombre NombreMarca,
			CASE 
				WHEN P.IdTipoProducto = 2 THEN 1
				ELSE ISNULL(PRO_STOCK.Stock, 0)
			END Stock
	FROM ERP.Producto P
	LEFT JOIN ERP.FN_StockProducto_Empresa(@IdEmpresa, @IdAlmacen) PRO_STOCK ON P.ID = PRO_STOCK.IdProducto	
	LEFT JOIN [PLE].[T6UnidadMedida] UM ON UM.ID = P.IdUnidadMedida
	LEFT JOIN Maestro.Marca M ON M.ID = P.IdMarca
	WHERE P.FlagBorrador = 0
	AND P.Flag = 1 
	AND P.IdEmpresa = @IdEmpresa
	AND (@MostrarStockCero = 1 OR (@MostrarStockCero = 0 AND CASE 
																WHEN P.IdTipoProducto = 2 THEN 1
																ELSE ISNULL(PRO_STOCK.Stock, 0)
															END > 0))
	AND (@CodigoNombre IS NULL OR
		 @CodigoNombre = '' OR
		 (P.Nombre LIKE '%' + @CodigoNombre + '%' OR P.CodigoReferencia LIKE '%' + @CodigoNombre + '%'))