CREATE PROC [ERP].[Usp_Del_Data_DataBase]
AS
BEGIN

--ALTER DATABASE [BD_ERP_CLEAN]
--SET RECOVERY SIMPLE
--DBCC SHRINKFILE(BD_ERP_log, 1);
--ALTER DATABASE [BD_ERP_CLEAN]
--SET RECOVERY FULL

DELETE FROM ERP.OrdenServicioDetalle
DBCC CHECKIDENT ('[ERP].[OrdenServicioDetalle]', RESEED,0)

DELETE FROM ERP.OrdenServicioReferencia
DBCC CHECKIDENT ('[ERP].[OrdenServicioReferencia]', RESEED,0)

DELETE FROM ERP.OrdenServicio
DBCC CHECKIDENT ('[ERP].[OrdenServicio]', RESEED,0)


DELETE FROM ERP.OrdenPago
DBCC CHECKIDENT ('[ERP].[OrdenPago]', RESEED,0)

DELETE FROM [ERP].[AjusteCuentaPagar]
DBCC CHECKIDENT ('[ERP].[AjusteCuentaPagar]', RESEED,0)


DELETE FROM [ERP].[AjusteCuentaCobrar]
DBCC CHECKIDENT ('[ERP].[AjusteCuentaCobrar]', RESEED,0)

DELETE FROM [Maestro].[Grado] WHERE IdEmpresa > 1

DELETE FROM [PLAME].[T14EntidadPrestadorasDeSalud] WHERE ID > 5
DBCC CHECKIDENT ('[PLAME].[T14EntidadPrestadorasDeSalud]', RESEED,5)

DELETE FROM [ERP].[ImportacionServicioDetalle]
DBCC CHECKIDENT ('[ERP].[ImportacionServicioDetalle]', RESEED,0)

DELETE FROM [ERP].[ImportacionProductoDetalle]
DBCC CHECKIDENT ('[ERP].[ImportacionProductoDetalle]', RESEED,0)

DELETE FROM [ERP].[ImportacionReferencia]
DBCC CHECKIDENT ('[ERP].[ImportacionReferencia]', RESEED,0)

DELETE FROM [ERP].[Importacion]
DBCC CHECKIDENT ('[ERP].[Importacion]', RESEED,0)

delete from [ERP].[PlanillaHojaTrabajo]
DBCC CHECKIDENT ('[ERP].[PlanillaHojaTrabajo]', RESEED, 0);

delete from [ERP].[PlanillaPago]
DBCC CHECKIDENT ('[ERP].[PlanillaPago]', RESEED, 0);

DELETE FROM [ERP].[PlanillaCabecera]
DBCC CHECKIDENT ('[ERP].[PlanillaCabecera]', RESEED, 0);

delete from ERP.TrabajadorCuenta
DBCC CHECKIDENT ('ERP.TrabajadorCuenta', RESEED, 0);

delete from ERP.TrabajadorFamilia
DBCC CHECKIDENT ('ERP.TrabajadorFamilia', RESEED, 0);

delete from ERP.LetraPagarCuentaPagar
DBCC CHECKIDENT ('ERP.LetraPagarCuentaPagar', RESEED, 0);

delete from ERP.LetraPagar
DBCC CHECKIDENT ('ERP.LetraPagar', RESEED, 0);

delete from ERP.LetraCobrarCuentaCobrar
DBCC CHECKIDENT ('ERP.LetraCobrarCuentaCobrar', RESEED, 0);

delete from ERP.LetraCobrar
DBCC CHECKIDENT ('ERP.LetraCobrar', RESEED, 0);

delete from [ERP].[MovimientoTransferenciaMasivaCuentaDetalle]
DBCC CHECKIDENT ('[ERP].[MovimientoTransferenciaMasivaCuentaDetalle]', RESEED, 0);

delete from [ERP].[MovimientoTransferenciaMasivaCuenta]
DBCC CHECKIDENT ('[ERP].[MovimientoTransferenciaMasivaCuenta]', RESEED, 0);

