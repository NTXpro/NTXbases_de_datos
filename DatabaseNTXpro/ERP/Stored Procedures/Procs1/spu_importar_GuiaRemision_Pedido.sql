--SELECT TOP 1 * FROM ERP.Pedido p
--SELECT TOP 1 * FROM ERP.GuiaRemision gr
---------------------------------------------
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ERP].[spu_importar_GuiaRemision_Pedido]
	  @IdPedido INT,
      @IdGuiaRemision INT
AS
BEGIN
	
	
DECLARE @Fecha datetime = '2019-07-10'
SELECT @Fecha = c.Fecha FROM ERP.GuiaRemision c WHERE c.id = @IdGuiaRemision

DECLARE @IGV int = (SELECT Valor FROM ERP.Parametro WHERE Abreviatura = 'IGV')

------------------------------- INSERTAR DATOS DE CABECERA DEL PEDIDO  ---------------

UPDATE ERP.GuiaRemision
SET
      ERP.GuiaRemision.IdVendedor = A.idvendedor, -- int
      ERP.GuiaRemision.IdAlmacen = A.IdAlmacen,
      ERP.GuiaRemision.IdEstablecimiento = A.IdEstablecimiento, 
	  ERP.GuiaRemision.IdListaPrecio = A.IdListaPrecio,
	  ERP.GuiaRemision.IdMoneda= A.IdMoneda,
	--  ERP.Comprobante.IdVale = A.IdVale,
	  ERP.GuiaRemision.igv = A.igv, 
	  ERP.GuiaRemision.Observacion = A.Observacion, 
	  ERP.GuiaRemision.PorcentajeIGV = @IGV, 
	  ERP.GuiaRemision.SubTotal = A.SubTotal, 
	  ERP.GuiaRemision.TipoCambio = A.TipoCambio,
	  ERP.GuiaRemision.Total = A.Total
FROM (SELECT gr.IdAlmacen, gr.IdEstablecimiento, gr.IdListaPrecio,gr.IdMoneda, gr.IdVendedor, gr.igv, gr.Observacion,
			 gr.PorcentajeIGV, gr.SubTotal, gr.TipoCambio ,gr.Total
			 FROM ERP.Pedido gr
WHERE gr.id = @IdPedido) A
WHERE ERP.GuiaRemision.id =@IdGuiaRemision


------------------------------- INSERTAR LAS REFERENCIAS DE LA GUIA DE REMISION  -----------------------------
DELETE FROM ERP.GuiaRemisionReferencia WHERE ERP.GuiaRemisionReferencia.IdGuiaRemision = @IdGuiaRemision

DECLARE @documento_gr varchar(100)
DECLARE @serie_gr varchar(100)
DECLARE @IdProducto int
DECLARE @IdReferenciaOrigen INT
DECLARE @IdReferencia INT 
DECLARE @IdTipoComprobante INT
DECLARE @Serie varchar(100)
DECLARE @Documento varchar(100)
DECLARE @FlagInterno bit

--------------- INSERTAR PEDIDO COMO UNA REFERENCIA -----------------------------------------------------------
SELECT @serie_gr = gr.Serie,@documento_gr =  gr.Documento FROM  erp.pedido gr WHERE id = @Idpedido
 INSERT ERP.GuiaRemisionReferencia ( IdGuiaRemision, IdReferenciaOrigen, IdReferencia, IdTipoComprobante, Serie, Documento, FlagInterno)
VALUES( @IdGuiaRemision, 3, @IdPedido, 196, @serie_gr, @documento_gr,  1 )

   
--------------- INSERTAR LAS REFERENCIAS ----------------------------------------------------------------------
DECLARE ProdInfo CURSOR FOR SELECT  grr.IdReferenciaOrigen, grr.IdReferencia, grr.IdTipoComprobante, grr.Serie,
									grr.Documento, grr.FlagInterno FROM  ERP.PedidoReferencia  grr WHERE  grr.IdPedido = @IdPedido
OPEN ProdInfo
FETCH NEXT FROM ProdInfo INTO @IdReferenciaOrigen, @IdReferencia, @IdTipoComprobante, @Serie,@Documento,@FlagInterno
WHILE @@fetch_status = 0
BEGIN
    INSERT ERP.GuiaRemisionReferencia
( IdGuiaRemision, IdReferenciaOrigen, IdReferencia, IdTipoComprobante, Serie, Documento, FlagInterno)
VALUES
( @IdGuiaRemision, @IdReferenciaOrigen, @IdReferencia, @IdTipoComprobante, @Serie, @Documento,  @FlagInterno )
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

