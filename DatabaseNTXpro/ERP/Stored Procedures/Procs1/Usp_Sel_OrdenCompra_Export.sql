CREATE PROC [ERP].[Usp_Sel_OrdenCompra_Export]
@ID INT
AS
BEGIN
	SELECT OC.ID
		  ,OC.IdMoneda
		  ,M.Nombre NombreMoneda
		  ,OC.IdProveedor
		  ,ENP.Nombre NombreProveedor
		  ,ETD.NumeroDocumento NumeroDocumentoProveedor
		  ,ETD.IdTipoDocumento IdTipoDocumentoProveedor
		  ,ES.Direccion DireccionProveedor
		  ,OC.IdProyecto
		  ,PR.Nombre NombreProyecto
		  ,OC.IdEstablecimiento
		  ,CONCAT(E.Nombre, ' - ', E.Direccion, ' - ', T7DE.Nombre, ' - ', T7PR.Nombre, ' - ', T7.Nombre) NombreEstablecimiento
		  ,OC.IdAlmacen
		  ,A.Nombre NombreAlmacen
		  ,OC.IdOrdenCompraEstado
		  ,OCE.Nombre Estado
		  ,OC.Fecha
		  ,OC.TipoCambio
		  ,OC.Serie + '-' +OC.Documento AS Documento
		  ,OC.DiasVencimiento
		  ,OC.FechaVencimiento
		  ,OC.Observacion
		  ,OC.UsuarioRegistro
		  ,OC.FechaRegistro
		  ,iif(IdOrdenCompraEstado<>1 and IdOrdenCompraEstado<>2, OC.UsuarioModifico,'') as UsuarioModifico
		  ,OC.FechaModificado
		  ,OC.UsuarioActivo
		  ,OC.FechaActivacion
		  ,OC.UsuarioElimino
		  ,OC.FechaEliminado
		  ,OC.Flag
		  ,OC.FlagBorrador
		  ,OC.ObservacionRechazado
		  ,OC.IdEmpresa
		  ,OC.SubTotal
		  ,OC.IGV
		  ,OC.Total
		  ,OC.PorcentajeIGV
		  ,TC.Nombre NombreTipoComprobante
		  ,OC.IdOrdenCompraEstado
		  ,OC.CondicionPago
		  
	  FROM ERP.OrdenCompra OC
	  LEFT JOIN Maestro.Moneda M ON M.ID = OC.IdMoneda
	  LEFT JOIN ERP.Proveedor P ON P.ID = OC.IdProveedor
	  LEFT JOIN ERP.Entidad ENP ON ENP.ID = P.IdEntidad
	  LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = ENP.ID
	  LEFT JOIN ERP.Establecimiento ES ON ES.IdEntidad = ENP.ID
	  LEFT JOIN ERP.Proyecto PR ON PR.ID = OC.IdProyecto
	  LEFT JOIN ERP.Establecimiento E ON E.ID = OC.IdEstablecimiento
		LEFT JOIN PLAME.T7Ubigeo T7 ON T7.ID = E.IdUbigeo
		LEFT JOIN PLAME.T7Ubigeo T7DE ON CONCAT('0000', LEFT(T7.CodigoSunat, 2)) = T7DE.CodigoSunat
		LEFT JOIN PLAME.T7Ubigeo T7PR ON CONCAT('00', LEFT(T7.CodigoSunat, 4)) = T7PR.CodigoSunat
	  LEFT JOIN ERP.Almacen A ON A.ID = OC.IdAlmacen
	  LEFT JOIN Maestro.OrdenCompraEstado OCE ON OCE.ID = OC.IdOrdenCompraEstado
	  LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = OC.IdTipoComprobante
	  WHERE OC.ID = @ID
  END