delete from erp.UtilidadDetalle
DBCC CHECKIDENT ('[ERP].[UtilidadDetalle]', RESEED, 0);

delete from erp.Utilidad
DBCC CHECKIDENT ('[ERP].[Utilidad]', RESEED, 0);

delete from erp.LetraCobrar
DBCC CHECKIDENT ('[ERP].[LetraCobrar]', RESEED, 0);

delete from erp.LetraPagar
DBCC CHECKIDENT ('[ERP].[LetraPagar]', RESEED, 0);

delete from erp.TrabajadorPension
DBCC CHECKIDENT ('[ERP].[TrabajadorPension]', RESEED, 0);

delete from erp.DatoLaboralSuspension
DBCC CHECKIDENT ('[ERP].[DatoLaboralSuspension]', RESEED, 0);

delete from erp.DatoLaboralPrestamo
DBCC CHECKIDENT ('[ERP].[DatoLaboralPrestamo]', RESEED, 0);

delete from erp.DatoLaboralAdelanto
DBCC CHECKIDENT ('[ERP].[DatoLaboralAdelanto]', RESEED, 0);

delete from erp.DatoLaboralConceptoFijo
DBCC CHECKIDENT ('[ERP].[DatoLaboralConceptoFijo]', RESEED, 0);

delete from erp.SCTR
DBCC CHECKIDENT ('[ERP].[SCTR]', RESEED, 0);

delete from erp.PedidoReferencia
DBCC CHECKIDENT ('[ERP].[PedidoReferencia]', RESEED, 0);

delete from erp.PedidoDetalle
DBCC CHECKIDENT ('[ERP].[PedidoDetalle]', RESEED, 0);

delete from erp.Pedido
DBCC CHECKIDENT ('[ERP].[Pedido]', RESEED, 0);

delete from erp.Contrato
DBCC CHECKIDENT ('[ERP].[Contrato]', RESEED, 0);

delete from erp.DatoLaboralSalud
DBCC CHECKIDENT ('[ERP].[DatoLaboralSalud]', RESEED, 0);

delete from erp.GuiaRemisionReferencia
DBCC CHECKIDENT ('[ERP].[GuiaRemisionReferencia]', RESEED, 0);

delete from erp.GuiaRemisionDetalle
DBCC CHECKIDENT ('[ERP].[GuiaRemisionDetalle]', RESEED, 0);

delete from erp.GuiaRemision
DBCC CHECKIDENT ('[ERP].[GuiaRemision]', RESEED, 0);

delete from erp.CTSDetalle
DBCC CHECKIDENT ('[ERP].[CTSDetalle]', RESEED, 0);

delete from erp.CTS
DBCC CHECKIDENT ('[ERP].[CTS]', RESEED, 0);

delete from erp.LiquidacionDetalle
DBCC CHECKIDENT ('[ERP].[LiquidacionDetalle]', RESEED, 0);

delete from erp.Liquidacion
DBCC CHECKIDENT ('[ERP].[Liquidacion]', RESEED, 0);

delete from erp.GratificacionDetalle
DBCC CHECKIDENT ('[ERP].[GratificacionDetalle]', RESEED, 0);

delete from erp.Gratificacion
DBCC CHECKIDENT ('[ERP].[Gratificacion]', RESEED, 0);

delete from erp.Vacacion
DBCC CHECKIDENT ('[ERP].[Vacacion]', RESEED, 0);

delete from erp.DatoLaboralDetalle
DBCC CHECKIDENT ('[ERP].[DatoLaboralDetalle]', RESEED, 0);

delete from erp.DatoLaboral
DBCC CHECKIDENT ('[ERP].[DatoLaboral]', RESEED, 0);

delete from erp.CotizacionReferencia
DBCC CHECKIDENT ('[ERP].[CotizacionReferencia]', RESEED, 0);

