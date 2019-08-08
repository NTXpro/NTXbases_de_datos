-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 11/09/2018
-- Description:	PRIMERA PARTE DEL RECALCULO DE KARDEX
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Sel_Kardex_Calculo_por_Producto]
@IdEmpresaTAB INT,
@IdMonedaTAB INT,
@FechaDesdeTAB DATETIME,
@FechaHastaTAB DATETIME,
@IdProductoTAB INT,
@IdProyectoTAB INT
AS
BEGIN
-- variables
		DECLARE @FilaROWid AS INT;
		DECLARE @FilaIDmaestro AS INT;
		DECLARE @FilaFecha AS DATETIME;
		DECLARE @FilaIdTipoMovimiento AS INT;
		DECLARE @FilaFlagCostear AS INT;
		DECLARE @FilaIDdetalle AS INT;
		DECLARE @FilaIdProducto AS INT;
		DECLARE @FilaNombre AS VARCHAR(250);
		DECLARE @FilaCantidad AS DECIMAL(14, 5);
		DECLARE @FilaSubTotal AS DECIMAL(14, 5);
		DECLARE @FilaPrecioUnitario AS DECIMAL(14, 5);
		DECLARE @FilaIdMoneda AS INT;
		DECLARE @FilaTipoCambio AS DECIMAL(14, 5);
		DECLARE @FilaCalculadoPU AS DECIMAL(14, 5);
		DECLARE @FilaCalculadoPP AS DECIMAL(14, 5);
		DECLARE @FilaAcumuladoCant AS DECIMAL(14, 5);
		DECLARE @FilaAcumuladoSaldo AS DECIMAL(14, 5);
		DECLARE @FilaIdConcepto AS INT;
		DECLARE @FilaIdAlmacen AS INT;
		DECLARE @FilaIdProyecto AS INT;
		DECLARE @PREVIO_EXISTE INT;
		DECLARE @PREVIO_EXISTE_COSTEABLE INT;
		DECLARE @PRECIO_UNITARIO DECIMAL(14, 5)= 0;
		DECLARE @PREVIO_CANTIDAD DECIMAL(14, 5);
		DECLARE @PREVIO_SUBTOTAL DECIMAL(14, 5);
		DECLARE @PRECIO_PROMEDIO DECIMAL(14, 5);
		DECLARE @ACUMULADO_CANT DECIMAL(14, 5);
		DECLARE @ACUMULADO_SALDO DECIMAL(14, 5);
		DECLARE @DIVISOR DECIMAL(14, 5);
		DECLARE @VALEORIGEN INT;
		DECLARE @ALMACENORIGEN INT;
		DECLARE @IDESTABLECIMIENTOORIGEN INT
		DECLARE @IGV_VALE DECIMAL(14,5);
		
			
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
					  vd.Cantidad, 
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
					  '0'
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
					 AND V.IdValeEstado = 1
					 AND VE.Abreviatura NOT IN('A')
					AND ISNULL(V.FlagBorrador, 0) = 0
					AND V.Flag = 1
					AND V.IdEmpresa = @IdEmpresaTAB
					AND P.IdEmpresa = @IdEmpresaTAB
					AND (@IdProyectoTAB = 0
						 OR V.IdProyecto = @IdProyectoTAB)
					AND CAST(V.Fecha AS DATE) <= CAST(@FechaHastaTAB AS DATE)
					AND P.ID = @IdProductoTAB
					AND V.fecha >= CAST(@FechaDesdeTAB AS DATE);
		

