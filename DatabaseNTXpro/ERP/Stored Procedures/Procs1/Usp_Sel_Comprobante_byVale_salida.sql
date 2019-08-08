
CREATE PROC [ERP].[Usp_Sel_Comprobante_byVale_salida] --1

AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 5001886
	SET NOCOUNT ON;


SELECT C.ID
			
	FROM ERP.Comprobante C LEFT JOIN ERP.Cliente CLI
		ON CLI.ID = C.IdCliente
	LEFT JOIN PLE.T10TipoComprobante TC
		ON TC.ID = C.IdTipoComprobante
	LEFT JOIN [XML].[T9MotivoNotaCredito] MNC
		ON MNC.ID = C.IdMotivoNotaCredito
	LEFT JOIN [XML].[T10MotivoNotaDebito] MND
		ON MND.ID = C.IdMotivoNotaDebito
	LEFT JOIN ERP.Entidad ECLI
		ON ECLI.ID = CLI.IdEntidad
	LEFT JOIN ERP.EntidadTipoDocumento ETDCLI
		ON ETDCLI.IdEntidad = ECLI.ID
	LEFT JOIN PLE.T2TipoDocumento TDCLI
		ON TDCLI.ID = ETDCLI.IdTipoDocumento
	LEFT JOIN ERP.Establecimiento EST
		ON EST.ID = C.IdEstablecimientoCliente
	LEFT JOIN ERP.Empresa EMP
		ON EMP.ID = C.IdEmpresa
	LEFT JOIN ERP.Entidad ENEMP
		ON ENEMP.ID = EMP.IdEntidad
	LEFT JOIN ERP.EntidadTipoDocumento ETDEMP
		ON ETDEMP.IdEntidad = ENEMP.ID
	LEFT JOIN PLE.T2TipoDocumento TDEMP
		ON TDEMP.ID = ETDEMP.IdTipoDocumento
	LEFT JOIN ERP.Establecimiento ESTEMP
		ON ESTEMP.IdEntidad = ENEMP.ID AND ESTEMP.Flag = 1 AND ESTEMP.FlagBorrador = 0 AND ESTEMP.IdTipoEstablecimiento = 1
	LEFT JOIN PLAME.T7Ubigeo UEMP
		ON UEMP.ID = ESTEMP.IdUbigeo
	LEFT JOIN ERP.ComprobanteReferencia CI
		ON CI.IdComprobante = C.ID AND CI.IdReferenciaOrigen = 1 AND CI.FlagInterno = 1
	LEFT JOIN ERP.Comprobante CR
		ON CR.ID = CI.IdReferencia
	LEFT JOIN PLE.T10TipoComprobante TCR
		ON TCR.ID = CR.IdTipoComprobante
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
	LEFT JOIN Maestro.ComprobanteEstado CE
		ON CE.ID = C.IdComprobanteEstado
	LEFT JOIN ERP.ListaPrecio LP
		ON LP.ID = C.IdListaPrecio
	LEFT JOIN ERP.Cuenta CU 
		ON CU.ID = C.IdCuentaDetraccion 
	LEFT JOIN Maestro.Detraccion DE 
		ON DE.ID = C.IdDetraccion 
	WHERE   C.FlagGenerarVale=0
	ORDER BY C.Documento, C.Fecha
END