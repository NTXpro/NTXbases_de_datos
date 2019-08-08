-- =============================================
-- Author:		Omar Rodriguez
-- Create date: 03/08/2018
-- Description:	Funcion que retorna el precio promedio del producto
-- =============================================
CREATE FUNCTION [ERP].[ObtenerPrecioPromedioKardex_FormatoGeneralFamilia_Detalle]
(@IDvaleDetalle AS     INT, 
 @IdEmpresa AS  INT, 
 @IdAlmacen AS  INT, 
 @FechaVale AS  DATETIME, 
 @FechaDesde AS DATETIME, 
 @IdProducto AS INT, 
 @IdProyecto AS INT,
 @IdMoneda  AS INT,
 @IDvale  AS INT
)
RETURNS DECIMAL(14, 5)
AS
     BEGIN

         -------------------------------------------------------
         --VARIABLES DE TRABAJO
         -------------------------------------------------------
			DECLARE @CANT_FLAG_COST INT= 0;
			DECLARE @CANT_FLAG_COST_X INT=0;
			DECLARE @ROW_FlagCostear INT;
			DECLARE @ROW_IdMoneda INT;
			DECLARE @ROW_IdVale INT;
			DECLARE @ROW_IdTipoMovimiento  INT;
			DECLARE @ROW_fecha DATE;
			DECLARE @ROW_TipoCambio DECIMAL(14, 5);
			DECLARE @ROW_PorcentajeIGV DECIMAL(14, 5);
			DECLARE @ROW_Total DECIMAL(14, 5);
			DECLARE @ROW_SubTotal DECIMAL(14, 5);
			DECLARE @ROW_Cantidad DECIMAL(14, 5);
			DECLARE @ROW_PrecioUnitario DECIMAL(14, 5); 
			--Subtotales
			DECLARE @RANGO_CANTIDAD DECIMAL(14, 5);
			DECLARE @RANGO_TOTAL DECIMAL(14, 5);

			 -- Declare the return variable here
			 DECLARE @PRECIO_PROMEDIO DECIMAL(18, 5)= 0;

        
-- llenar las variables de trabajo
SELECT TOP 1 @ROW_Cantidad=vd.Cantidad, 
             @ROW_PrecioUnitario = vd.PrecioUnitario, 
             @ROW_PorcentajeIGV = v.PorcentajeIGV, 
             @ROW_Total = vd.Total, 
             @ROW_SubTotal = vd.SubTotal, 
             @ROW_fecha = v.Fecha, 
             @ROW_FlagCostear = toper.FlagCostear, 
             @ROW_IdMoneda = v.IdMoneda, 
             @ROW_TipoCambio = v.TipoCambio,
			 @ROW_IdTipoMovimiento = v.IdTipoMovimiento
FROM ERP.ValeDetalle vd
     INNER JOIN ERP.Vale v ON vd.IdVale = v.ID
     LEFT JOIN ple.T12TipoOperacion toper ON v.IdConcepto = toper.Id
WHERE vD.IdProducto = @IdProducto
      AND v.IdEmpresa = @IdEmpresa
      AND v.IdAlmacen = @IdAlmacen
      AND v.FlagBorrador = 0
      AND v.flag = 1
      AND v.IdValeEstado = 1
      AND vd.ID = @IDvaleDetalle;