----------- PRIMERA VUELTA, CALCULO DE ACUMULADOS DE CANTIDADES Y SALDOS
		DECLARE ProdInfo1 CURSOR
		FOR SELECT ROWid, IDmaestro, Fecha, IdTipoMovimiento,  FlagCostear,IDdetalle, IdProducto, Nombre, Cantidad, SubTotal, PrecioUnitario, 
					IdMoneda, TipoCambio, CalculadoPU, CalculadoPP,AcumuladoCant ,AcumuladoSaldo,IdConcepto,IdAlmacen,IdProyecto FROM ERP.KardexRecalculo;
		OPEN ProdInfo1;
		FETCH NEXT FROM ProdInfo1 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
			@FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
		WHILE @@fetch_status = 0
		BEGIN

				SET @ACUMULADO_SALDO = 0
				SET @ACUMULADO_CANT= 0

				SET @ACUMULADO_CANT =(SELECT SUM(CASE WHEN v.FlagCostear= 1 THEN v.Cantidad ELSE (v.Cantidad*-1) END) FROM ERP.KardexRecalculo v  WHERE V.ROWid<= @FilaROWid AND V.IdProducto= @FilaIdProducto ) 
				SET @ACUMULADO_SALDO=(SELECT SUM(CASE WHEN v.FlagCostear= 1 THEN v.SubTotal ELSE (v.SubTotal*-1) END) FROM ERP.KardexRecalculo v  WHERE V.ROWid<= @FilaROWid AND V.IdProducto= @FilaIdProducto  )
				SET @PRECIO_UNITARIO = @FilaPrecioUnitario;
				UPDATE ERP.KardexRecalculo SET  AcumuladoCant = @ACUMULADO_CANT,  AcumuladoSaldo = @ACUMULADO_SALDO WHERE ROWid = @FilaROWid;

		FETCH NEXT FROM ProdInfo1 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto, @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario,
			@FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
		END;
		CLOSE ProdInfo1;
		DEALLOCATE ProdInfo1;


----------- SEGUNDA VUELTA, CALCULO DE PRECIO UNITARIO DE ENTRADAS COSTEABLES
		DECLARE ProdInfo2 CURSOR
		FOR SELECT ROWid, IDmaestro, Fecha, IdTipoMovimiento,  FlagCostear,IDdetalle, IdProducto, Nombre, Cantidad, SubTotal, PrecioUnitario, 
					IdMoneda, TipoCambio, CalculadoPU, CalculadoPP,AcumuladoCant ,AcumuladoSaldo,IdConcepto,IdAlmacen,IdProyecto FROM ERP.KardexRecalculo WHERE FlagCostear = 1;
		OPEN ProdInfo2;
		FETCH NEXT FROM ProdInfo2 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
			@FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
		WHILE @@fetch_status = 0
		BEGIN
		        
				SET @PRECIO_UNITARIO= @FilaAcumuladoSaldo/@FilaAcumuladoCant
				UPDATE ERP.KardexRecalculo SET  KardexRecalculo.CalculadoPU = @PRECIO_UNITARIO  WHERE ROWid = @FilaROWid;
				UPDATE ERP.ValeDetalle
				  SET 
					  ERP.ValeDetalle.PrecioPromedio = @PRECIO_UNITARIO, -- decimal
					  ERP.ValeDetalle.SubtotalPromedio = 0, -- decimal
					  ERP.ValeDetalle.TotalPromedio = 0 -- decimal
				WHERE ERP.ValeDetalle.ID = @FilaIDdetalle;

		FETCH NEXT FROM ProdInfo2 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto, @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario,
			@FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
		END;
		CLOSE ProdInfo2;
		DEALLOCATE ProdInfo2;


