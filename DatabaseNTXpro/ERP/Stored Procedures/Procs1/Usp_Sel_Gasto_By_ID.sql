
CREATE PROC [ERP].[Usp_Sel_Gasto_By_ID] 
@ID INT
AS
BEGIN
		
								SELECT	   GA.ID                ID,
                                           ENT.Nombre			Proveedor,
										   GA.IdEmpresa			IdEmpresa,
										   GA.IdMoneda			IdMoneda,
										   GA.IdTipoComprobante IdTipoComprobante,
										   TD.Abreviatura		TipoDocumento,
										   GA.IdProveedor		IdProveedor,
	                                       MO.CodigoSunat		Moneda,
	                                       GA.TipoCambio		TipoCambio,
	                                       TC.Nombre			TipoComprobante,
	                                       GA.Orden				Orden,
	                                       GA.Serie				Serie,
	                                       GA.Documento			Documento,
										   ETD.NumeroDocumento	NumeroDocumento,
	                                       GA.FechaEmision		FechaEmision,
	                                       GA.Descripcion		Descripcion,
	                                       GA.Total				Total,
										   GA.UsuarioRegistro	UsuarioRegistro,
										   GA.UsuarioModifico	UsuarioModifico,
										   GA.UsuarioElimino	UsuarioElimino,
										   GA.UsuarioActivo		UsuarioActivo,
										   GA.FechaRegistro		FechaRegistro,
										   GA.FechaModificado	FechaModificado,
										   GA.FechaActivacion	FechaActivacion,
										   GA.FechaEliminado	FechaEliminado,
										   PROY.ID				IdProyecto,
										   PROY.Nombre			NombreProyecto,
										   PROY.Numero			NumeroProyecto
                                    FROM ERP.Gasto GA
                                    INNER JOIN ERP.Proveedor PRO
                                    ON PRO.ID = GA.IdProveedor
                                    INNER JOIN ERP.Entidad ENT
                                    ON ENT.ID = PRO.IdEntidad
									INNER JOIN ERP.EntidadTipoDocumento ETD
                                    ON ETD.IdEntidad = ENT.ID
									INNER JOIN PLE.T2TipoDocumento TD
									ON TD.ID = ETD.IdTipoDocumento
                                    INNER JOIN PLE.T10TipoComprobante TC
                                    ON TC.ID = GA.IdTipoComprobante
                                    INNER JOIN Maestro.Moneda MO
                                    ON MO.ID = GA.IdMoneda
									LEFT JOIN ERP.Proyecto PROY
									ON PROY.ID = GA.IdProyecto
                                    WHERE GA.ID = @ID

END