DELETE FROM ERP.GuiaRemisionDetalle WHERE ERP.GuiaRemisionDetalle.IdGuiaRemision = @IdGuiaRemision

DECLARE ProdInfo CURSOR FOR SELECT  grd.IdProducto, grd.Nombre, grd.Cantidad, grd.PrecioIGV, grd.PrecioLista, grd.PrecioSubTotal, grd.PrecioTotal, grd.PrecioUnitarioIGV
									,grd.PrecioUnitarioTotal, grd.PrecioUnitarioSubTotal, grd.PrecioUnitarioISC, grd.PrecioUnitarioListaSinIGV, grd.PrecioUnitarioValorISC, grd.PrecioUnitarioLista,grd.FlagAfecto 
									FROM ERP.PedidoDetalle  grd WHERE grd.IdPedido = @IdPedido
OPEN ProdInfo
FETCH NEXT FROM ProdInfo INTO @IdProducto ,@Nombre ,@Cantidad ,@PrecioIGV,@PrecioLista,@PrecioSubTotal,@PrecioTotal,@PrecioUnitarioIGV,@PrecioUnitarioTotal,@PrecioUnitarioSubTotal,@PrecioUnitarioISC 
                                  ,@PrecioUnitarioListaSinIGV,@PrecioUnitarioValorISC,@PrecioUnitarioLista ,@FlagAfecto 
WHILE @@fetch_status = 0
BEGIN
					INSERT erp.guiaRemisionDetalle
					(   idguiaRemision,
						IdProducto,
						Nombre,
						Cantidad,
					--	PorcentajeDescuento,
						PorcentajeISC,
					--	PrecioPromedio,
						PrecioUnitarioLista,
						PrecioUnitarioListaSinIGV,
						PrecioUnitarioValorISC,
						PrecioUnitarioISC,
					--	PrecioUnitarioDescuento,
						PrecioUnitarioSubTotal,
						PrecioUnitarioIGV,
						PrecioUnitarioTotal,
						PrecioLista,
					--  PrecioDescuento,
						PrecioSubTotal,
						PrecioIGV,
						PrecioTotal,
					--	FechaRegistro,
					--	NumeroLote,
					--	Fecha,
						flagAfecto
					)
					VALUES
					(
						-- ID - bigint
						@IdGuiaRemision, -- IdComprobante - int
						@IdProducto, -- IdProducto - int
						@Nombre, -- Nombre - varchar
						@Cantidad, -- Cantidad - decimal
					--	0, -- PorcentajeDescuento - decimal
						0, -- PorcentajeISC - decimal
					--	0, -- PrecioPromedio - decimal
						@PrecioUnitarioLista, -- PrecioUnitarioLista - decimal
						0, -- PrecioUnitarioListaSinIGV - decimal
						@PrecioUnitarioValorISC, -- PrecioUnitarioValorISC - decimal
						@PrecioUnitarioISC, -- PrecioUnitarioISC - decimal
					--	0, -- PrecioUnitarioDescuento - decimal
						@PrecioUnitarioSubTotal, -- PrecioUnitarioSubTotal - decimal
						@PrecioUnitarioIGV, -- PrecioUnitarioIGV - decimal
						@PrecioUnitarioTotal, -- PrecioUnitarioTotal - decimal
						@PrecioLista, -- PrecioLista - decimal
					--	0, -- PrecioDescuento - decimal
						@PrecioSubTotal, -- PrecioSubTotal - decimal
						@PrecioIGV, -- PrecioIGV - decimal
						@PrecioTotal, -- PrecioTotal - decimal
					--	@Fecha, -- FechaRegistro - datetime
					--	@Lote, -- NumeroLote - varchar
					--	@Fecha, -- Fecha - datetime
						@FlagAfecto
					)

    FETCH NEXT FROM ProdInfo INTO @IdProducto ,@Nombre ,@Cantidad ,@PrecioIGV,@PrecioLista,@PrecioSubTotal,@PrecioTotal,@PrecioUnitarioIGV,@PrecioUnitarioTotal,@PrecioUnitarioSubTotal,@PrecioUnitarioISC 
                                  ,@PrecioUnitarioListaSinIGV,@PrecioUnitarioValorISC,@PrecioUnitarioLista ,@FlagAfecto 
END
CLOSE ProdInfo
DEALLOCATE ProdInfo
-- MARCAR EL PEDIDO COMO IMPORTADO
--UPDATE ERP.Pedido
--SET
--    ERP.Pedido.IdPedidoEstado =  4 WHERE id = @IdPedido -- int

SELECT 0 

END