delete from erp.CotizacionDetalle
DBCC CHECKIDENT ('[ERP].[CotizacionDetalle]', RESEED, 0);

delete from erp.Cotizacion
DBCC CHECKIDENT ('[ERP].[Cotizacion]', RESEED, 0);


DELETE FROM [ERP].[Chofer];
DBCC CHECKIDENT ('[ERP].[Chofer]', RESEED, 0);

DELETE FROM [ERP].[Vehiculo];
DBCC CHECKIDENT ('[ERP].[Vehiculo]', RESEED, 0);

DELETE FROM [ERP].[Transporte];
DBCC CHECKIDENT ('[ERP].[Transporte]', RESEED, 0);


DELETE FROM [ERP].[TransformacionDestinoDetalle];
DBCC CHECKIDENT ('[ERP].[TransformacionDestinoDetalle]', RESEED, 0);

DELETE FROM [ERP].[TransformacionMermaDetalle];
DBCC CHECKIDENT ('[ERP].[TransformacionMermaDetalle]', RESEED, 0);

DELETE FROM [ERP].[TransformacionOrigenDetalle];
DBCC CHECKIDENT ('[ERP].[TransformacionOrigenDetalle]', RESEED, 0);

DELETE FROM [ERP].[TransformacionServicioDetalle];
DBCC CHECKIDENT ('[ERP].[TransformacionServicioDetalle]', RESEED, 0);

DELETE FROM [ERP].[Transformacion];
DBCC CHECKIDENT ('[ERP].[Transformacion]', RESEED, 0);

delete from erp.ValeReferencia
DBCC CHECKIDENT ('[ERP].[ValeReferencia]', RESEED, 0);

delete from erp.ValeDetalle
DBCC CHECKIDENT ('[ERP].[ValeDetalle]', RESEED, 0);

delete from erp.vale
DBCC CHECKIDENT ('[ERP].[vale]', RESEED, 0);

delete from erp.ValeTransferenciaReferencia
DBCC CHECKIDENT ('[ERP].[ValeTransferenciaReferencia]', RESEED, 0);

delete from erp.ValeTransferenciaDetalle
DBCC CHECKIDENT ('[ERP].[ValeTransferenciaDetalle]', RESEED, 0);

delete from erp.ValeTransferencia
DBCC CHECKIDENT ('[ERP].[ValeTransferencia]', RESEED, 0);

DELETE FROM [ERP].[FamiliaProducto]
DBCC CHECKIDENT ('[ERP].[FamiliaProducto]', RESEED, 0);

DELETE FROM [ERP].[Familia] WHERE ID > 3
DBCC CHECKIDENT ('[ERP].[Familia]', RESEED, 3);

DELETE FROM [ERP].[EstructuraCuatro] WHERE ID > 171
DBCC CHECKIDENT ('[ERP].[EstructuraCuatro]', RESEED, 171);

DELETE FROM [ERP].[EstructuraTres] WHERE ID > 165
DBCC CHECKIDENT ('[ERP].[EstructuraTres]', RESEED, 165);

DELETE FROM [ERP].[EstructuraDos] WHERE ID > 17
DBCC CHECKIDENT ('[ERP].[EstructuraDos]', RESEED, 17);

DELETE FROM [ERP].[EstructuraUno] WHERE ID > 5
DBCC CHECKIDENT ('[ERP].[EstructuraUno]', RESEED, 5);

DELETE FROM [ERP].[ValeDetalle]
DBCC CHECKIDENT ('[ERP].[ValeDetalle]', RESEED, 0);

DELETE FROM [ERP].[Vale]
DBCC CHECKIDENT ('[ERP].[Vale]', RESEED, 0);

DELETE FROM [PLE].[T12TipoOperacion] WHERE ID > 47
DBCC CHECKIDENT ('[PLE].[T12TipoOperacion]', RESEED, 47);

DELETE FROM [ERP].[Talonario]
DBCC CHECKIDENT ('[ERP].[Talonario]', RESEED, 0);