----------- TERCERA VUELTA, CALCULO DE PRECIO UNITARIO DE ENTRADAS NO COSTEABLES
		DECLARE ProdInfo3 CURSOR
		FOR SELECT ROWid, IDmaestro, Fecha, IdTipoMovimiento,  FlagCostear,IDdetalle, IdProducto, Nombre, Cantidad, SubTotal, PrecioUnitario, 
					IdMoneda, TipoCambio, CalculadoPU, CalculadoPP,AcumuladoCant ,AcumuladoSaldo,IdConcepto,IdAlmacen,IdProyecto FROM ERP.KardexRecalculo WHERE FlagCostear <> 1;
		OPEN ProdInfo3;
		FETCH NEXT FROM ProdInfo3 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
			@FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
		WHILE @@fetch_status = 0
		BEGIN

				SET @PREVIO_EXISTE_COSTEABLE = ISNULL((SELECT TOP 1 v.ROWid FROM ERP.KardexRecalculo v WHERE V.ROWid< @FilaROWid AND V.IdProducto= @FilaIdProducto AND V.FlagCostear= 1 ORDER BY v.ROWid DESC),-1)
				SET @IGV_VALE =(	SELECT v.PorcentajeIGV/100.00  FROM erp.vale v WHERE v.ID = @FilaIDmaestro)
				IF(@PREVIO_EXISTE_COSTEABLE = -1)
					BEGIN
						SET @PRECIO_UNITARIO = 1;
						UPDATE ERP.KardexRecalculo
						  SET 
							  KardexRecalculo.CalculadoPU = @PRECIO_UNITARIO
						WHERE ROWid = @FilaROWid;
						UPDATE ERP.ValeDetalle
						    SET 
								  ERP.ValeDetalle.PrecioPromedio = @PRECIO_UNITARIO, -- decimal
								  ERP.ValeDetalle.SubtotalPromedio = (@PRECIO_UNITARIO * @FilaCantidad) - ((@PRECIO_UNITARIO * @FilaCantidad)*@IGV_VALE), -- decimal
								  ERP.ValeDetalle.TotalPromedio = (@PRECIO_UNITARIO * @FilaCantidad) + ((@PRECIO_UNITARIO * @FilaCantidad)*@IGV_VALE) -- decimal
						    WHERE ERP.ValeDetalle.ID = @FilaIDdetalle;
					END;
					ELSE
					BEGIN
						SET @PRECIO_UNITARIO =(SELECT TOP 1 v.CalculadoPU FROM ERP.KardexRecalculo v	
												WHERE V.ROWid < @FilaROWid  AND V.IdProducto = @FilaIdProducto  AND V.FlagCostear = 1 ORDER BY v.ROWid DESC	);
						
						UPDATE ERP.KardexRecalculo
						    SET   KardexRecalculo.CalculadoPU = @PRECIO_UNITARIO	WHERE ROWid = @FilaROWid;
						UPDATE ERP.ValeDetalle
							SET 
								  ERP.ValeDetalle.PrecioPromedio = @PRECIO_UNITARIO, -- decimal
								  ERP.ValeDetalle.SubtotalPromedio = 0, -- decimal
								  ERP.ValeDetalle.TotalPromedio = 0 -- decimal
						    WHERE ERP.ValeDetalle.ID = @FilaIDdetalle;
					END;

		FETCH NEXT FROM ProdInfo3 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto, @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario,
			@FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
		END;
		CLOSE ProdInfo3;
		DEALLOCATE ProdInfo3;


