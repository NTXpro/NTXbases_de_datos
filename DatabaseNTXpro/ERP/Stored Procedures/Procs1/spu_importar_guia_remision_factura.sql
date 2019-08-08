-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ERP].[spu_importar_guia_remision_factura]
	 @IdFactura INT,
     @IdGuiaRemision INT
AS
BEGIN
	
	
DECLARE @Fecha datetime = '2019-07-10'
SELECT @Fecha = c.Fecha FROM ERP.Comprobante c WHERE c.id = @IdFactura

DECLARE @IGV int = (SELECT Valor FROM ERP.Parametro WHERE Abreviatura = 'IGV')

------------------------------- INSERTAR DATOS DE CABECERA DE LA GUIA DE REMISION  ---------------
---------------------------

UPDATE ERP.Comprobante
SET
   
      ERP.Comprobante.IdVendedor = A.idvendedor, -- int
      ERP.Comprobante.IdAlmacen = A.IdAlmacen,
      ERP.Comprobante.IdEstablecimiento = A.IdEstablecimiento, 
	  ERP.Comprobante.IdListaPrecio = A.IdListaPrecio,
	  ERP.Comprobante.IdMoneda= A.IdMoneda,
	  ERP.Comprobante.IdVale = A.IdVale,
	  ERP.Comprobante.igv = A.igv, 
	  ERP.Comprobante.Observacion = A.Observacion, 
	  ERP.Comprobante.PorcentajeIGV = @IGV, 
	  ERP.Comprobante.SubTotal = A.SubTotal, 
	  ERP.Comprobante.TipoCambio = A.TipoCambio,
	  ERP.Comprobante.Total = A.Total
FROM (SELECT gr.IdAlmacen, gr.IdEstablecimiento, gr.IdListaPrecio,gr.IdMoneda, gr.IdVale, gr.IdVendedor, gr.igv, gr.Observacion,
			 gr.PorcentajeIGV, gr.SubTotal, gr.TipoCambio ,gr.Total
			 FROM ERP.GuiaRemision gr
WHERE gr.id = @IdGuiaRemision) A
WHERE ERP.Comprobante.id = @IdFactura





------------------------------- INSERTAR LAS REFERENCIAS DE LA GUIA DE REMISION  -----------------------------
-------------
DELETE FROM ERP.ComprobanteReferencia WHERE ERP.ComprobanteReferencia.IdComprobante = @IdFactura



DECLARE @documento_gr varchar(100)
DECLARE @serie_gr varchar(100)
DECLARE @IdProducto int
DECLARE @IdReferenciaOrigen INT
DECLARE @IdReferencia INT 
DECLARE @IdTipoComprobante INT
DECLARE @Serie varchar(100)
DECLARE @Documento varchar(100)
DECLARE @FlagInterno bit

--------------- INSERTAR LA GUIA DE REMISION COMO UNA REFERENCIA 
SELECT @serie_gr = gr.Serie,@documento_gr =  gr.Documento FROM  erp.GuiaRemision gr WHERE id = @IdGuiaRemision
 INSERT ERP.ComprobanteReferencia( IdComprobante, IdReferenciaOrigen, IdReferencia, IdTipoComprobante, Serie, Documento, FlagInterno, Total)
VALUES( @IdFactura, 3, @IdGuiaRemision, 10, @serie_gr, @documento_gr,  1, 0 )
   
--------------- INSERTAR LAS REFERENCIAS
DECLARE ProdInfo CURSOR FOR SELECT  grr.IdReferenciaOrigen, grr.IdReferencia, grr.IdTipoComprobante, grr.Serie,
									grr.Documento, grr.FlagInterno FROM  ERP.GuiaRemisionReferencia grr WHERE  grr.IdGuiaRemision = @IdGuiaRemision
OPEN ProdInfo
FETCH NEXT FROM ProdInfo INTO @IdReferenciaOrigen, @IdReferencia, @IdTipoComprobante, @Serie,@Documento,@FlagInterno
WHILE @@fetch_status = 0
BEGIN
    INSERT ERP.ComprobanteReferencia