DELETE FROM [ERP].[AnticipoCompraCuentaPagar]
DBCC CHECKIDENT ('[ERP].[AnticipoCompraCuentaPagar]', RESEED, 0);

DELETE FROM [ERP].[AnticipoVentaCuentaCobrar]
DBCC CHECKIDENT ('[ERP].[AnticipoVentaCuentaCobrar]', RESEED, 0);

DELETE FROM [ERP].[GastoCuentaPagar]
DBCC CHECKIDENT ('[ERP].[GastoCuentaPagar]', RESEED, 0);


DELETE FROM [ERP].[CuentaPagar]
DBCC CHECKIDENT ('[ERP].[CuentaPagar]', RESEED, 0);


DELETE FROM [Maestro].[Grado] WHERE IdEmpresa > 1
--DBCC CHECKIDENT ('[Maestro].[Grado]', RESEED, 5);

DELETE FROM [Maestro].[Origen] WHERE ID > 17
DBCC CHECKIDENT ('[Maestro].[Origen]', RESEED, 17);

DELETE FROM [ERP].ResumenDiario
DBCC CHECKIDENT ('[ERP].[ResumenDiario]', RESEED, 0);

DELETE FROM [Seguridad].[PaginaRol] where idRol > 1
DECLARE @MaxIdPaginaRol INT = ISNULL((SELECT MAX(ID) FROM [Seguridad].[PaginaRol] where idRol = 1),0);
DBCC CHECKIDENT ('[Seguridad].[PaginaRol]', RESEED, @MaxIdPaginaRol);  

DELETE FROM [Seguridad].[UsuarioRol] where id > 1
DBCC CHECKIDENT ('[Seguridad].[UsuarioRol]', RESEED, 1);  

DELETE FROM [Seguridad].[Rol] where id > 1
DBCC CHECKIDENT ('[Seguridad].[Rol]', RESEED, 1);  

DELETE FROM [ERP].[Parametro] where id > 74
DBCC CHECKIDENT ('[ERP].[Parametro]', RESEED, 74);  

DELETE FROM [ERP].[CompraCuentaPagar]
DBCC CHECKIDENT ('[ERP].[CompraCuentaPagar]', RESEED, 0);  

DELETE FROM [ERP].[CuentaPagarMovimiento]
DBCC CHECKIDENT ('[ERP].[CuentaPagarMovimiento]', RESEED, 0);  

DELETE FROM [ERP].[Ubicacion]
DBCC CHECKIDENT ('[ERP].[Ubicacion]', RESEED, 0);  

DELETE FROM ERP.MovimientoTesoreriaDetalleCuentaCobrar
DBCC CHECKIDENT ('ERP.MovimientoTesoreriaDetalleCuentaCobrar', RESEED, 0);  

DELETE FROM ERP.SaldoInicialCuentaCobrar
DBCC CHECKIDENT ('ERP.SaldoInicialCuentaCobrar', RESEED, 0);  

DELETE FROM ERP.SaldoInicialCobrar
DBCC CHECKIDENT ('ERP.SaldoInicialCobrar', RESEED, 0);  

DELETE FROM [ERP].AplicacionAnticipoCobrarDetalle
DBCC CHECKIDENT ('[ERP].[AplicacionAnticipoCobrarDetalle]', RESEED, 0);  

DELETE FROM ERP.AplicacionAnticipoCobrar
DBCC CHECKIDENT ('ERP.AplicacionAnticipoCobrar', RESEED, 0);

DELETE FROM [ERP].[ComprobanteCuentaCobrar]
DBCC CHECKIDENT ('[ERP].[ComprobanteCuentaCobrar]', RESEED, 0);    

DELETE FROM [ERP].[CuentaCobrar]
DBCC CHECKIDENT ('[ERP].[CuentaCobrar]', RESEED, 0);  

DELETE FROM [ERP].[PeriodoSistema]
DBCC CHECKIDENT ('[ERP].[PeriodoSistema]', RESEED, 0);  