-----------------------------------------------------------------------------------------------------------------------------
-- INICIO LOGICA PARA VALIDAR SI EL USUARIO HIZO OPERACIONES DESFASADAS PRIMERO SALIDAS LUEGO ENTRADAS
-----------------------------------------------------------------------------------------------------------------------------
			DECLARE @MENOR_POR_ID int =0 
			DECLARE @MENOR_POR_FECHA int =0 
			DECLARE @IDdesfase int =0

			SET @CANT_FLAG_COST_X =(SELECT count( v.ID)
                FROM ERP.ValeDetalle vd
                     INNER JOIN ERP.Vale v ON vd.IdVale = v.ID
                     LEFT JOIN ple.T12TipoOperacion toper ON v.IdConcepto = toper.Id
                WHERE vD.IdProducto = @IdProducto
				      AND vd.ID <>  @IDvaleDetalle 
					  AND v.ID <  @IDvale
                      AND v.IdEmpresa = @IdEmpresa
                      AND v.IdAlmacen = @IdAlmacen
					  AND v.FlagBorrador=0 
					  AND v.flag=1
					  AND v.IdValeEstado=1
                      AND v.Fecha >= CAST(@FechaDesde AS DATE)
                      AND v.Fecha <= CAST(@ROW_fecha AS DATE))

			SELECT TOP 1 @MENOR_POR_ID= vd.ID 
							FROM ERP.ValeDetalle vd
								 INNER JOIN ERP.Vale v ON vd.IdVale = v.ID
								 LEFT JOIN ple.T12TipoOperacion toper ON v.IdConcepto = toper.Id
							 WHERE vD.IdProducto = @IdProducto
								  AND v.ID <>  @IDvale
								   AND v.Id < @IDvale
								  AND v.IdEmpresa = @IdEmpresa
								  AND v.IdAlmacen = @IdAlmacen
								  AND v.FlagBorrador=0 
								  AND v.flag=1
								  AND v.IdValeEstado=1
								  AND v.Fecha >= CAST(@FechaDesde AS DATE)
								  AND v.Fecha <= CAST(@ROW_fecha AS DATE)

			SELECT TOP 1 @MENOR_POR_FECHA= count(*) 
							FROM ERP.ValeDetalle vd
								 INNER JOIN ERP.Vale v ON vd.IdVale = v.ID
								 LEFT JOIN ple.T12TipoOperacion toper ON v.IdConcepto = toper.Id
							WHERE vD.IdProducto = @IdProducto
								  AND v.ID <>  @IDvale
								  AND v.IdEmpresa = @IdEmpresa
								  AND v.IdAlmacen = @IdAlmacen
								  AND v.FlagBorrador=0 
								  AND v.flag=1
								  AND v.IdValeEstado=1
								  AND v.Fecha >= CAST(@FechaDesde AS DATE)
								  AND v.Fecha <= CAST(@ROW_fecha AS DATE)

			--IF (@MENOR_POR_ID=0 AND @MENOR_POR_FECHA >0 and @ROW_IdTipoMovimiento >1)
			--BEGIN 
			SELECT @IDdesfase= vd.IdVale
							FROM ERP.ValeDetalle vd
								 INNER JOIN ERP.Vale v ON vd.IdVale = v.ID
								 LEFT JOIN ple.T12TipoOperacion toper ON v.IdConcepto = toper.Id
							WHERE vD.IdProducto = @IdProducto
								  AND v.ID <>  @IDvale
								  AND v.IdEmpresa = @IdEmpresa
								  AND v.IdAlmacen = @IdAlmacen
								  AND v.FlagBorrador=0 
								  AND v.flag=1
								  AND v.IdValeEstado=1
								  AND v.Fecha >= CAST(@FechaDesde AS DATE)
								  AND v.Fecha <= CAST(@ROW_fecha AS DATE)
			--END



-----------------------------------------------------------------------------------------------------------------------------
-- FIN  LOGICA PARA VALIDAR
-----------------------------------------------------------------------------------------------------------------------------

IF (@MENOR_POR_ID=0 AND @MENOR_POR_FECHA> 0 AND @IDdesfase <> 0 AND @IDdesfase>@IDvale AND @ROW_IdTipoMovimiento >1)
BEGIN
SELECT @RANGO_CANTIDAD =SUM( vd.Cantidad), 
										@RANGO_TOTAL =SUM (CASE 
								WHEN @IdMoneda = 1 AND @ROW_IdMoneda = 1 THEN   vd.SubTotal
								WHEN @IdMoneda = 1 AND @ROW_IdMoneda <> 1 THEN   (vd.SubTotal)
								WHEN @IdMoneda <> 1 AND @ROW_IdMoneda = 1 THEN   (vd.SubTotal*  v.TipoCambio)
								WHEN @IdMoneda <> 1 AND @ROW_IdMoneda <> 1 THEN   (vd.SubTotal*  v.TipoCambio)
								END)
								FROM ERP.ValeDetalle vd
										INNER JOIN ERP.Vale v ON vd.IdVale = v.ID
										LEFT JOIN ple.T12TipoOperacion toper ON v.IdConcepto = toper.Id
								WHERE vD.IdProducto = @IdProducto
										AND v.ID=@IDdesfase					 	
							 -- sumar los del row
							 SELECT @PRECIO_PROMEDIO= @RANGO_TOTAL/@RANGO_CANTIDAD