----------- CUARTA VUELTA, CALCULO DE PRECIO UNITARIO DE ENTRADAS POR TRANSFORMACION
		DECLARE ProdInfo4 CURSOR
		FOR SELECT ROWid, IDmaestro, Fecha, IdTipoMovimiento,  FlagCostear,IDdetalle, IdProducto,
		           Nombre, Cantidad, SubTotal, PrecioUnitario, IdMoneda, TipoCambio, CalculadoPU,
				   CalculadoPP,AcumuladoCant ,AcumuladoSaldo,IdConcepto,IdAlmacen,IdProyecto FROM ERP.KardexRecalculo WHERE FlagCostear = 1 AND IdConcepto = 19
				   AND  (SELECT count(t.IdValeIngreso) AS existe FROM ERP.Transformacion t WHERE t.IdValeIngreso = IDmaestro)>0
		OPEN ProdInfo4;
		FETCH NEXT FROM ProdInfo4 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
			                           @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, 
									   @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
		WHILE @@fetch_status = 0
		BEGIN
					DECLARE @VALE_ORIGEN INT = 0
					SET @PRECIO_UNITARIO=(SELECT sum(tod.SubTotal) from ERP.Transformacion tf INNER JOIN ERP.TransformacionOrigenDetalle tod
										  ON tf.ID = tod.IdTransformacion WHERE tf.IdValeIngreso=@FilaIDmaestro)
						IF (@FilaCantidad<>0)
						BEGIN
							 SET @DIVISOR= @FilaCantidad
						END
						SET @PRECIO_UNITARIO = @PRECIO_UNITARIO/@DIVISOR
						UPDATE ERP.KardexRecalculo SET  KardexRecalculo.CalculadoPU = @PRECIO_UNITARIO  WHERE ROWid = @FilaROWid;
						UPDATE ERP.ValeDetalle
							SET 
								ERP.ValeDetalle.PrecioPromedio = @PRECIO_UNITARIO, -- decimal
								ERP.ValeDetalle.SubtotalPromedio = 0, -- decimal
								ERP.ValeDetalle.TotalPromedio = 0 -- decimal
						WHERE ERP.ValeDetalle.ID = @FilaIDdetalle;

		FETCH NEXT FROM ProdInfo4 INTO  @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto, 
										@FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario,	@FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU,
										@FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
		END;
		CLOSE ProdInfo4;
		DEALLOCATE ProdInfo4;


------------- QUINTA VUELTA, CALCULO DE PRECIO UNITARIO DE ENTRADAS POR TRANSFERENCIA
		DECLARE ProdInfo5 CURSOR
		FOR SELECT ROWid, IDmaestro, Fecha, IdTipoMovimiento,  FlagCostear,IDdetalle, IdProducto,
		           Nombre, Cantidad, SubTotal, PrecioUnitario, IdMoneda, TipoCambio, CalculadoPU,
				   CalculadoPP,AcumuladoCant ,AcumuladoSaldo,IdConcepto,IdAlmacen,IdProyecto FROM ERP.KardexRecalculo WHERE FlagCostear = 0 AND IdConcepto = 21 AND 
				   (SELECT COUNT(vtd.IdProducto) AS existe FROM ERP.ValeTransferencia vt INNER JOIN ERP.ValeTransferenciaDetalle vtd ON vt.ID = vtd.IdValeTransferencia
					WHERE vt.IdValeDestino =  IDmaestro AND vtd.IdProducto =IdProducto)>0
		OPEN ProdInfo5;
		FETCH NEXT FROM ProdInfo5 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
			                           @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, 
									   @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
		WHILE @@fetch_status = 0
		BEGIN
				SET @PRECIO_UNITARIO = 0
				SET @VALEORIGEN =0
				SET @ALMACENORIGEN = 0
				SET @IDESTABLECIMIENTOORIGEN =0 
				SELECT TOP 1 @VALEORIGEN =isnull(vt.IdValeOrigen,0) , @ALMACENORIGEN = isnull(vt.IdAlmacenOrigen,0)  
							FROM ERP.ValeTransferencia vt INNER JOIN ERP.ValeTransferenciaDetalle vtd ON vt.ID = vtd.IdValeTransferencia
							WHERE vt.IdValeDestino =  @FilaIDmaestro AND vtd.IdProducto =@FilaIdProducto

				SELECT @IDESTABLECIMIENTOORIGEN = a.IdEstablecimiento  
						FROM ERP.ValeDetalle VD
						INNER JOIN ERP.Vale V ON VD.IdVale = V.ID
						INNER JOIN Maestro.ValeEstado VE ON V.IdValeEstado = VE.ID
						INNER JOIN PLE.T12TipoOperacion TOPE ON V.IdConcepto = TOPE.ID
						INNER JOIN Maestro.TipoMovimiento TM ON V.IdTipoMovimiento = TM.ID
						INNER JOIN ERP.Producto P ON VD.IdProducto = P.ID
						INNER JOIN ERP.Almacen A ON V.IdAlmacen = A.ID
						INNER JOIN ERP.Establecimiento E ON A.IdEstablecimiento = E.ID
				WHERE V.id = @VALEORIGEN and vd.item =@FilaIdProducto
		   
		   
		             ------- calculamos el precio unitario de la transferencia con el vale de origen ---*-**
					 EXEC [ERP].[Usp_Sel_Kardex_Llenar_Tabla_CalculoControl] 
					 @IdEmpresaTAB2 = @IdEmpresaTAB, 
					 @IdEstablecimientoTAB2 = @IDESTABLECIMIENTOORIGEN, 
					 @IdAlmacenTAB2 = @ALMACENORIGEN, 
					 @IdMonedaTAB2 = @IdMonedaTAB, 
					 @FechaDesdeTAB2 = @FechaDesdeTAB, 
					 @FechaHastaTAB2 = @FechaHastaTAB, 
					 @IdProductoTAB2 = @FilaIdProducto, 
					 @IdProyectoTAB2 = @IdProyectoTAB;

	 
			SET @PRECIO_UNITARIO=(isnull((SELECT krc.CalculadoPU FROM ERP.KardexRecalculoControl krc WHERE krc.IDMaestro =@VALEORIGEN) ,1))
		    UPDATE ERP.KardexRecalculo SET  KardexRecalculo.CalculadoPU = @PRECIO_UNITARIO , ERP.KardexRecalculo.FlagTraEntreAlm=1 WHERE ROWid = @FilaROWid;
			UPDATE ERP.ValeDetalle
		    SET 
			  ERP.ValeDetalle.PrecioPromedio = @PRECIO_UNITARIO, -- decimal
			  ERP.ValeDetalle.SubtotalPromedio = 0, -- decimal
			  ERP.ValeDetalle.TotalPromedio = 0 -- decimal
		     WHERE ERP.ValeDetalle.ID = @FilaIDdetalle;
			
		FETCH NEXT FROM ProdInfo5 INTO  @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto, 
										@FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario,	@FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU,
										 @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
		END;
		CLOSE ProdInfo5;

		DEALLOCATE ProdInfo5;


