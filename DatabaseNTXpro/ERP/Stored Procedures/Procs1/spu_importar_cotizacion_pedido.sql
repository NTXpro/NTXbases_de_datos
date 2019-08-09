
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [ERP].[spu_importar_cotizacion_pedido]
	 @IdCotizacion INT,
     @IdPedido INT
AS
BEGIN
DECLARE  @Fecha datetime

SELECT @Fecha = c.Fecha FROM ERP.Comprobante c WHERE c.id = @IdCotizacion


DECLARE  @seriep char(4)
DECLARE @idempresap int 

SELECT @seriep= p.Serie, @idempresap= p.IdEmpresa FROM ERP.Pedido p WHERE p.id =@IdPedido
DECLARE @Documentop varchar(30)
SELECT @Documentop= (CASE WHEN p.Documento IS NULL THEN '' ELSE P.DOCUMENTO END)   FROM ERP.Pedido p WHERE p.ID = @IdPedido
IF @Documentop = ''
BEGIN
SET @Documentop = (SELECT [ERP].[GenerarDocumentoPedido](@seriep,@IdPedido,@idempresap))
END



------------------------------- INSERTAR DATOS DE CABECERA DE LA COTIZACION  ------------------------------------------
UPDATE ERP.Pedido
SET
    --ID - column value is auto-generated
    
    --ERP.Pedido.IdTipoComprobante = A.IdTipoComprobante, -- int
    ERP.Pedido.IdCliente = A.IdCliente, -- int
    ERP.Pedido.IdProyecto = A.IdProyecto, -- int
    ERP.Pedido.IdVendedor = A.IdVendedor, -- int
    ERP.Pedido.IdAlmacen = A.IdAlmacen, -- int
    ERP.Pedido.IdMoneda = A.IdMoneda, -- int
    ERP.Pedido.IdListaPrecio = A.IdListaPrecio, -- int
    ERP.Pedido.IdEstablecimiento = A.IdEstablecimiento, -- int
    ERP.Pedido.IdDetraccion = A.IdDetraccion, -- int
    --ERP.Pedido.Serie = A.Serie, -- char
    ERP.Pedido.Documento =  @Documentop, -- varchar
    --ERP.Pedido.SerieDocumento = A.SerieDocumento, -- varchar
  
    ERP.Pedido.DiasVencimiento = A.DiasVencimiento, -- int
    ERP.Pedido.FechaVencimiento = A.FechaVencimiento, -- datetime
    ERP.Pedido.Observacion = A.Observacion, -- varchar
    ERP.Pedido.TipoCambio = A.TipoCambio, -- decimal
    ERP.Pedido.PorcentajeIGV = A.PorcentajeIGV, -- decimal
    ERP.Pedido.PorcentajeDescuento = A.PorcentajeDescuento, -- decimal
    ERP.Pedido.PorcentajePercepcion = A.PorcentajePercepcion, -- decimal
    ERP.Pedido.PorcentajeDetraccion = A.PorcentajeDetraccion, -- decimal
    ERP.Pedido.TotalDetalleISC = A.TotalDetalleISC, -- decimal
    ERP.Pedido.TotalDetalleAfecto = A.TotalDetalleAfecto, -- decimal
    ERP.Pedido.TotalDetalleInafecto = A.TotalDetalleInafecto, -- decimal
    ERP.Pedido.TotalDetalleExportacion = A.TotalDetalleExportacion, -- decimal
    ERP.Pedido.TotalDetalleGratuito = A.TotalDetalleGratuito, -- decimal
    ERP.Pedido.TotalDetalle = A.TotalDetalle, -- decimal
    ERP.Pedido.ImporteDetraccion = A.ImporteDetraccion, -- decimal
    ERP.Pedido.TotalDetraccion = A.TotalDetraccion, -- decimal
    ERP.Pedido.ImporteDescuento = A.ImporteDescuento, -- decimal
    ERP.Pedido.SubTotal = A.SubTotal, -- decimal
    ERP.Pedido.IGV = A.IGV, -- decimal
    ERP.Pedido.Total = A.TOTAL, -- decimal
    ERP.Pedido.ISC = A.ISC, -- decimal
    ERP.Pedido.ImportePercepcion = A.ImportePercepcion, -- decimal
    ERP.Pedido.TotalPercepcion = A.TotalPercepcion, -- decimal
    ERP.Pedido.FlagExportacion = A.FlagExportacion, -- bit
    ERP.Pedido.FlagPercepcion = A.FlagPercepcion, -- bit
    ERP.Pedido.FlagDetraccion = A.FlagDetraccion, -- bit
    ERP.Pedido.FlagAnticipo = A.FlagAnticipo, -- bit
    ERP.Pedido.IdEstablecimientoCliente = A.IdEstablecimientoCliente -- int
	FROM
	(SELECT   p.IdCliente, p.IdProyecto, p.IdVendedor, p.IdAlmacen, p.IdMoneda, p.IdListaPrecio, 
	 p.IdEstablecimiento, p.IdDetraccion,  p.DiasVencimiento, p.FechaVencimiento,
	 p.Observacion, p.TipoCambio, p.PorcentajeIGV, p.PorcentajeDescuento, p.PorcentajePercepcion, p.PorcentajeDetraccion, 
	 p.TotalDetalleISC, p.TotalDetalleAfecto, p.TotalDetalleInafecto, p.TotalDetalleExportacion, p.TotalDetalleGratuito,
	 p.TotalDetalle, p.ImporteDetraccion, p.TotalDetraccion, p.ImporteDescuento, p.SubTotal, p.IGV, p.Total, p.ISC, p.ImportePercepcion, 
	 p.TotalPercepcion, p.FlagExportacion, p.FlagPercepcion, p.FlagDetraccion, p.FlagAnticipo,p.IdEstablecimientoCliente 
	 FROM ERP.Cotizacion p WHERE p.ID= @IdCotizacion) A
	 WHERE ERP.Pedido.ID = @IdPedido