END
ELSE
BEGIN
				-- llenar la variable verifica si existen costeos en el rango de
				-- fecha de la consulta
				 SET @CANT_FLAG_COST =(SELECT count( v.ID)
                FROM ERP.ValeDetalle vd
                     INNER JOIN ERP.Vale v ON vd.IdVale = v.ID
                     LEFT JOIN ple.T12TipoOperacion toper ON v.IdConcepto = toper.Id
                WHERE vD.IdProducto = @IdProducto
				      AND vd.ID <>  @IDvaleDetalle 
					  AND v.ID <  @IDvale
                      AND v.IdEmpresa = @IdEmpresa
                      AND v.IdAlmacen = @IdAlmacen
					  AND v.FlagBorrador=0 
					  AND v.flag=1
					  AND v.IdValeEstado=1
                      AND v.Fecha >= CAST(@FechaDesde AS DATE)
                      AND v.Fecha <= CAST(@ROW_fecha AS DATE))
					  
				-- Si no hay costeos en el rango
				IF (@CANT_FLAG_COST = 0)
				BEGIN
					  --si el row es costeo (solo hay un costeo y es el mismo)
					  IF @ROW_FlagCostear = 1 
					  BEGIN
							SELECT @PRECIO_PROMEDIO= CASE 
								   WHEN @IdMoneda = 1 AND @ROW_IdMoneda = 1 THEN   @ROW_SubTotal/ @ROW_Cantidad
								   WHEN @IdMoneda = 1 AND @ROW_IdMoneda <> 1 THEN   (@ROW_SubTotal)/ @ROW_Cantidad
								   WHEN @IdMoneda <> 1 AND @ROW_IdMoneda = 1 THEN   (@ROW_SubTotal*  @ROW_TipoCambio)/ @ROW_Cantidad
								   WHEN @IdMoneda <> 1 AND @ROW_IdMoneda <> 1 THEN   (@ROW_SubTotal*  @ROW_TipoCambio)/ @ROW_Cantidad
								   END
			
					  END
	
				 END
				 ELSE -- hay costeos en el rango del reporte
				 BEGIN
						  --si el row es costeo
						IF @ROW_FlagCostear = 1 
						BEGIN
							--calculamos los totales de los anteriores registros que costean y lo sumamos al actual y calculamos
															SELECT @RANGO_CANTIDAD =SUM( vd.Cantidad), 
											@RANGO_TOTAL =SUM (CASE 
									WHEN @IdMoneda = 1 AND @ROW_IdMoneda = 1 THEN   vd.subTotal
									WHEN @IdMoneda = 1 AND @ROW_IdMoneda <> 1 THEN   (vd.subTotal)
									WHEN @IdMoneda <> 1 AND @ROW_IdMoneda = 1 THEN   (vd.subTotal*  v.TipoCambio)
									WHEN @IdMoneda <> 1 AND @ROW_IdMoneda <> 1 THEN   (vd.subTotal*  v.TipoCambio)
									END)
									FROM ERP.ValeDetalle vd
											INNER JOIN ERP.Vale v ON vd.IdVale = v.ID
											LEFT JOIN ple.T12TipoOperacion toper ON v.IdConcepto = toper.Id
									WHERE vD.IdProducto = @IdProducto
											AND v.IdEmpresa = @IdEmpresa
											AND v.IdAlmacen = @IdAlmacen
											AND v.FlagBorrador = 0
											AND v.flag = 1
											AND v.IdValeEstado = 1
											AND vd.fecha <= @ROW_fecha
										--	AND vd.Id <> @IDvaleDetalle;
								 -- sumar los del row
								 SELECT @PRECIO_PROMEDIO= @RANGO_TOTAL/@RANGO_CANTIDAD
			
						END
						IF @ROW_FlagCostear = 0 
						BEGIN
							--calculamos los totales de los anteriores registros que costean y lo sumamos al actual y calculamos
									SELECT @RANGO_CANTIDAD =SUM( vd.Cantidad), 
										@RANGO_TOTAL =SUM (CASE 
								WHEN @IdMoneda = 1 AND @ROW_IdMoneda = 1 THEN   vd.SubTotal
								WHEN @IdMoneda = 1 AND @ROW_IdMoneda <> 1 THEN   (vd.SubTotal)
								WHEN @IdMoneda <> 1 AND @ROW_IdMoneda = 1 THEN   (vd.SubTotal*  v.TipoCambio)
								WHEN @IdMoneda <> 1 AND @ROW_IdMoneda <> 1 THEN   (vd.SubTotal*  v.TipoCambio)
								END)
								FROM ERP.ValeDetalle vd
										INNER JOIN ERP.Vale v ON vd.IdVale = v.ID
										LEFT JOIN ple.T12TipoOperacion toper ON v.IdConcepto = toper.Id
								WHERE vD.IdProducto = @IdProducto
										AND v.IdEmpresa = @IdEmpresa
										AND v.IdAlmacen = @IdAlmacen
										AND v.FlagBorrador = 0
										AND v.flag = 1
										AND v.IdValeEstado = 1
										AND vd.fecha <= @ROW_fecha
									--	AND vd.Id <> @IDvaleDetalle;
							 -- sumar los del row
							 SELECT @PRECIO_PROMEDIO= @RANGO_TOTAL/@RANGO_CANTIDAD
			
						END		 
				END
END
         -- Return the result of the function
         RETURN  @PRECIO_PROMEDIO;
     END;