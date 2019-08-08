CREATE PROC [ERP].[Usp_Sel_Pedido_By_ID] --8
@Id INT
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 5001886
	SET NOCOUNT ON;

	SELECT DISTINCT	C.ID,
			C.IdPedidoEstado,
			CE.Nombre Estado,
			C.IdTipoComprobante,
			TC.CodigoSunat CodigoSunatTipoComprobante,
			UPPER(TC.Nombre) NombreTipoComprobante,
			C.IdProyecto,
			C.IdVendedor,
			C.IdDetraccion,
			ENTV.Nombre NombreVendedor,
			C.IdAlmacen,
			A.Nombre NombreAlmacen,
			C.IdMoneda,
			M.Nombre NombreMoneda,
			C.IdListaPrecio,
			LP.Nombre NombreListaPrecio,
			C.Serie,
			C.Documento,
			C.Fecha,
			C.TipoCambio,
			C.PorcentajeIGV,
			C.PorcentajeDescuento,
			C.PorcentajePercepcion,
			C.PorcentajeDetraccion,
			C.TotalDetalleISC,
			C.TotalDetalleAfecto,
			C.TotalDetalleInafecto,
			C.TotalDetalleExportacion,
			C.TotalDetalleGratuito,
			C.TotalDetalle,
			C.ImporteDescuento,
			C.SubTotal,
			C.IGV,
			C.Total,
			C.ImportePercepcion,
			C.TotalPercepcion,
			C.ImporteDetraccion,
			C.TotalDetraccion,
			C.IdCliente,
			CLI.IdEntidad IdEntidadCliente,
			C.EstablecimientoDestino,
			CLI.FlagClienteBoleta,
			C.Observacion,
			ETDCLI.IdTipoDocumento,
			ECLI.Nombre NombreCliente,
			EST.Direccion,
			ETDCLI.NumeroDocumento NumeroDocumentoCliente,
			TDCLI.Abreviatura NombreTipoDocumentoCliente,
			TDCLI.CodigoSunat CodigoSunatTipoDocumentoCliente,
			EMP.ID IdEmpresa,
			ENEMP.Nombre NombreEmpresa,
			TDEMP.CodigoSunat CodigoSunatTipoDocumentoEmpresa,
			ETDEMP.NumeroDocumento NumeroDocumentoEmpresa,
			UEMP.CodigoSunat CodigoSunatUbigeoEmpresa,
			(SELECT [ERP].[ObtenerNombreCompletoVia_By_IdEstablecimiento](ESTEMP.ID)) NombreViaEmpresa,
			(SELECT [ERP].[ObtenerNombreCompletoZona_By_IdEstablecimiento](ESTEMP.ID)) NombreZonaEmpresa,
			(SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](UEMP.ID)) NombreDepartamentoEmpresa,
			(SELECT [PLAME].[ObtenerNombreProvincia_By_Distrito](UEMP.ID)) NombreProvinciaEmpresa,
			ESTEMP.Direccion DireccionEmpresa,
			UEMP.Nombre NombreDistritoEmpresa,
			C.FlagExportacion,
			C.FlagPercepcion,
			C.FlagDetraccion,
			C.FlagAnticipo,
			C.FlagBorrador,
			P.Nombre NombreProyecto,
			C.FechaRegistro,
			C.UsuarioRegistro,
			C.FechaModificado,
			C.UsuarioModifico,
			CLI.Correo,
			C.IdEstablecimiento,
			C.FechaVencimiento,
			C.DiasVencimiento,
			C.IdEstablecimientoCliente 
	FROM ERP.Pedido C LEFT JOIN ERP.Cliente CLI
		ON CLI.ID = C.IdCliente
	LEFT JOIN PLE.T10TipoComprobante TC
		ON TC.ID = C.IdTipoComprobante
	LEFT JOIN ERP.Entidad ECLI
		ON ECLI.ID = CLI.IdEntidad
	LEFT JOIN ERP.EntidadTipoDocumento ETDCLI
		ON ETDCLI.IdEntidad = ECLI.ID
	LEFT JOIN PLE.T2TipoDocumento TDCLI
		ON TDCLI.ID = ETDCLI.IdTipoDocumento
	LEFT JOIN (SELECT ID, IdEntidad, IdUbigeo, Direccion, FlagBorrador, IdTipoEstablecimiento, Flag 
				FROM ERP.Establecimiento) EST
		ON EST.ID = C.IdEstablecimientoCliente
	LEFT JOIN ERP.Empresa EMP
		ON EMP.ID = C.IdEmpresa
	LEFT JOIN ERP.Entidad ENEMP
		ON ENEMP.ID = EMP.IdEntidad
	LEFT JOIN ERP.EntidadTipoDocumento ETDEMP
		ON ETDEMP.IdEntidad = ENEMP.ID
	LEFT JOIN PLE.T2TipoDocumento TDEMP
		ON TDEMP.ID = ETDEMP.IdTipoDocumento
	LEFT JOIN (SELECT ID, IdEntidad, IdUbigeo, Direccion, FlagBorrador, IdTipoEstablecimiento, Flag 
				FROM ERP.Establecimiento 
				WHERE IdTipoEstablecimiento = 1
				AND Flag = 1
				AND FlagBorrador = 0) ESTEMP
		ON ESTEMP.IdEntidad = ENEMP.ID
	LEFT JOIN PLAME.T7Ubigeo UEMP
		ON UEMP.ID = ESTEMP.IdUbigeo
	LEFT JOIN ERP.Proyecto P
		ON P.ID = C.IdProyecto
	LEFT JOIN ERP.Vendedor V
		ON V.ID = C.IdVendedor
	LEFT JOIN ERP.Trabajador T
		ON T.ID = V.IdTrabajador
	LEFT JOIN ERP.Entidad ENTV
		ON ENTV.ID = T.IdEntidad 
	LEFT JOIN ERP.Almacen A
		ON A.ID = C.IdAlmacen
	LEFT JOIN Maestro.Moneda M
		ON M.ID = C.IdMoneda
	LEFT JOIN Maestro.PedidoEstado CE
		ON CE.ID = C.IdPedidoEstado
	LEFT JOIN ERP.ListaPrecio LP
		ON LP.ID = C.IdListaPrecio
	WHERE C.ID = @Id

END