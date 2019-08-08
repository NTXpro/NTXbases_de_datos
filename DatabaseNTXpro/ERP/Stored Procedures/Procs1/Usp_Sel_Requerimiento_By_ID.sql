
CREATE PROC [ERP].[Usp_Sel_Requerimiento_By_ID]
@ID INT
AS
BEGIN

SELECT R.ID
     ,R.Fecha
     ,R.IdTipoComprobante
     ,R.Serie
     ,R.Documento
     ,R.IdEntidad
 ,E.Nombre NombreEntidad
 ,ETD.IdTipoDocumento IdTipoDocumentoEntidad
 ,ETD.NumeroDocumento NumeroDocumentoEntidad
     ,R.DiasVencimiento
     ,R.FechaVencimiento
     ,R.IdEstablecimiento
 ,ES.Nombre NombreEstablecimiento
     ,R.IdProyecto
 ,P.Nombre NombreProyecto
     ,R.FechaRegistro
     ,R.UsuarioRegistro
     ,R.FechaModificado
     ,R.UsuarioModifico
     ,R.FechaEliminado
     ,R.UsuarioElimino
     ,R.FechaActivacion
     ,R.UsuarioActivo
     ,R.FlagBorrador
     ,R.Flag
     ,R.IdEmpresa
 ,R.Observacion
 ,R.IdRequerimientoEstado
 ,TC.Nombre NombreTipoComprobante
 ,R.ObservacionRechazado
 FROM ERP.Requerimiento R
 LEFT JOIN ERP.Entidad E ON E.ID = R.IdEntidad
 LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = R.IdEntidad
 LEFT JOIN ERP.Proyecto P ON P.ID = R.IdProyecto
 LEFT JOIN ERP.Establecimiento ES ON ES.ID = R.IdEstablecimiento
 LEFT JOIN PLE.T10TipoComprobante TC ON TC.ID = R.IdTipoComprobante
 WHERE R.ID = @ID
 END