------------------------------- INSERTAR LAS REFERENCIAS DE LA COTIZACION  ------------------------------------------
DELETE  FROM ERP.PedidoReferencia  WHERE ERP.PedidoReferencia.IdPedido = @IdPedido


DECLARE @documento_gr varchar(100)
DECLARE @serie_gr varchar(100)
DECLARE @IdProducto int
DECLARE @IdReferenciaOrigen INT
DECLARE @IdReferencia INT 
DECLARE @IdTipoComprobante INT
DECLARE @Serie varchar(100)
DECLARE @Documento varchar(100)
DECLARE @FlagInterno bit

--------------- INSERTAR LA COTIZACION COMO REFERENCIA AL PEDIDO
SELECT @serie_gr = gr.Serie,@documento_gr =  gr.Documento FROM  erp.Cotizacion  gr WHERE id = @idCotizacion

INSERT ERP.PedidoReferencia
 ( IdPedido, IdReferenciaOrigen, IdReferencia, IdTipoComprobante, Serie, Documento, FlagInterno)
VALUES
( @IdPedido, 3, @idCotizacion, 195, @serie_gr, @documento_gr,  1 )
   
--------------- INSERTAR LAS REFERENCIAS DE LA COTIZACION A LAS REFERENCIAS DEL PEDIDO
DECLARE ProdInfo CURSOR FOR SELECT  grr.IdReferencia, grr.IdTipoComprobante, grr.Serie,
									grr.Documento, grr.FlagInterno FROM  ERP.CotizacionReferencia  grr WHERE  grr.IdCotizacion = @IdCotizacion
OPEN ProdInfo
FETCH NEXT FROM ProdInfo INTO  @IdReferencia, @IdTipoComprobante, @Serie,@Documento,@FlagInterno
WHILE @@fetch_status = 0
BEGIN
    INSERT ERP.PedidoReferencia    
