


-- =============================================
-- Author:        OMAR RODRIGUEZ
-- Create date: 13/08/2018
-- Description:    PRIMERA PARTE DEL RECALCULO DE KARDEX
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Sel_Kardex_Llenar_Tabla_CalculoControl]
@IdEmpresaTAB2 INT,
@IdEstablecimientoTAB2 INT,
@IdAlmacenTAB2 INT,
@IdMonedaTAB2 INT,
@FechaDesdeTAB2 DATETIME,
@FechaHastaTAB2 DATETIME,
@IdProductoTAB2 INT,
@IdProyectoTAB2 INT
AS
BEGIN
    -------------------------------
        DELETE FROM  ERP.KardexRecalculoControl
        
        INSERT INTO ERP.KardexRecalculoControl
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
                        v.IdProyecto
                        
                FROM ERP.Vale v
                    INNER JOIN ERP.ValeDetalle vd ON v.ID = vd.IdVale
                    INNER JOIN ERP.Almacen A ON V.IdAlmacen = A.ID
                    INNER JOIN ERP.Producto P ON VD.IdProducto = P.ID
                    INNER JOIN Maestro.ValeEstado VE ON V.IdValeEstado = VE.ID
                    INNER JOIN ERP.Establecimiento E ON A.IdEstablecimiento = E.ID
                    LEFT JOIN ERP.Entidad EN ON V.IdEntidad = EN.ID
                    INNER JOIN PLE.T12TipoOperacion topper ON v.IdConcepto = topper.ID  WHERE   v.FlagBorrador=0 
                    AND v.flag=1 AND V.IdValeEstado IN(1,3) AND
                    VE.Abreviatura NOT IN ('A') AND
                        ISNULL(V.FlagBorrador, 0) = 0 AND
                        V.Flag = 1 AND
                        --------------
                        V.IdEmpresa = @IdEmpresaTAB2 AND
                        P.IdEmpresa = @IdEmpresaTAB2 AND
                        E.ID = @IdEstablecimientoTAB2 AND
                        (@IdProyectoTAB2 = 0 OR V.IdProyecto = @IdProyectoTAB2) AND
                        A.ID = @IdAlmacenTAB2 AND
                        CAST(V.Fecha AS DATE) <= CAST(@FechaHastaTAB2 AS DATE) AND P.ID = @IdProductoTAB2
                        AND V.fecha >= CAST(@FechaDesdeTAB2 AS DATE)
                                 
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



        ----------- PRIMERA VUELTA, CALCULO DE ACUMULADOS DE CANTIDADES Y SALDOS
        DECLARE ProdInfo1 CURSOR
        FOR SELECT ROWid, IDmaestro, Fecha, IdTipoMovimiento,  FlagCostear,IDdetalle, IdProducto, Nombre, Cantidad, SubTotal, PrecioUnitario, 
                    IdMoneda, TipoCambio, CalculadoPU, CalculadoPP,AcumuladoCant ,AcumuladoSaldo,IdConcepto,IdAlmacen,IdProyecto FROM ERP.KardexRecalculoControl;
        OPEN ProdInfo1;
        FETCH NEXT FROM ProdInfo1 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
            @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
        WHILE @@fetch_status = 0
        BEGIN

        SET @ACUMULADO_SALDO = 0
        SET @ACUMULADO_CANT= 0

        SET @ACUMULADO_CANT =(SELECT SUM(CASE WHEN v.FlagCostear= 1 THEN v.Cantidad ELSE (v.Cantidad*-1) END) FROM ERP.KardexRecalculoControl v  WHERE V.ROWid<= @FilaROWid AND V.IdProducto= @FilaIdProducto ) 
        SET @ACUMULADO_SALDO=(SELECT SUM(CASE WHEN v.FlagCostear= 1 THEN v.SubTotal ELSE (v.SubTotal*-1) END) FROM ERP.KardexRecalculoControl v  WHERE V.ROWid<= @FilaROWid AND V.IdProducto= @FilaIdProducto  )
        SET @PRECIO_UNITARIO = @FilaPrecioUnitario;
        UPDATE ERP.KardexRecalculoControl SET  AcumuladoCant = @ACUMULADO_CANT,
		   AcumuladoSaldo = @ACUMULADO_SALDO 
		   ,PrecioUnitario =@PRECIO_UNITARIO
		   WHERE ROWid = @FilaROWid;

        FETCH NEXT FROM ProdInfo1 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto, @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario,
            @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
        END;
        CLOSE ProdInfo1;
        DEALLOCATE ProdInfo1;


        ----------- SEGUNDA VUELTA, CALCULO DE PRECIO UNITARIO DE ENTRADAS COSTEABLES
        DECLARE ProdInfo2 CURSOR
        FOR SELECT ROWid, IDmaestro, Fecha, IdTipoMovimiento,  FlagCostear,IDdetalle, IdProducto, Nombre, Cantidad, SubTotal, PrecioUnitario, 
                    IdMoneda, TipoCambio, CalculadoPU, CalculadoPP,AcumuladoCant ,AcumuladoSaldo,IdConcepto,IdAlmacen,IdProyecto FROM ERP.KardexRecalculoControl WHERE FlagCostear = 1;
        OPEN ProdInfo2;
        FETCH NEXT FROM ProdInfo2 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
            @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
        WHILE @@fetch_status = 0
        BEGIN

        --SET @PRECIO_UNITARIO= @FilaAcumuladoSaldo/@FilaAcumuladoCant
		SET @PRECIO_UNITARIO = @FilaPrecioUnitario
        UPDATE ERP.KardexRecalculoControl SET  KardexRecalculoControl.CalculadoPU = @PRECIO_UNITARIO  WHERE ROWid = @FilaROWid;

        FETCH NEXT FROM ProdInfo2 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto, @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario,
            @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
        END;
        CLOSE ProdInfo2;
        DEALLOCATE ProdInfo2;


        ----------- TERCERA VUELTA, CALCULO DE PRECIO UNITARIO DE ENTRADAS NO COSTEABLES
        DECLARE ProdInfo3 CURSOR
        FOR SELECT ROWid, IDmaestro, Fecha, IdTipoMovimiento,  FlagCostear,IDdetalle, IdProducto, Nombre, Cantidad, SubTotal, PrecioUnitario, 
                    IdMoneda, TipoCambio, CalculadoPU, CalculadoPP,AcumuladoCant ,AcumuladoSaldo,IdConcepto,IdAlmacen,IdProyecto FROM ERP.KardexRecalculoControl WHERE FlagCostear <> 1;
        OPEN ProdInfo3;
        FETCH NEXT FROM ProdInfo3 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
            @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
        WHILE @@fetch_status = 0
        BEGIN

        SET @PREVIO_EXISTE_COSTEABLE = ISNULL((SELECT TOP 1 v.ROWid FROM ERP.KardexRecalculoControl v WHERE V.ROWid< @FilaROWid AND V.IdProducto= @FilaIdProducto AND V.FlagCostear= 1 
                                ORDER BY v.ROWid DESC),-1)

        IF (@PREVIO_EXISTE_COSTEABLE = -1)
        BEGIN
            SET @PRECIO_UNITARIO= 1
            UPDATE ERP.KardexRecalculoControl SET  KardexRecalculoControl.CalculadoPU = @PRECIO_UNITARIO  WHERE ROWid = @FilaROWid;
            END
            ELSE
            BEGIN
            SET @PRECIO_UNITARIO= (SELECT TOP 1 v.CalculadoPU FROM ERP.KardexRecalculoControl v WHERE V.ROWid< @FilaROWid AND V.IdProducto= @FilaIdProducto AND V.FlagCostear= 1 
                                ORDER BY v.ROWid DESC)
            UPDATE ERP.KardexRecalculoControl SET  KardexRecalculoControl.CalculadoPU = @PRECIO_UNITARIO  WHERE ROWid = @FilaROWid;
            END
 

        FETCH NEXT FROM ProdInfo3 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto, @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario,
            @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
        END;
        CLOSE ProdInfo3;
        DEALLOCATE ProdInfo3;

        ----------- CUARTA VUELTA, CALCULO DE PRECIO UNITARIO DE ENTRADAS POR TRANSFORMACION
        DECLARE ProdInfo4 CURSOR
        FOR SELECT ROWid, IDmaestro, Fecha, IdTipoMovimiento,  FlagCostear,IDdetalle, IdProducto,
                   Nombre, Cantidad, SubTotal, PrecioUnitario, IdMoneda, TipoCambio, CalculadoPU,
                   CalculadoPP,AcumuladoCant ,AcumuladoSaldo,IdConcepto,IdAlmacen,IdProyecto FROM ERP.KardexRecalculoControl WHERE FlagCostear = 1 AND IdConcepto = 19
                   AND  (SELECT count(t.IdValeIngreso) AS existe FROM ERP.Transformacion t WHERE t.IdValeIngreso = IDmaestro)>0
        OPEN ProdInfo4;
        FETCH NEXT FROM ProdInfo4 INTO @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto,
                                       @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario, @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU, 
                                       @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
        WHILE @@fetch_status = 0
        BEGIN
            DECLARE @VALE_ORIGEN INT = 0

        --    SET @VALE_ORIGEN = (SELECT TOP 1 vt.IdValeOrigen FROM ERP.ValeTransferencia vt WHERE vt.IdValeDestino = @FilaIDmaestro AND vt.Flag=1 AND vt.FlagBorrador = 0)
        --    SET @PRECIO_UNITARIO=(SELECT TOP 1  vd.PrecioUnitario FROM ERP.ValeDetalle vd WHERE  VD.IdVale = @VALE_ORIGEN AND  VD.IdProducto = @FilaIdProducto);
        SET @PRECIO_UNITARIO=(SELECT sum(tod.SubTotal) from ERP.Transformacion tf INNER JOIN ERP.TransformacionOrigenDetalle tod
                                ON tf.ID = tod.IdTransformacion WHERE tf.IdValeIngreso=@FilaIDmaestro)
            IF (@FilaCantidad<>0)
            BEGIN
             SET @DIVISOR= @FilaCantidad
            END
          --  SET @PRECIO_UNITARIO = @PRECIO_UNITARIO/@DIVISOR
			  SET @PRECIO_UNITARIO = @PRECIO_UNITARIO/ (Select case when @DIVISOR = 0 THEN 1 ELSE @DIVISOR end)

            UPDATE ERP.KardexRecalculoControl SET  KardexRecalculoControl.CalculadoPU = @PRECIO_UNITARIO  WHERE ROWid = @FilaROWid;

        FETCH NEXT FROM ProdInfo4 INTO  @FilaROWid, @FilaIDmaestro, @FilaFecha, @FilaIdTipoMovimiento, @FilaFlagCostear, @FilaIDdetalle, @FilaIdProducto, 
                                        @FilaNombre, @FilaCantidad, @FilaSubTotal, @FilaPrecioUnitario,    @FilaIdMoneda, @FilaTipoCambio, @FilaCalculadoPU,
                                         @FilaCalculadoPP,@FilaAcumuladoCant,@FilaAcumuladoSaldo,@FilaIdConcepto,@FilaIdAlmacen,@FilaIdProyecto
        END;
        CLOSE ProdInfo4;
        DEALLOCATE ProdInfo4;
     -------------------------------



END