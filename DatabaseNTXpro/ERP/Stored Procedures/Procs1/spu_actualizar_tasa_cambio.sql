
CREATE PROCEDURE ERP.spu_actualizar_tasa_cambio
	@compra decimal(14,5),
	@venta decimal(14,5),
	@fecha datetime
AS
BEGIN
IF exists(SELECT TOP 1 tcd.ID FROM erp.TipoCambioDiario tcd WHERE tcd.Fecha = @fecha AND (tcd.VentaSunat <>@venta OR tcd.CompraSunat <> @compra ))
BEGIN
UPDATE ERP.TipoCambioDiario
SET
    ERP.TipoCambioDiario.Fecha = @fecha,
    ERP.TipoCambioDiario.VentaSunat = @venta, 
    ERP.TipoCambioDiario.CompraSunat = @compra, 
    ERP.TipoCambioDiario.VentaSBS = @venta, 
    ERP.TipoCambioDiario.CompraSBS = @compra, 
    ERP.TipoCambioDiario.VentaComercial = @venta, 
    ERP.TipoCambioDiario.CompraComercial = @compra, 
    ERP.TipoCambioDiario.FechaModificado = getdate(), 
    ERP.TipoCambioDiario.UsuarioRegistro = 'ExternalApp',
    ERP.TipoCambioDiario.UsuarioModifico = 'ExternalApp', 
    ERP.TipoCambioDiario.FechaRegistro = getdate() 
WHERE Fecha = @fecha
END
ELSE
BEGIN

INSERT ERP.TipoCambioDiario
(
    Fecha,
    VentaSunat,
    CompraSunat,
    VentaSBS,
    CompraSBS,
    VentaComercial,
    CompraComercial,
    FechaModificado,
    UsuarioRegistro,
    UsuarioModifico,
    FechaRegistro
)
VALUES
(
    
    @fecha, 
    @venta, 
    @compra, 
    @venta, 
    @compra, 
    @venta, 
    @compra, 
    getdate(), 
    'ExternalApp', 
    'ExternalApp', 
    getdate() 
)
END
END