DELETE FROM ERP.SaldoInicialCuentaPagar
DBCC CHECKIDENT ('ERP.SaldoInicialCuentaPagar', RESEED,0)

DELETE FROM ERP.SaldoInicial
DBCC CHECKIDENT ('ERP.SaldoInicial', RESEED,0)

DELETE FROM ERP.SaldoInicialCuentaPagar
DBCC CHECKIDENT ('ERP.SaldoInicialCuentaPagar', RESEED,0)

DELETE FROM ERP.CompraCuentaPagar
DBCC CHECKIDENT ('ERP.CompraCuentaPagar', RESEED,0)

DELETE FROM ERP.MovimientoTesoreriaDetalleCuentaPagar
DBCC CHECKIDENT ('ERP.MovimientoTesoreriaDetalleCuentaPagar', RESEED,0)

DELETE ERP.AplicacionAnticipoPagarDetalle
DBCC CHECKIDENT ('ERP.AplicacionAnticipoPagarDetalle', RESEED,0)

DELETE  ERP.AplicacionAnticipoPagar
DBCC CHECKIDENT ('ERP.AplicacionAnticipoPagar', RESEED,0)

DELETE FROM ERP.CuentaPagar
DBCC CHECKIDENT ('ERP.CuentaPagar', RESEED,0)


DELETE FROM ERP.AsientoDetalle
DBCC CHECKIDENT ('ERP.AsientoDetalle', RESEED,0)


DELETE FROM ERP.ComprobanteDetalle
DBCC CHECKIDENT ('ERP.ComprobanteDetalle', RESEED,0)

DELETE FROM ERP.ComprobanteReferencia
DBCC CHECKIDENT ('ERP.ComprobanteReferencia', RESEED,0)

DELETE FROM ERP.ComprobanteReferenciaInterno
DBCC CHECKIDENT ('ERP.ComprobanteReferenciaInterno', RESEED,0)

DELETE FROM ERP.ComprobanteReferenciaExterno
DBCC CHECKIDENT ('ERP.ComprobanteReferenciaExterno', RESEED,0)

DELETE FROM ERP.Comprobante
DBCC CHECKIDENT ('erp.Comprobante', RESEED,0)

DELETE FROM ERP.CompraReferencia
DBCC CHECKIDENT ('ERP.CompraReferencia', RESEED,0)

DELETE FROM ERP.CompraReferenciaInterna
DBCC CHECKIDENT ('ERP.CompraReferenciaInterna', RESEED,0)

DELETE FROM ERP.CompraReferenciaExterna
DBCC CHECKIDENT ('ERP.CompraReferenciaExterna', RESEED,0)

DELETE FROM ERP.CompraObservacion
DBCC CHECKIDENT ('ERP.CompraObservacion', RESEED,0)

DELETE FROM ERP.CompraDetalle
DBCC CHECKIDENT ('ERP.CompraDetalle', RESEED,0)

DELETE FROM ERP.CompraDetraccion
DBCC CHECKIDENT ('ERP.CompraDetraccion', RESEED,0)

DELETE FROM ERP.Percepcion
DBCC CHECKIDENT ('ERP.Percepcion', RESEED,0)

DELETE FROM ERP.Percepcion
DBCC CHECKIDENT ('ERP.Percepcion', RESEED,0)

DELETE FROM ERP.CompraReferencia
DBCC CHECKIDENT ('ERP.CompraReferencia', RESEED,0)


DELETE FROM ERP.Compra
DBCC CHECKIDENT ('ERP.Compra', RESEED,0)

DELETE FROM ERP.Asiento
DBCC CHECKIDENT ('ERP.Asiento', RESEED,0)


DELETE FROM [ERP].[MovimientoConciliacionPendiente]
DBCC CHECKIDENT ('[ERP].[MovimientoConciliacionPendiente]', RESEED, 0);  

DELETE FROM [ERP].[MovimientoConciliacion]
DBCC CHECKIDENT ('[ERP].[MovimientoConciliacion]', RESEED, 0);  