( IdPedido,  IdReferencia, IdTipoComprobante, Serie, Documento, FlagInterno)
VALUES
( @IdPedido, @IdReferencia, @IdTipoComprobante, @Serie, @Documento,  @FlagInterno )
    FETCH NEXT FROM ProdInfo INTO  @IdReferencia, @IdTipoComprobante, @Serie,@Documento,@FlagInterno
END
CLOSE ProdInfo
DEALLOCATE ProdInfo

--------------- INSERTAR LOS DETALLES (ITEMS) DE LA COTIZACION AL PEDIDO ------------------------------------------

DELETE FROM ERP.PedidoDetalle WHERE ERP.PedidoDetalle.IdPedido = @IdPedido

DECLARE @idCotizacionDetalle int 
DECLARE ProdInfo CURSOR FOR SELECT id FROM ERP.CotizacionDetalle cd WHERE cd.IdCotizacion = @IdCotizacion
OPEN ProdInfo
FETCH NEXT FROM ProdInfo INTO @idCotizacionDetalle
WHILE @@fetch_status = 0
BEGIN
	INSERT INTO ERP.PedidoDetalle
(
    --ID - column value is auto-generated
    IdPedido, IdProducto, Nombre, Cantidad, PorcentajeDescuento, PorcentajeISC, PrecioPromedio, PrecioUnitarioLista,
    PrecioUnitarioListaSinIGV, PrecioUnitarioValorISC,  PrecioUnitarioISC, PrecioUnitarioDescuento, PrecioUnitarioSubTotal,
    PrecioUnitarioIGV, PrecioUnitarioTotal,PrecioLista,PrecioDescuento,PrecioSubTotal,PrecioIGV, PrecioTotal, FechaRegistro,
    FechaEliminado, FlagBorrador, Flag, FlagAfecto, FlagISC, FlagOtrosImpuesto, FlagGratuito, FechaModificado, UsuarioRegistro,
    UsuarioModifico, UsuarioElimino, UsuarioActivo, FechaActivacion, NumeroLote, Fecha)
 SELECT  @IdPedido, IdProducto, Nombre, Cantidad, PorcentajeDescuento, PorcentajeISC, PrecioPromedio, PrecioUnitarioLista,
    PrecioUnitarioListaSinIGV, PrecioUnitarioValorISC,  PrecioUnitarioISC, PrecioUnitarioDescuento, PrecioUnitarioSubTotal,
    PrecioUnitarioIGV, PrecioUnitarioTotal,PrecioLista,PrecioDescuento,PrecioSubTotal,PrecioIGV, PrecioTotal, FechaRegistro,
    FechaEliminado, FlagBorrador, Flag, FlagAfecto, FlagISC, FlagOtrosImpuesto, FlagGratuito, FechaModificado, UsuarioRegistro,
    UsuarioModifico, UsuarioElimino, UsuarioActivo, FechaActivacion, NumeroLote, Fecha FROM erp.CotizacionDetalle  WHERE Id =@idCotizacionDetalle			

    FETCH NEXT FROM ProdInfo INTO @idCotizacionDetalle
END
CLOSE ProdInfo
DEALLOCATE ProdInfo


-------------------------------- CAMBIO EL ESTATUS DE LA FACTURA SI LA MISMA ES NUEVA  ------------------------------------------
IF  EXISTS(SELECT * from  ERP.Pedido  c WHERE  c.id = @IdPedido  AND c.flagborrador = 1)
BEGIN
	UPDATE ERP.pedido  SET    ERP.Pedido.flagborrador = 0 WHERE  id =@IdPedido
END
 
 UPDATE ERP.Cotizacion
 SET
         ERP.Cotizacion.IdCotizacionEstado = 4 WHERE  ERP.Cotizacion.ID = @IdCotizacion
 SELECT 0

END