( IdComprobante, IdReferenciaOrigen, IdReferencia, IdTipoComprobante, Serie, Documento, FlagInterno, Total)
VALUES
( @IdFactura, @IdReferenciaOrigen, @IdReferencia, @IdTipoComprobante, @Serie, @Documento,  @FlagInterno, 0 )
    FETCH NEXT FROM ProdInfo INTO @IdReferenciaOrigen, @IdReferencia, @IdTipoComprobante, @Serie,@Documento,@FlagInterno
END
CLOSE ProdInfo
DEALLOCATE ProdInfo



------------------------------- INSERTAR LOS DETALLES (ITEMS) DE LA GUIA DE REMISION ------------------------------------------

DECLARE @Nombre varchar(200)
DECLARE @Cantidad DECIMAL(15,5)  
DECLARE @Lote varchar(200)
DECLARE @PrecioIGV DECIMAL(15,5)  
DECLARE @PrecioLista DECIMAL(15,5)  
DECLARE @PrecioSubTotal DECIMAL(15,5)  
DECLARE @PrecioTotal DECIMAL(15,5)  
DECLARE @PrecioUnitarioIGV DECIMAL(15,5)  
DECLARE @PrecioUnitarioTotal DECIMAL(15,5)  
DECLARE @PrecioUnitarioSubTotal DECIMAL(15,5)  
DECLARE @PrecioUnitarioISC DECIMAL(15,5)  
DECLARE @PrecioUnitarioListaSinIGV DECIMAL(15,5)  
DECLARE @PrecioUnitarioValorISC DECIMAL(15,5)  
DECLARE @PrecioUnitarioLista  DECIMAL(15,5)
DECLARE @FlagAfecto bit

DELETE FROM ERP.ComprobanteDetalle WHERE ERP.ComprobanteDetalle.IdComprobante = @IdFactura

DECLARE ProdInfo CURSOR FOR SELECT  grd.IdProducto, grd.Nombre, grd.Cantidad, grd.Lote, grd.PrecioIGV, grd.PrecioLista, grd.PrecioSubTotal, grd.PrecioTotal, grd.PrecioUnitarioIGV
									,grd.PrecioUnitarioTotal, grd.PrecioUnitarioSubTotal, grd.PrecioUnitarioISC, grd.PrecioUnitarioListaSinIGV, grd.PrecioUnitarioValorISC, grd.PrecioUnitarioLista,grd.FlagAfecto 
									FROM ERP.GuiaRemisionDetalle grd WHERE grd.IdGuiaRemision = @IdGuiaRemision
OPEN ProdInfo
FETCH NEXT FROM ProdInfo INTO @IdProducto ,@Nombre ,@Cantidad ,@Lote,@PrecioIGV,@PrecioLista,@PrecioSubTotal,@PrecioTotal,@PrecioUnitarioIGV,@PrecioUnitarioTotal,@PrecioUnitarioSubTotal,@PrecioUnitarioISC 
                                  ,@PrecioUnitarioListaSinIGV,@PrecioUnitarioValorISC,@PrecioUnitarioLista ,@FlagAfecto 
WHILE @@fetch_status = 0
BEGIN
					INSERT erp.ComprobanteDetalle
					(   IdComprobante,
						IdProducto,
						Nombre,
						Cantidad,
						PorcentajeDescuento,
						PorcentajeISC,
						PrecioPromedio,
						PrecioUnitarioLista,
						PrecioUnitarioListaSinIGV,
						PrecioUnitarioValorISC,
						PrecioUnitarioISC,
						PrecioUnitarioDescuento,
						PrecioUnitarioSubTotal,
						PrecioUnitarioIGV,
						PrecioUnitarioTotal,
						PrecioLista,
						PrecioDescuento,
						PrecioSubTotal,
						PrecioIGV,
						PrecioTotal,
						FechaRegistro,
						NumeroLote,
						Fecha,
						flagAfecto
					)
					VALUES
					(
						-- ID - bigint
						@IdFactura, -- IdComprobante - int
						@IdProducto, -- IdProducto - int
						@Nombre, -- Nombre - varchar
						@Cantidad, -- Cantidad - decimal
						0, -- PorcentajeDescuento - decimal
						0, -- PorcentajeISC - decimal
						0, -- PrecioPromedio - decimal
						@PrecioUnitarioLista, -- PrecioUnitarioLista - decimal
						0, -- PrecioUnitarioListaSinIGV - decimal
						@PrecioUnitarioValorISC, -- PrecioUnitarioValorISC - decimal
						@PrecioUnitarioISC, -- PrecioUnitarioISC - decimal
						0, -- PrecioUnitarioDescuento - decimal
						@PrecioUnitarioSubTotal, -- PrecioUnitarioSubTotal - decimal
						@PrecioUnitarioIGV, -- PrecioUnitarioIGV - decimal
						@PrecioUnitarioTotal, -- PrecioUnitarioTotal - decimal
						@PrecioLista, -- PrecioLista - decimal
						0, -- PrecioDescuento - decimal
						@PrecioSubTotal, -- PrecioSubTotal - decimal
						@PrecioIGV, -- PrecioIGV - decimal
						@PrecioTotal, -- PrecioTotal - decimal
						@Fecha, -- FechaRegistro - datetime
						@Lote, -- NumeroLote - varchar
						@Fecha, -- Fecha - datetime
						@FlagAfecto
					)

    FETCH NEXT FROM ProdInfo INTO @IdProducto ,@Nombre ,@Cantidad ,@Lote,@PrecioIGV,@PrecioLista,@PrecioSubTotal