DELETE FROM [ERP].[MovimientoRendirCuentaDetalle]
DBCC CHECKIDENT ('[ERP].[MovimientoRendirCuentaDetalle]', RESEED, 0);  

DELETE FROM [ERP].[MovimientoRendirCuenta]
DBCC CHECKIDENT ('[ERP].[MovimientoRendirCuenta]', RESEED, 0);  

DELETE FROM [ERP].[MovimientoCajaChicaDetalle]
DBCC CHECKIDENT ('[ERP].[MovimientoCajaChicaDetalle]', RESEED, 0);  

DELETE FROM [ERP].[MovimientoCajaChica]
DBCC CHECKIDENT ('[ERP].[MovimientoCajaChica]', RESEED, 0);  

DELETE FROM [ERP].[MovimientoTransferenciaCuenta]
DBCC CHECKIDENT ('[ERP].[MovimientoTransferenciaCuenta]', RESEED, 0);  

DELETE FROM [ERP].[MovimientoTesoreriaDetalleCuentaPagar]
DBCC CHECKIDENT ('[ERP].[MovimientoTesoreriaDetalleCuentaPagar]', RESEED, 0);  

DELETE FROM [ERP].[MovimientoTesoreriaDetalleCuentaCobrar]
DBCC CHECKIDENT ('[ERP].[MovimientoTesoreriaDetalleCuentaCobrar]', RESEED, 0);  

DELETE FROM [ERP].[MovimientoTesoreriaDetalle]
DBCC CHECKIDENT ('[ERP].[MovimientoTesoreriaDetalle]', RESEED, 0);  

DELETE FROM [ERP].[MovimientoTesoreria]
DBCC CHECKIDENT ('[ERP].[MovimientoTesoreria]', RESEED, 0);  

DELETE FROM [ERP].[Cuenta]
DBCC CHECKIDENT ('[ERP].[Cuenta]', RESEED, 0);  

DELETE FROM [ERP].[Almacen] WHERE ID > 1
DBCC CHECKIDENT ('[ERP].[Almacen]', RESEED, 1);  

DELETE FROM ERP.OrdenCompraDetalle
DBCC CHECKIDENT ('[ERP].[OrdenCompraDetalle]', RESEED, 0);  

DELETE FROM ERP.OrdenCompraReferencia
DBCC CHECKIDENT ('[ERP].[OrdenCompraReferencia]', RESEED, 0);  

DELETE FROM ERP.OrdenCompra
DBCC CHECKIDENT ('[ERP].[OrdenCompra]', RESEED, 0);  

DELETE FROM [ERP].[Proveedor]
DBCC CHECKIDENT ('[ERP].[Proveedor]', RESEED, 0);  

DELETE FROM ERP.EmpresaUsuario WHERE ID > 1
DBCC CHECKIDENT ('ERP.EmpresaUsuario', RESEED, 1);  

DELETE FROM Seguridad.Usuario WHERE ID > 1
DBCC CHECKIDENT ('Seguridad.Usuario', RESEED, 1);  

DELETE FROM ERP.Cliente WHERE ID > 1
DBCC CHECKIDENT ('ERP.Cliente', RESEED, 1);  

DELETE FROM ERP.Vendedor
DBCC CHECKIDENT ('ERP.Vendedor', RESEED, 0);  

DELETE FROM ERP.Trabajador
DBCC CHECKIDENT ('ERP.Trabajador', RESEED, 0); 

DELETE FROM ERP.PlanCuentaDestino WHERE IdEmpresa > 1

DELETE FROM [ERP].[ListaPrecioDetalle]
DBCC CHECKIDENT ('[ERP].[ListaPrecioDetalle]', RESEED, 0);  

DELETE FROM [ERP].[ListaPrecio] where id > 2
DBCC CHECKIDENT ('[ERP].[ListaPrecio]', RESEED, 2); 

