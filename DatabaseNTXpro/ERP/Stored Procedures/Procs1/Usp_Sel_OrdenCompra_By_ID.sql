﻿CREATE PROC [ERP].[Usp_Sel_OrdenCompra_By_ID]
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
		  ,E.Nombre NombreEstablecimiento
		  ,OC.IdAlmacen
		  ,A.Nombre NombreAlmacen
		  ,OC.IdOrdenCompraEstado
		  ,OCE.Nombre Estado
		  ,OC.Fecha
		  ,OC.TipoCambio
		  ,OC.Serie
		  ,OC.Documento
		  ,OC.DiasVencimiento
		  ,OC.FechaVencimiento
		  ,OC.Observacion
		  ,OC.UsuarioRegistro
		  ,OC.FechaRegistro
		  ,OC.UsuarioModifico
		  ,OC.FechaModificado
		  ,OC.UsuarioActivo
		  ,OC.FechaActivacion
		  ,OC.UsuarioElimino
		  ,OC.FechaEliminado
		  ,OC.Flag
		  ,OC.FlagBorrador
		  ,OC.FlagComparador
		  ,OC.ObservacionRechazado
		  ,OC.ObservacionRechazado AS ObservacionRechazo
		  ,OC.IdEmpresa
		  ,OC.SubTotal
		  ,OC.IGV
		  ,OC.Total
		  ,OC.PorcentajeIGV
		  ,TC.Nombre NombreTipoComprobante
		  ,OC.CondicionPago
	  FROM ERP.OrdenCompra OC
	  LEFT JOIN Maestro.Moneda M ON M.ID = OC.IdMoneda
	  LEFT JOIN ERP.Proveedor P ON P.ID = OC.IdProveedor
	  LEFT JOIN ERP.Entidad ENP ON ENP.ID = P.IdEntidad
	  LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = ENP.ID
	  LEFT JOIN ERP.Establecimiento ES ON ES.IdEntidad = ENP.ID
	  LEFT JOIN ERP.Proyecto PR ON PR.ID = OC.IdProyecto
	  LEFT JOIN ERP.Establecimiento E ON E.ID = OC.IdEstablecimiento
	  LEFT JOIN ERP.Almacen A ON A.ID = OC.IdAlmacen
	  LEFT JOIN Maestro.OrdenCompraEstado OCE ON OCE.ID = OC.IdOrdenCompraEstado
	  LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = OC.IdTipoComprobante
	  WHERE OC.ID = @ID
  END