--------- SEPTIMA VUELTA, CALCULO DE PRECIO UNITARIO DE ENTRADAS NO COSTEABLES POR TRANSFERENCIA ENTRE ALMACENES
		DECLARE ProdInfo7 CURSOR
		FOR SELECT ROWid, IDmaestro, Fecha, IdTipoMovimiento,  FlagCostear,IDdetalle, IdProducto, Nombre, Cantidad, SubTotal, PrecioUnitario, 
					IdMoneda, TipoCambio, CalculadoPU, CalculadoPP,AcumuladoCant ,AcumuladoSaldo,IdConcepto,IdAlmacen,IdProyecto FROM ERP.KardexRecalculo WHERE FlagCostear <> 1;
		OPEN ProdInfo7;
		FETCH NEXT FROM ProdInfo7 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
			@FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
		WHILE @@fetch_status = 0
		BEGIN

			SET @PRECIO_UNITARIO= (SELECT TOP 1 v.CalculadoPU FROM ERP.KardexRecalculo v WHERE V.ROWid< @FilaROWid AND V.IdProducto= @FilaIdProducto )
			UPDATE ERP.ValeDetalle
		    SET 
			  ERP.ValeDetalle.PrecioPromedio = @PRECIO_UNITARIO, -- decimal
			  ERP.ValeDetalle.SubtotalPromedio = 0, -- decimal
			  ERP.ValeDetalle.TotalPromedio = 0 -- decimal
		     WHERE ERP.ValeDetalle.ID = @FilaIDdetalle;



		FETCH NEXT FROM ProdInfo7 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto, @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario,
			@FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
		END;
		CLOSE ProdInfo7;
		DEALLOCATE ProdInfo7;

END