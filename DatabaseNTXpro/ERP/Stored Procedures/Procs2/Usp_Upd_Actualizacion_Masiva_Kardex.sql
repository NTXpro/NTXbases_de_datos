-- =============================================
-- Author:        OMAR RODRIGUEZ
-- Create date: 14/09/2018
-- Description:    PROCESO MASIVO DE CORRECCION KARDEX. PRODUCTO X PRODUCTO
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Upd_Actualizacion_Masiva_Kardex]
@IdEmpresaTAB INT,
@IdMonedaTAB INT,
@IdProductoTAB INT,
@IdProyectoTAB INT
AS
BEGIN

   


        DECLARE @FechaDesdeTAB DATETIME ='1900-01-01 14:54:16'
        DECLARE @FechaHastaTAB DATETIME = GETDATE()
        DECLARE @FilaROWid AS INT;
        DECLARE @FilaIDmaestro AS INT;
        DECLARE @FilaFecha AS DATETIME;
        DECLARE @FilaIdTipoMovimiento AS INT;
        DECLARE @FilaFlagCostear AS INT;
        DECLARE @FilaIDdetalle AS INT;
        DECLARE @FilaIdProducto AS INT;
        DECLARE @FilaNombre AS VARCHAR(250);
        DECLARE @FilaCantidad AS DECIMAL(20, 8);
        DECLARE @FilaSubTotal AS DECIMAL(20, 8);
        DECLARE @FilaPrecioUnitario AS DECIMAL(20, 8);
        DECLARE @FilaIdMoneda AS INT;
        DECLARE @FilaTipoCambio AS DECIMAL(20, 8);
        DECLARE @FilaCalculadoPU AS DECIMAL(20, 8);
        DECLARE @FilaCalculadoPP AS DECIMAL(20, 8);
        DECLARE @FilaAcumuladoCant AS DECIMAL(20, 8);
        DECLARE @FilaAcumuladoSaldo AS DECIMAL(20, 8);
		DECLARE @FilaPrecioMonedaOriginal AS DECIMAL(20, 8);
        DECLARE @FilaIdConcepto AS INT;
        DECLARE @FilaIdAlmacen AS INT;
        DECLARE @FilaIdProyecto AS INT;
        DECLARE @PREVIO_EXISTE INT;
        DECLARE @PREVIO_EXISTE_COSTEABLE INT;
        DECLARE @PRECIO_UNITARIO DECIMAL(20, 8)= 0;
        DECLARE @PREVIO_CANTIDAD DECIMAL(20, 8);
        DECLARE @PREVIO_SUBTOTAL DECIMAL(20, 8);
        DECLARE @PRECIO_PROMEDIO DECIMAL(20, 8);
        DECLARE @ACUMULADO_CANT DECIMAL(20, 8);
        DECLARE @ACUMULADO_SALDO DECIMAL(20, 8);
		DECLARE @PREVIO_SALDO DECIMAL(20, 8);
        DECLARE @DIVISOR DECIMAL(20, 8);
        DECLARE @VALEORIGEN INT;
        DECLARE @ALMACENORIGEN INT;
        DECLARE @IDESTABLECIMIENTOORIGEN INT
        DECLARE @IGV_VALE DECIMAL(20, 8);
        DECLARE @MSG_ERROR NVARCHAR(1024)
        DECLARE @MSG_ERROR_NUM int = 0
        DECLARE @MSG_MONITOR NVARCHAR(500) = (SELECT TOP  1  cast(p.ID AS nvarchar(50))+ ' - ' +  p.Nombre FROM ERP.Producto p WHERE p.ID =@IdProductoTAB) 
		DECLARE @VALOR_IGV decimal(20, 8) =( SELECT cast(p.Valor AS decimal(20, 8))/100 AS valor FROM ERP.Parametro p WHERE p.Abreviatura = 'IGV')
		DECLARE @PRECIO_ORIGINAL  DECIMAL(20, 8);
		DECLARE @SUBTOTAL_MBASE DECIMAL(20, 8);
        DECLARE @TOTAL_MBASE DECIMAL(20, 8);
		DECLARE @IGV_MBASE DECIMAL(20, 8);
		DECLARE @filaTotalMonedaOriginal DECIMAL(20, 8);
		
		DECLARE @filaSubtotalMonedaOriginal DECIMAL(20, 8);
		DECLARE @filaIGVmonedaOriginal DECIMAL(20, 8);
		DECLARE @filaTotalMBase DECIMAL(20, 8);
		DECLARE @filaSubtotalMbase DECIMAL(20, 8);
		DECLARE @filaIGVMbase DECIMAL(20, 8);


		


		DELETE FROM ERP.KardexRecalculo;
        INSERT INTO ERP.KardexRecalculo
               SELECT ROW_NUMBER() OVER(ORDER BY v.Fecha, 
                                                 v.ID) AS RowID, 
                      v.ID, 
                      v.Fecha, 
                      v.IdTipoMovimiento, 
                      topper.FlagCostear, 
                      vd.ID, 
                      vd.IdProducto, 
                      vd.Nombre, 
                       case WHEN v.IdTipoMovimiento = 1  THEN  vd.Cantidad else vd.Cantidad *-1 END AS Cantidad,
                      vd.SubTotal, 
                      vd.PrecioUnitario, 
                      v.IdMoneda, 
                      v.TipoCambio, 
                      1 AS CalculadoPU, 
                      1 AS CalculadoPP, 
                      0 AS AcumuladoCant, 
                      0 AS AcumuladoSaldo, 
                      v.IdConcepto, 
                      v.IdAlmacen, 
                      v.IdProyecto, 
                      '0',
					   v.documento,
					   0,
					   0,
					   0,
					    0,
					   0,
					   0,
					    0,
					   0,
					   0,
					   0
					  
               FROM ERP.Vale v
                    INNER JOIN ERP.ValeDetalle vd ON v.ID = vd.IdVale
                    INNER JOIN ERP.Almacen A ON V.IdAlmacen = A.ID
                    INNER JOIN ERP.Producto P ON VD.IdProducto = P.ID
                    INNER JOIN Maestro.ValeEstado VE ON V.IdValeEstado = VE.ID
                    INNER JOIN ERP.Establecimiento E ON A.IdEstablecimiento = E.ID
                    LEFT JOIN ERP.Entidad EN ON V.IdEntidad = EN.ID
                    INNER JOIN PLE.T12TipoOperacion topper ON v.IdConcepto = topper.ID
               WHERE v.FlagBorrador = 0
                    AND v.flag = 1
                    AND V.IdValeEstado IN(1,3)
                    AND VE.Abreviatura NOT IN('A')
                    AND ISNULL(V.FlagBorrador, 0) = 0
                    AND V.Flag = 1
                    AND V.IdEmpresa = @IdEmpresaTAB
                    AND P.IdEmpresa = @IdEmpresaTAB
                    AND (@IdProyectoTAB = 0
                         OR V.IdProyecto = @IdProyectoTAB)
                    AND CAST(V.Fecha AS DATE) <= CAST(@FechaHastaTAB AS DATE)
                    AND P.ID = @IdProductoTAB
                    AND V.fecha >= CAST(@FechaDesdeTAB AS DATE)
        
		
		
		
		        

        ----------- PRIMERA VUELTA, CALCULO DE ACUMULADOS DE CANTIDADES Y PRECIOS UNITARIOS COSTEABLES
		
		DECLARE @calculoTotalAfecto  decimal(15,5) =0 --n
		DECLARE @AcumuladocalculoTotalAfecto decimal(15,5) =0 --n
		DECLARE @PrecioPromedioAfecto decimal(15,5) =0 --n 
		
        DECLARE ProdInfo1 CURSOR
        FOR SELECT ROWid, IDmaestro, Fecha, IdTipoMovimiento,  FlagCostear,IDdetalle, IdProducto, Nombre, Cantidad, SubTotal, PrecioUnitario, 
                    IdMoneda, TipoCambio, CalculadoPU, CalculadoPP,AcumuladoCant ,AcumuladoSaldo,IdConcepto,IdAlmacen,IdProyecto FROM ERP.KardexRecalculo;
        OPEN ProdInfo1;
        FETCH NEXT FROM ProdInfo1 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
            @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
        WHILE @@fetch_status = 0
        BEGIN
		        DECLARE @AcumAlgebraico decimal (15,5)=0 --n
                SET @ACUMULADO_SALDO = 0
                SET @ACUMULADO_CANT= 0
				SET @AcumAlgebraico = 0
				
				 ----NEO.   CALCULO DE CANTIDADES ----------------------------
				 IF (@FilaROWid = 1)  
				 BEGIN
				    SET @ACUMULADO_CANT  = @FilaCantidad
					 SET @AcumAlgebraico  = 0
				 END
				 ELSE
				 BEGIN
				     SET @ACUMULADO_CANT  =(SELECT TOP 1 kr.AcumuladoCant FROM ERP.KardexRecalculo kr WHERE kr.ROWid < @FilaROWid ORDER BY kr.ROWid desc)+ @FilaCantidad
					 SET @AcumAlgebraico  =(SELECT sum(kr.Cantidad) FROM ERP.KardexRecalculo kr WHERE kr.ROWid < @FilaROWid AND kr.IdAlmacen =@FilaIdAlmacen)+ @FilaCantidad
				 END 
				   UPDATE ERP.KardexRecalculo SET  AcumuladoCant = @AcumAlgebraico WHERE ROWid = @FilaROWid;
			      
				 --NEO.   CALCULO DE PRECIOS UNITARIOS COSTEABLES--------------------- (buscar solo los costeables)
				 IF (@FilaFlagCostear = 1) 
				 BEGIN
				    
					SET @PRECIO_UNITARIO = @FilaPrecioUnitario;
					SET @PRECIO_ORIGINAL = @FilaPrecioUnitario;
					IF (@FilaIdMoneda = 2)
					BEGIN
						SET @PRECIO_UNITARIO = @FilaPrecioUnitario*@FilaTipoCambio
					END 
					
     				  SET @calculoTotalAfecto =@FilaCantidad* @PRECIO_UNITARIO
 					  SET  @AcumuladocalculoTotalAfecto =(SELECT top 1 kr.SubtotalCalculado FROM ERP.KardexRecalculo kr WHERE kr.ROWid < @FilaROWid ORDER BY kr.ROWid desc) +@calculoTotalAfecto
					
					  IF (@FilaROWid = 1)  
					  BEGIN
					   SET @PrecioPromedioAfecto =  @PRECIO_UNITARIO
					  END
					  ELSE
					  BEGIN
						SET @PrecioPromedioAfecto =  @AcumuladocalculoTotalAfecto/@AcumAlgebraico
					  END

					
					 UPDATE ERP.KardexRecalculo SET PrecioUnitario = @PRECIO_UNITARIO, PrecioMonedaOriginal = @PRECIO_ORIGINAL WHERE ROWid = @FilaROWid;
					 UPDATE ERP.KardexRecalculo SET SubtotalCalculado = @calculoTotalAfecto WHERE ROWid = @FilaROWid;
					-- SET @PrecioPromedioAfecto =@AcumuladocalculoTotalAfecto  /@ACUMULADO_CANT
					 UPDATE ERP.KardexRecalculo SET CalculadoPP = @PrecioPromedioAfecto WHERE ROWid = @FilaROWid;
					
				     PRINT 'VUELTA UNO @FilaROWid '+CAST(@FilaROWid AS VARCHAR(200))+'  @PRECIO_UNITARIO: ' + CAST(@PRECIO_UNITARIO AS VARCHAR(200)) +'      @ACUMULADO_CANT: ' + CAST(@ACUMULADO_CANT AS VARCHAR(200))
		             PRINT 'VUELTA UNO----------- '+CAST(@calculoTotalAfecto AS VARCHAR(200))+'  @@FilaCantidad: ' + CAST(@FilaCantidad AS VARCHAR(200)) --+ '  @AcumuladocalculoTotalAfecto '+ CAST(@AcumuladocalculoTotalAfecto AS VARCHAR(200))
			                 +'@PrecioPromedioAfecto' +cast(@PrecioPromedioAfecto AS varchar(299))
							 + ' @AcumAlgebraico  '+ cast(@AcumAlgebraico AS varchar(299)) 
												   
				 END
				
                   
        FETCH NEXT FROM ProdInfo1 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto, @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario,
            @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
        END;
        CLOSE ProdInfo1;
        DEALLOCATE ProdInfo1;


		 ----------- SEGUNDA VUELTA, CALCULO DE PRECIOS UNITARIOS DE ENTRADAS NO COSTEABLES
        DECLARE ProdInfo1 CURSOR
        FOR SELECT ROWid, IDmaestro, Fecha, IdTipoMovimiento,  FlagCostear,IDdetalle, IdProducto, Nombre, Cantidad, SubTotal, PrecioUnitario, 
                    IdMoneda, TipoCambio, CalculadoPU, CalculadoPP,AcumuladoCant ,AcumuladoSaldo,IdConcepto,IdAlmacen,IdProyecto FROM ERP.KardexRecalculo WHERE FlagCostear = 0;
        OPEN ProdInfo1;
        FETCH NEXT FROM ProdInfo1 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
            @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
        WHILE @@fetch_status = 0
        BEGIN

			     SET @PREVIO_EXISTE_COSTEABLE = ISNULL((SELECT TOP 1 v.ROWid FROM ERP.KardexRecalculo v WHERE V.ROWid< @FilaROWid AND V.IdProducto= @FilaIdProducto AND V.FlagCostear= 1 ORDER BY v.ROWid DESC),-1)
				 IF(@PREVIO_EXISTE_COSTEABLE = -1)
				 BEGIN
					SET @PRECIO_UNITARIO = 1;
				 END
				 ELSE
				 BEGIN
				    SET @PRECIO_UNITARIO =(SELECT TOP 1 v.PrecioUnitario FROM ERP.KardexRecalculo v WHERE V.ROWid< @FilaROWid AND V.IdProducto= @FilaIdProducto AND V.FlagCostear= 1 ORDER BY v.ROWid DESC)
					
				 END
				   SET @PRECIO_UNITARIO =(SELECT TOP 1 v.CalculadoPP FROM ERP.KardexRecalculo v WHERE V.ROWid< @FilaROWid AND V.IdProducto= @FilaIdProducto AND V.FlagCostear= 1 ORDER BY v.ROWid DESC)
				 SET @calculoTotalAfecto =@FilaCantidad* @PRECIO_UNITARIO
				 UPDATE ERP.KardexRecalculo SET PrecioUnitario = @PRECIO_UNITARIO WHERE ROWid = @FilaROWid;
  				  PRINT 'VUELTA DOS @FilaROWid '+CAST(@FilaROWid AS VARCHAR(200))+'  @PRECIO_UNITARIO: ' + CAST(@PRECIO_UNITARIO AS VARCHAR(200)) +'      @PREVIO_EXISTE_COSTEABLE: ' + CAST(@PREVIO_EXISTE_COSTEABLE AS VARCHAR(200))
		          UPDATE ERP.KardexRecalculo SET SubtotalCalculado = @calculoTotalAfecto WHERE ROWid = @FilaROWid;
				
        FETCH NEXT FROM ProdInfo1 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto, @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario,
            @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
        END;
        CLOSE ProdInfo1;
        DEALLOCATE ProdInfo1;

		 ----------- TERCERA VUELTA, CALCULO DE PRECIOS UNITARIOS ORIGINALES
        DECLARE ProdInfo1 CURSOR
        FOR SELECT ROWid, IDmaestro, Fecha, IdTipoMovimiento,  FlagCostear,IDdetalle, IdProducto, Nombre, Cantidad, SubTotal, PrecioUnitario, 
                    IdMoneda, TipoCambio, CalculadoPU, CalculadoPP,AcumuladoCant ,AcumuladoSaldo,IdConcepto,IdAlmacen,IdProyecto FROM ERP.KardexRecalculo 
        OPEN ProdInfo1;
        FETCH NEXT FROM ProdInfo1 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
            @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
        WHILE @@fetch_status = 0
        BEGIN


			    --- DEFINIR VALOR PRECIOMONEDAORIGINAL
				 IF (@FilaIdMoneda = 2)
				 BEGIN
				    SET @PRECIO_ORIGINAL =@FilaPrecioUnitario /@FilaTipoCambio
				 END
				 ELSE
				 BEGIN
				    SET @PRECIO_ORIGINAL =@FilaPrecioUnitario
				 END
				 --PRINT 'rowid -' + cast(@FilaROWid AS varchar(10)) + ' PRE -' + cast(@FilaPrecioUnitario AS varchar(10)) + ' Tasa  -' + cast(@FilaTipoCambio AS varchar(10))
				 UPDATE ERP.KardexRecalculo SET PrecioMonedaOriginal = @PRECIO_ORIGINAL WHERE ROWid = @FilaROWid;
				--  PRINT 'VUELTA TRES   @PRECIO_ORIGINAL: ' + CAST(@PRECIO_ORIGINAL AS VARCHAR(200))
  				
                   
        FETCH NEXT FROM ProdInfo1 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto, @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario,
            @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
        END;
        CLOSE ProdInfo1;
        DEALLOCATE ProdInfo1;


		 ----------- CUARTA VUELTA, CALCULO DE TOTALES
        DECLARE ProdInfo1 CURSOR
        FOR SELECT ROWid, IDmaestro, Fecha, IdTipoMovimiento,  FlagCostear,IDdetalle, IdProducto, Nombre, Cantidad, SubTotal, PrecioUnitario, 
                    IdMoneda, TipoCambio, CalculadoPU, CalculadoPP,AcumuladoCant ,AcumuladoSaldo,IdConcepto,IdAlmacen,IdProyecto,PrecioMonedaOriginal FROM ERP.KardexRecalculo 
        OPEN ProdInfo1;
        FETCH NEXT FROM ProdInfo1 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
            @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto,@FilaPrecioMonedaOriginal
        WHILE @@fetch_status = 0
        BEGIN

			    --- DEFINIR TOTALES EN SOLES
				IF (@FilaIdMoneda =1)
				BEGIN
					SET  @SUBTOTAL_MBASE = @FilaPrecioUnitario * @FilaCantidad
					SET  @IGV_MBASE = @SUBTOTAL_MBASE * @VALOR_IGV
					SET  @TOTAL_MBASE = @SUBTOTAL_MBASE + @IGV_MBASE 
				    UPDATE ERP.KardexRecalculo SET SubtotalMbase  = ABS(ROUND(@SUBTOTAL_MBASE,2)), TotalMbase =ABS(ROUND(@TOTAL_MBASE,2)), IGVMbase =ABS(ROUND(@IGV_MBASE,2)) WHERE ROWid = @FilaROWid;
					
				 END
				 --- DEFINIR TOTALES EN MONEDA ORIGINAL
				 IF (@FilaIdMoneda <>1)
				 BEGIN
					SET  @SUBTOTAL_MBASE = @FilaPrecioMonedaOriginal * @FilaCantidad
					SET  @IGV_MBASE = @SUBTOTAL_MBASE * @VALOR_IGV
					SET  @TOTAL_MBASE = @SUBTOTAL_MBASE + @IGV_MBASE 
				    UPDATE ERP.KardexRecalculo SET SubtotalMonedaOriginal  = ABS(ROUND(@SUBTOTAL_MBASE,2)), TotalMonedaOriginal =ABS(ROUND(@TOTAL_MBASE,2)), IGVmonedaOriginal =ABS(ROUND(@IGV_MBASE,2)) WHERE ROWid = @FilaROWid;
  				 END
                   
        FETCH NEXT FROM ProdInfo1 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto, @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario,
            @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto,@FilaPrecioMonedaOriginal
        END;
        CLOSE ProdInfo1;
        DEALLOCATE ProdInfo1;


		 ----------- CUARTA VUELTA, ACTUALIZACION DE CAMPOS EN VALE DETALLE
        DECLARE ProdInfo1 CURSOR
        FOR SELECT ROWid, IDmaestro, Fecha, IdTipoMovimiento,  FlagCostear,IDdetalle, IdProducto, Nombre, Cantidad, SubTotal, PrecioUnitario, 
                    IdMoneda, TipoCambio, CalculadoPU, CalculadoPP,AcumuladoCant ,AcumuladoSaldo,IdConcepto,IdAlmacen,IdProyecto,PrecioMonedaOriginal
					,TotalMonedaOriginal,SubtotalMonedaOriginal,IGVmonedaOriginal,TotalMBase,SubtotalMbase,IGVMbase 
					 FROM ERP.KardexRecalculo 
        OPEN ProdInfo1;
        FETCH NEXT FROM ProdInfo1 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
            @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo
			,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto,@FilaPrecioMonedaOriginal
			,@filaTotalMonedaOriginal,@filaSubtotalMonedaOriginal,@filaIGVmonedaOriginal,@filaTotalMBase,@filaSubtotalMbase,@filaIGVMbase 
        WHILE @@fetch_status = 0
        BEGIN
			  -- ACTUALIZACION CUANDO ES FLAG COSTEO 0
			  IF (@FilaFlagCostear = 0)
			  BEGIN
			   DECLARE @VariableCalculo DECIMAL(18,8)=0
			   DECLARE @VariableTotal DECIMAL(18,8)=0
			   DECLARE @VariableSubTotal DECIMAL(18,8)=0
			   DECLARE @VariableIGV DECIMAL(18,8)=0
			       SET @VariableCalculo = @FilaPrecioUnitario/ (SELECT CASE WHEN @FilaIdMoneda = 1 THEN 1 ELSE @FilaTipoCambio END)
					SET @VariableSubTotal =abs(@VariableCalculo * @FilaCantidad)* (SELECT CASE WHEN @FilaIdMoneda = 1 THEN 1 ELSE @FilaTipoCambio END)
					SET @VariableIGV =@VariableSubTotal*@VALOR_IGV
					SET @VariableTotal =(@VariableSubTotal +@VariableIGV)
					PRINT 'rowid -' + cast(@FilaROWid AS varchar(100)) + ' @VariableTotal -' + cast(@VariableTotal AS varchar(100)) + ' @@VariableSubTotal  -' + cast(@VariableSubTotal AS varchar(100))
			    UPDATE ERP.ValeDetalle
				SET
				   
					ERP.ValeDetalle.PrecioUnitario = ROUND(@FilaPrecioUnitario / (SELECT CASE WHEN @FilaIdMoneda = 1 THEN 1 ELSE @FilaTipoCambio END),5) , -- decimal
					ERP.ValeDetalle.PrecioUnitarioPrueba = @FilaPrecioUnitario / (SELECT CASE WHEN @FilaIdMoneda = 1 THEN 1 ELSE @FilaTipoCambio END), -- decimal
					ERP.ValeDetalle.SubTotal = cast(@filaSubtotalMbase AS decimal(14,5)), -- decimal
					ERP.ValeDetalle.IGV = cast(@filaTotalMonedaOriginal-@filaSubtotalMonedaOriginal AS decimal(14,5)), -- decimal
					ERP.ValeDetalle.Total = cast(@filaTotalMonedaOriginal AS decimal(14,5)), -- decimal
					-- CAMPOS PARA REPORTE DE KARDEX precio en soles
					ERP.ValeDetalle.PrecioPromedio = cast(@FilaPrecioUnitario AS decimal(14,5)) , -- decimal
					ERP.ValeDetalle.SubtotalPromedio =cast(@VariableSubTotal AS decimal(14,5)) , --ROUND(@VariableSubTotal * (SELECT CASE WHEN @FilaIdMoneda = 1 THEN 1 ELSE @FilaTipoCambio END),5) , -- decimal
					ERP.ValeDetalle.TotalPromedio =cast(@VariableTotal AS decimal(14,5)) --ROUND( @VariableTotal * (SELECT CASE WHEN @FilaIdMoneda = 1 THEN 1 ELSE @FilaTipoCambio END),5)  -- decimal
				 WHERE ID = @FilaIDdetalle
				

			   END
                -- ACTUALIZACION CUANDO ES FLAG COSTEO 1
			  IF (@FilaFlagCostear = 1)
			  BEGIN
			    UPDATE ERP.ValeDetalle
				SET
					-- CAMPOS PARA REPORTE DE KARDEX precio en soles
					ERP.ValeDetalle.PrecioPromedio = cast(@FilaPrecioUnitario AS decimal(14,5)), -- decimal
					ERP.ValeDetalle.SubtotalPromedio = cast(@filaSubtotalMbase AS decimal(14,5)), -- decimal
					ERP.ValeDetalle.TotalPromedio = cast(@filaTotalMBase AS decimal(14,5)) -- decimal
				 WHERE ID = @FilaIDdetalle
			   END
			       
        FETCH NEXT FROM ProdInfo1 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
            @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo
			,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto,@FilaPrecioMonedaOriginal
			,@filaTotalMonedaOriginal,@filaSubtotalMonedaOriginal,@filaIGVmonedaOriginal,@filaTotalMBase,@filaSubtotalMbase,@filaIGVMbase 
        END;
        CLOSE ProdInfo1;
        DEALLOCATE ProdInfo1;



		

        --------- QUINTA VUELTA, CALCULO DE PRECIO UNITARIO DE ENTRADAS POR TRANSFORMACION
      
		DECLARE @IdTranfs AS int
		DECLARE @IdValeSalida AS int
		DECLARE @IdValeIngreso AS int
		
		DECLARE @OrigenIdProducto int 
		DECLARE @OrigenCantidad decimal(20, 8)
		DECLARE @OrigenPrecioUnitario decimal(20, 8)
		DECLARE @OrigenSubTotal decimal(20, 8) 
		DECLARE @OrigenIGV decimal(20, 8) 
		DECLARE @OrigenTotal decimal(20, 8)
		DECLARE @CantidadItem decimal(20, 8)

		DECLARE TransfCursor CURSOR FOR SELECT t.ID, t.IdValeIngreso, t.IdValeSalida FROM ERP.Transformacion t 
		OPEN TransfCursor
		FETCH NEXT FROM TransfCursor INTO @IdTranfs,@IdValeSalida,@IdValeIngreso
		WHILE @@fetch_status = 0
		BEGIN
			-- origen  ---------------------
					DECLARE OrigenCursor CURSOR FOR SELECT vd.IdProducto, vd.Cantidad, vd.PrecioUnitario,vd.SubTotal, vd.IGV, vd.Total FROM ERP.ValeDetalle vd
													WHERE vd.IdVale = @IdValeSalida
					OPEN OrigenCursor
					FETCH NEXT FROM OrigenCursor INTO @OrigenIdProducto,@OrigenCantidad,@OrigenPrecioUnitario,@OrigenSubTotal,@OrigenIGV,@OrigenTotal
					WHILE @@fetch_status = 0
					BEGIN
				 					UPDATE ERP.TransformacionOrigenDetalle
									SET
										ERP.TransformacionOrigenDetalle.PrecioUnitario = cast(@OrigenPrecioUnitario AS decimal(14,5)), -- decimal
										ERP.TransformacionOrigenDetalle.SubTotal = cast(@OrigenSubTotal AS decimal(14,5)), -- decimal
										ERP.TransformacionOrigenDetalle.IGV = cast(@OrigenIGV AS decimal(14,5)), -- decimal
										ERP.TransformacionOrigenDetalle.Total = cast(@OrigenTotal AS decimal(14,5)) -- decimal
										WHERE ERP.TransformacionOrigenDetalle.IdTransformacion = @IdTranfs 
										AND  ERP.TransformacionOrigenDetalle.IdProducto = @OrigenIdProducto
						FETCH NEXT FROM OrigenCursor INTO @OrigenIdProducto,@OrigenCantidad,@OrigenPrecioUnitario,@OrigenSubTotal,@OrigenIGV,@OrigenTotal
					END
					CLOSE OrigenCursor
					DEALLOCATE OrigenCursor
			-------------------------------
	
	
			-- destino  ---------------------
					set @CantidadItem = (SELECT TOP 1 tod.Cantidad FROM ERP.TransformacionDestinoDetalle tod WHERE tod.IdTransformacion = @IdTranfs )
					DECLARE @SumaSubtotal decimal(20,8)
					DECLARE @SumaPrecioUnitario decimal(20,8)
					DECLARE @sumaIGV decimal(20,8)
					DECLARE @sumaTotal  decimal(20,8)
					if (@CantidadItem = 0) 
					begin
					set @CantidadItem = 1
					 END 
					SELECT @SumaPrecioUnitario = sum(isnull(tod.PrecioUnitario,0)) ,
					@SumaSubtotal = sum(isnull(tod.SubTotal,0))/@CantidadItem , 
					@sumaIGV = sum(isnull(tod.IGV,0))/@CantidadItem ,
					@sumaTotal = sum(isnull(tod.Total,0))/@CantidadItem  
					FROM ERP.TransformacionOrigenDetalle tod 	
					WHERE tod.IdTransformacion = @IdTranfs

					UPDATE ERP.TransformacionDestinoDetalle
					SET
						ERP.TransformacionDestinoDetalle.PrecioUnitario = cast(@SumaPrecioUnitario AS decimal(14,5)) , -- decimal
						ERP.TransformacionDestinoDetalle.SubTotal =cast(@SumaSubtotal AS decimal(14,5)) , -- decimal
						ERP.TransformacionDestinoDetalle.IGV =cast(@sumaIGV AS decimal(14,5)) , -- decimal
						ERP.TransformacionDestinoDetalle.Total = cast(@sumaTotal AS decimal(14,5))  -- decimal
					WHERE  IdTransformacion = @IdTranfs

					UPDATE ERP.ValeDetalle
                            SET 
								  ERP.ValeDetalle.PrecioUnitario = cast(@SumaPrecioUnitario AS decimal(14,5)) , -- decimal
                                  ERP.ValeDetalle.SubTotal = cast(@SumaSubtotal AS decimal(14,5)) , -- decimal
                                  ERP.ValeDetalle.Total = cast(@sumaTotal AS decimal(14,5))  -- decimal
                            WHERE ERP.ValeDetalle.ID = @IdValeIngreso;
					   

			FETCH NEXT FROM TransfCursor INTO @IdTranfs,@IdValeSalida,@IdValeIngreso
		END
		CLOSE TransfCursor
		DEALLOCATE TransfCursor 



  --      ------------- QUINTA VUELTA, CALCULO DE PRECIO UNITARIO DE ENTRADAS POR TRANSFERENCIA
  --      DECLARE ProdInfo5 CURSOR
  --      FOR SELECT ROWid, IDmaestro, Fecha, IdTipoMovimiento,  FlagCostear,IDdetalle, IdProducto,
  --                 Nombre, Cantidad, SubTotal, PrecioUnitario, IdMoneda, TipoCambio, CalculadoPU,
  --                 CalculadoPP,AcumuladoCant ,AcumuladoSaldo,IdConcepto,IdAlmacen,IdProyecto FROM ERP.KardexRecalculo WHERE FlagCostear = 0 AND IdConcepto = 21 AND 
  --                 (SELECT COUNT(vtd.IdProducto) AS existe FROM ERP.ValeTransferencia vt INNER JOIN ERP.ValeTransferenciaDetalle vtd ON vt.ID = vtd.IdValeTransferencia
  --                  WHERE vt.IdValeDestino =  IDmaestro AND vtd.IdProducto =IdProducto)>0
  --      OPEN ProdInfo5;
  --      FETCH NEXT FROM ProdInfo5 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
  --                                     @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, 
  --                                     @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
  --      WHILE @@fetch_status = 0
  --      BEGIN
  --              SET @PRECIO_UNITARIO = 0
  --              SET @VALEORIGEN =0
  --              SET @ALMACENORIGEN = 0
  --              SET @IDESTABLECIMIENTOORIGEN =0 
  --              SELECT TOP 1 @VALEORIGEN =isnull(vt.IdValeOrigen,0) , @ALMACENORIGEN = isnull(vt.IdAlmacenOrigen,0)  
  --                          FROM ERP.ValeTransferencia vt INNER JOIN ERP.ValeTransferenciaDetalle vtd ON vt.ID = vtd.IdValeTransferencia
  --                          WHERE vt.IdValeDestino =  @FilaIDmaestro AND vtd.IdProducto =@FilaIdProducto

  --              SELECT @IDESTABLECIMIENTOORIGEN = a.IdEstablecimiento  
  --                      FROM ERP.ValeDetalle VD
  --                      INNER JOIN ERP.Vale V ON VD.IdVale = V.ID
  --                      INNER JOIN Maestro.ValeEstado VE ON V.IdValeEstado = VE.ID
  --                      INNER JOIN PLE.T12TipoOperacion TOPE ON V.IdConcepto = TOPE.ID
  --                      INNER JOIN Maestro.TipoMovimiento TM ON V.IdTipoMovimiento = TM.ID
  --                      INNER JOIN ERP.Producto P ON VD.IdProducto = P.ID
  --                      INNER JOIN ERP.Almacen A ON V.IdAlmacen = A.ID
  --                      INNER JOIN ERP.Establecimiento E ON A.IdEstablecimiento = E.ID
  --              WHERE V.id = @VALEORIGEN and vd.item =@FilaIdProducto
           
           
  --                   ------- calculamos el precio unitario de la transferencia con el vale de origen ---*-**
  --                   EXEC [ERP].[Usp_Sel_Kardex_Llenar_Tabla_CalculoControl] 
  --                   @IdEmpresaTAB2 = @IdEmpresaTAB, 
  --                   @IdEstablecimientoTAB2 = @IDESTABLECIMIENTOORIGEN, 
  --                   @IdAlmacenTAB2 = @ALMACENORIGEN, 
  --                   @IdMonedaTAB2 = @IdMonedaTAB, 
  --                   @FechaDesdeTAB2 = @FechaDesdeTAB, 
  --                   @FechaHastaTAB2 = @FechaHastaTAB, 
  --                   @IdProductoTAB2 = @FilaIdProducto, 
  --                   @IdProyectoTAB2 = @IdProyectoTAB;

  --              BEGIN TRY
  --                   BEGIN TRAN paso5
  --                          SET @PRECIO_UNITARIO=(isnull((SELECT krc.CalculadoPU FROM ERP.KardexRecalculoControl krc WHERE krc.IDMaestro =@VALEORIGEN) ,1))
  --                          UPDATE ERP.KardexRecalculo SET  KardexRecalculo.CalculadoPU = @PRECIO_UNITARIO , ERP.KardexRecalculo.FlagTraEntreAlm=1 WHERE ROWid = @FilaROWid;
  --                          UPDATE ERP.ValeDetalle
  --                          SET 
  --                              --ERP.ValeDetalle.PrecioPromedio = @PRECIO_UNITARIO, -- decimal
  --                              --ERP.ValeDetalle.SubtotalPromedio = 0, -- decimal
  --                              --ERP.ValeDetalle.TotalPromedio = 0 -- decimal
		--						ERP.ValeDetalle.PrecioUnitario = @SumaPrecioUnitario, -- decimal
  --                                ERP.ValeDetalle.SubTotal = @SumaSubtotal , -- decimal
  --                                ERP.ValeDetalle.Total = @sumaTotal -- decimal
  --                          WHERE ERP.ValeDetalle.ID = @FilaIDdetalle;
  --                   COMMIT TRAN paso5
  --              END TRY
  --              BEGIN CATCH
  --                  SET @MSG_ERROR =(SELECT TOP 1 'PASO 5- ERROR EN PRODUCTO:' +CAST(@IdProductoTAB AS NVARCHAR(29))+ 'NRO ERROR ' + ERROR_NUMBER() + ' -- ' +ERROR_MESSAGE() )
  --                  EXEC  ERP.Usp_Ins_LogTransaccional @TIPO= 1,@MODULO='LOGISTICA',@PROCESO='CALCULO MASIVO KARDEX',@DESCRIPCION=@MSG_ERROR,@USUARIO= 'SQL'
  --                  SET @MSG_ERROR_NUM=5
  --                ROLLBACK TRAN paso5
                   
  --              END CATCH
            
            
  --      FETCH NEXT FROM ProdInfo5 INTO  @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto, 
  --                                      @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario,    @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU,
  --                                       @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
  --      END;
  --      CLOSE ProdInfo5;

  --      DEALLOCATE ProdInfo5;


  --      --------- SEPTIMA VUELTA, CALCULO DE PRECIO UNITARIO DE ENTRADAS NO COSTEABLES POR TRANSFERENCIA ENTRE ALMACENES
  --      --DECLARE ProdInfo7 CURSOR
  --      --FOR SELECT ROWid, IDmaestro, Fecha, IdTipoMovimiento,  FlagCostear,IDdetalle, IdProducto, Nombre, Cantidad, SubTotal, PrecioUnitario, 
  --      --            IdMoneda, TipoCambio, CalculadoPU, CalculadoPP,AcumuladoCant ,AcumuladoSaldo,IdConcepto,IdAlmacen,IdProyecto FROM ERP.KardexRecalculo WHERE FlagCostear <> 1;
  --      --OPEN ProdInfo7;
  --      --FETCH NEXT FROM ProdInfo7 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
  --      --    @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
  --      --WHILE @@fetch_status = 0
  --      --BEGIN

            
  --      --     BEGIN TRY
  --      --             BEGIN TRAN paso7
  --      --                SET @PRECIO_UNITARIO= (SELECT TOP 1 v.CalculadoPU FROM ERP.KardexRecalculo v WHERE V.ROWid< @FilaROWid AND V.IdProducto= @FilaIdProducto )
  --      --    UPDATE ERP.ValeDetalle
  --      --    SET 
  --      --      ERP.ValeDetalle.PrecioPromedio = @PRECIO_UNITARIO, -- decimal
  --      --      ERP.ValeDetalle.SubtotalPromedio = 0, -- decimal
  --      --      ERP.ValeDetalle.TotalPromedio = 0 -- decimal
  --      --     WHERE ERP.ValeDetalle.ID = @FilaIDdetalle;
  --      --             COMMIT TRAN paso7
  --      --        END TRY
  --      --        BEGIN CATCH
  --      --            SET @MSG_ERROR =(SELECT TOP 1 'PASO 7- ERROR EN PRODUCTO:' +CAST(@IdProductoTAB AS NVARCHAR(29))+ 'NRO ERROR ' + ERROR_NUMBER() + ' -- ' +ERROR_MESSAGE() )
  --      --            EXEC  ERP.Usp_Ins_LogTransaccional @TIPO= 1,@MODULO='LOGISTICA',@PROCESO='CALCULO MASIVO KARDEX',@DESCRIPCION=@MSG_ERROR,@USUARIO= 'SQL'
  --      --          ROLLBACK TRAN paso7
  --      --          SET @MSG_ERROR_NUM=7
                   
  --      --        END CATCH


  --      --FETCH NEXT FROM ProdInfo7 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto, @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario,
  --      --    @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
  --      --END;
  --      --CLOSE ProdInfo7;
  --      --DEALLOCATE ProdInfo7;
        
  --      IF (@MSG_ERROR_NUM=0)
  --      BEGIN
  --          SET @MSG_MONITOR = @MSG_MONITOR +' PROCESO: OK'
  --          INSERT ERP.MonitorProcesoMasivo ( Proceso, Descripcion)    VALUES('RECALCULO KARDEX',@MSG_MONITOR)    
  --      END
  --      ELSE
  --      BEGIN
  --          SET @MSG_MONITOR = @MSG_MONITOR +' PROCESO: ERROR. '+ CAST(@MSG_ERROR_NUM AS nvarchar(50))
  --          INSERT ERP.MonitorProcesoMasivo ( Proceso, Descripcion)    VALUES('RECALCULO KARDEX',@MSG_MONITOR)
  --      END
  --      SET @MSG_MONITOR='';

  --      UPDATE ERP.ValeDetalle
  --        SET 
  --            ERP.ValeDetalle.PrecioPromedio = kr.CalculadoPU
  --      FROM ERP.ValeDetalle vd
  --           INNER JOIN ERP.KardexRecalculo kr ON vd.ID = KR.IDdetalle
  --                                                AND vd.IdProducto = kr.IdProducto AND KR.FlagCostear=0;

END