,@PrecioTotal,@PrecioUnitarioIGV,@PrecioUnitarioTotal,@PrecioUnitarioSubTotal,@PrecioUnitarioISC 
                                  ,@PrecioUnitarioListaSinIGV,@PrecioUnitarioValorISC,@PrecioUnitarioLista ,@FlagAfecto 
END
CLOSE ProdInfo
DEALLOCATE ProdInfo


------------------------------- CAMBIO EL ESTATUS DE LA FACTURA SI LA MISMA ES NUEVA  ------------------------------------------
IF  EXISTS(SELECT * from  ERP.Comprobante c WHERE  c.id = @idFactura  AND c.flagborrador = 1)
BEGIN
	UPDATE ERP.Comprobante  SET    ERP.Comprobante.flagborrador = 0 WHERE  id =@idFactura
END

------------------------------ CALCULO DE LOS TOTALES ---------------------------------------------------------------------------

            DECLARE @PorcentajeDescuento DECIMAL(15,5) 
			DECLARE @porcentajeIGV DECIMAL(15,5) 
			DECLARE @FlagImportacion bit
			DECLARE @flagPercepcion bit
			DECLARE @ImporteDescuento  DECIMAL(15,5) 
			DECLARE @ImportePercepcion DECIMAL(15,5)
			DECLARE @PorcentajePercepcion DECIMAL(15,5)
            DECLARE @PorcentajeAdelanto  DECIMAL(15,5) 
            DECLARE @ImporteAdelanto  DECIMAL(15,5) 
            DECLARE @TotalDetalleAfecto  DECIMAL(15,5) 
            DECLARE @TotalDetalleAfectoDescuento  DECIMAL(15,5) 
            DECLARE @TotalDetalleInafecto  DECIMAL(15,5) 
            DECLARE @TotalDetalleInafectoDescuento  DECIMAL(15,5) 
            DECLARE @TotalDetalleExportacion  DECIMAL(15,5) 
			DECLARE @TotalPercepcion  DECIMAL(15,5) 
		    DECLARE @TotalDetalleExportacionDescuento DECIMAL(15,5) 
            DECLARE @TotalDetalleISC  DECIMAL(15,5) 
            DECLARE @TotalDetalle  DECIMAL(15,5) 
			DECLARE @SubTotal DECIMAL(15,5)
			--DECLARE @IGV DECIMAL(15,5)
			DECLARE @Total DECIMAL (15,5)





	 SELECT @PorcentajeDescuento= isnull(c.PorcentajeDescuento,0), @FlagImportacion = isnull(c.FlagExportacion,0), @flagPercepcion = isnull(c.FlagPercepcion,0) , @ImportePercepcion= c.ImportePercepcion FROM ERP.Comprobante c WHERE c.id=@IdFactura
          
	 SET @TotalDetalleAfecto =( SELECT sum(cd.PrecioSubTotal) FROM ERP.ComprobanteDetalle cd WHERE cd.FlagAfecto= 1 AND cd.IdComprobante =@IdFactura)
	 SET @TotalDetalleAfectoDescuento = (@TotalDetalleAfecto * (@PorcentajeDescuento/100))
	 SET @TotalDetalleInafecto  = (SELECT sum(cd.PrecioSubTotal) FROM ERP.ComprobanteDetalle cd WHERE cd.FlagAfecto= 1 AND cd.IdComprobante =@IdFactura)
	 SET @TotalDetalleInafectoDescuento = (@TotalDetalleInafecto * (@PorcentajeDescuento/100))
	 SET @TotalDetalleExportacion = (SELECT sum(cd.PrecioSubTotal) FROM ERP.ComprobanteDetalle cd WHERE  cd.IdComprobante =@IdFactura)
	 SET @TotalDetalleExportacionDescuento  = (@TotalDetalleExportacion * (@PorcentajeDescuento/100))
	 SET @TotalDetalleISC  = (SELECT sum(cd.PrecioUnitarioValorISC*cd.Cantidad) FROM ERP.ComprobanteDetalle cd WHERE cd.FlagISC= 1 AND cd.IdComprobante =@IdFactura)
	 SET @TotalDetalle = (@TotalDetalleInafecto+ @TotalDetalleAfecto)

	 IF (@FlagImportacion =1)
	 BEGIN
		SET @TotalDetalleInafecto = 0
		SET @TotalDetalleAfecto = 0;
        SET @TotalDetalle = @TotalDetalleExportacion

	 END
	 ELSE
	 BEGIN
		SET @TotalDetalleExportacion = 0
	 END

	
	
            IF (@PorcentajeDescuento <>0  OR  @PorcentajeAdelanto =0)
            BEGIN
               
                SET @ImporteDescuento = (@TotalDetalle * (@PorcentajeDescuento / 100))
                DECLARE  @SubTotalConDescuento decimal(15,5) = (@TotalDetalle - @ImporteDescuento)
                SET @ImporteAdelanto = (@SubTotalConDescuento * (@PorcentajeAdelanto / 100))
                SET @SubTotal = (@SubTotalConDescuento - @ImporteAdelanto)
               
                SET @IGV = (@SubTotal * (@porcentajeIGV / 100))
                SET @Total = (@SubTotal + @IGV)
            END
            ELSE
            BEGIN
                SET @SubTotal =(SELECT SUM(cd.PrecioSubTotal) FROM ERP.ComprobanteDetalle cd WHERE cd.IdComprobante =@IdFactura)
                SET @IGV =(SELECT SUM(cd.PrecioIGV) FROM ERP.ComprobanteDetalle cd WHERE cd.IdComprobante =@IdFactura)
                SET @Total = (SELECT SUM(cd.PrecioTotal) FROM ERP.ComprobanteDetalle cd WHERE cd.IdComprobante =@IdFactura)
            END

            IF (@flagPercepcion = 1)
            BEGIN
                SET @ImportePercepcion = (@Total * (@porcentajePercepcion / 100))
                SET @TotalPercepcion = (@Total + @ImportePercepcion)
            END



UPDATE ERP.Comprobante
SET
	ERP.Comprobante.TotalDetalleISC = @TotalDetalleAfecto, -- decimal
    ERP.Comprobante.TotalDetalleAfecto = @TotalDetalleAfecto, -- decimal
    ERP.Comprobante.TotalDetalleInafecto = @TotalDetalleInafecto, -- decimal
    ERP.Comprobante.TotalDetalleExportacion = @TotalDetalleExportacion, -- decimal
    ERP.Comprobante.TotalDetalleGratuito = 0, -- decimal
    ERP.Comprobante.TotalDetalle = @TotalDetalle, -- decimal
    ERP.Comprobante.ImporteDescuento = @ImporteDescuento, -- decimal
    ERP.Comprobante.SubTotal = @SubTotal, -- decimal
    ERP.Comprobante.IGV = @IGV, -- decimal
    ERP.Comprobante.Total = @Total -- decimal
    where id =@IdFactura

--UPDATE ERP.GuiaRemision
--SET

--    ERP.GuiaRemision.IdGuiaRemisionEstado = 4 WHERE ERP.GuiaRemision.ID = @IdGuiaRemision
SELECT 0 

END
