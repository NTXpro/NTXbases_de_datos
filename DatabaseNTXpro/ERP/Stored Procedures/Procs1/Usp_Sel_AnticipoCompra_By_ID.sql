create PROC [ERP].[Usp_Sel_AnticipoCompra_By_ID]
@ID INT
AS
BEGIN
		
								SELECT	   AN.ID                ID,
										   AN.IdTipoComprobante	IdTipoComprobante,
                                           ENT.Nombre			Proveedor,
										   AN.IdProveedor		IdProveedor,
										   AN.IdEmpresa			IdEmpresa,
										   AN.IdMoneda			IdMoneda,
										   TD.Abreviatura		TipoDocumento,
	                                       MO.CodigoSunat		Moneda,
	                                       AN.TipoCambio		TipoCambio,
	                                       TC.Nombre			TipoComprobante,
	                                       AN.Orden				Orden,
	                                       AN.Serie				Serie,
	                                       AN.Documento			Documento,
										   ETD.NumeroDocumento	NumeroDocumento,
	                                       AN.FechaEmision		FechaEmision,
	                                       AN.Descripcion		Descripcion,
	                                       AN.Total				Total,
										   AN.UsuarioRegistro	UsuarioRegistro,
										   AN.UsuarioModifico	UsuarioModifico,
										   AN.UsuarioElimino	UsuarioElimino,
										   AN.UsuarioActivo		UsuarioActivo,
										   AN.FechaRegistro		FechaRegistro,
										   AN.FechaModificado	FechaModificado,
										   AN.FechaActivacion	FechaActivacion,
										   AN.FechaEliminado	FechaEliminado	,
										   AN.FlagBorrador		FlagBorrador
                                    FROM ERP.AnticipoCompra AN
                                    INNER JOIN ERP.Proveedor PRO
                                    ON PRO.ID = AN.IdProveedor
                                    INNER JOIN ERP.Entidad ENT
                                    ON ENT.ID = PRO.IdEntidad
									INNER JOIN ERP.EntidadTipoDocumento ETD
                                    ON ETD.IdEntidad = ENT.ID
									INNER JOIN PLE.T2TipoDocumento TD
									ON TD.ID = ETD.IdTipoDocumento
                                    INNER JOIN PLE.T10TipoComprobante TC
                                    ON TC.ID = AN.IdTipoComprobante
                                    INNER JOIN Maestro.Moneda MO
                                    ON MO.ID = AN.IdMoneda
                                    WHERE AN.ID = @ID

END