DELETE FROM ERP.TransformacionDestinoDetalle
DBCC CHECKIDENT ('ERP.TransformacionDestinoDetalle', RESEED, 0);   

DELETE FROM ERP.TransformacionOrigenDetalle
DBCC CHECKIDENT ('ERP.TransformacionOrigenDetalle', RESEED, 0);  

DELETE FROM ERP.TransformacionMermaDetalle
DBCC CHECKIDENT ('ERP.TransformacionMermaDetalle', RESEED, 0);  

DELETE FROM ERP.ProductoPropiedad
DBCC CHECKIDENT ('ERP.ProductoPropiedad', RESEED, 0);  

DELETE FROM ERP.RecetaProductoDetalle
DBCC CHECKIDENT ('ERP.Producto', RESEED, 0);

DELETE FROM ERP.Producto 
DBCC CHECKIDENT ('ERP.Producto', RESEED, 0);  

DELETE FROM ERP.RequerimientoReferencia
DBCC CHECKIDENT ('ERP.RequerimientoReferencia', RESEED, 0);   

DELETE FROM ERP.RequerimientoDetalle
DBCC CHECKIDENT ('ERP.RequerimientoDetalle', RESEED, 0);

DELETE FROM ERP.Requerimiento
DBCC CHECKIDENT ('ERP.Requerimiento', RESEED, 0);   

DELETE FROM ERP.Proyecto
DBCC CHECKIDENT ('ERP.Proyecto', RESEED, 0);  
 
DELETE FROM ERP.Operacion WHERE IdEmpresa > 1


DELETE FROM [ERP].[TipoComprobantePlanCuenta] WHERE IdEmpresa > 1 

DELETE FROM ERP.PlanCuenta where IdEmpresa > 1

DELETE FROM ERP.Empresa WHERE ID > 1
DBCC CHECKIDENT ('ERP.Empresa', RESEED, 1);  

--DELETE FROM ERP.AFP
--DBCC CHECKIDENT ('ERP.AFP', RESEED, 0);  

DELETE FROM ERP.EntidadTipoDocumento WHERE ID > 45
DBCC CHECKIDENT ('ERP.EntidadTipoDocumento', RESEED, 45);  

DELETE FROM ERP.Persona  WHERE ID > 2
DBCC CHECKIDENT ('ERP.Persona', RESEED, 2);  

DELETE FROM ERP.Establecimiento  WHERE ID > 45
DBCC CHECKIDENT ('ERP.Establecimiento', RESEED, 45);  

DELETE FROM ERP.Entidad  WHERE ID > 45
DBCC CHECKIDENT ('ERP.Entidad', RESEED, 45);  

DELETE FROM [PLE].[T3Banco]  WHERE ID > 39
DBCC CHECKIDENT ('[PLE].[T3Banco]', RESEED, 39);  

DELETE FROM [Maestro].[Marca] WHERE ID > 2
DBCC CHECKIDENT ('[Maestro].[Marca]', RESEED, 2);  

DELETE FROM [PLE].[T5Existencia] WHERE ID > 19
DBCC CHECKIDENT ('[PLE].[T5Existencia]', RESEED, 19);  

DELETE FROM [PLE].[T12TipoOperacion] where id > 27
DBCC CHECKIDENT ('[PLE].[T12TipoOperacion]', RESEED, 27);  

DELETE FROM [Maestro].[Propiedad]
DBCC CHECKIDENT ('[Maestro].[Propiedad]', RESEED, 0);  

DELETE FROM [PLE].[T6UnidadMedida] WHERE ID > 62
DBCC CHECKIDENT ('[PLE].[T6UnidadMedida]', RESEED, 62);  

DELETE FROM [ERP].[FormaPago] where id > 15
DBCC CHECKIDENT ('[ERP].[FormaPago]', RESEED, 15);  

DELETE FROM [Maestro].[Detraccion] WHERE ID > 27
DBCC CHECKIDENT ('[Maestro].[Detraccion]', RESEED, 27);  

END