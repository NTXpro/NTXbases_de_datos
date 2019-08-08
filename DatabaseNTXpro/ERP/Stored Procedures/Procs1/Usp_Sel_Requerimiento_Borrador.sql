
CREATE PROC ERP.Usp_Sel_Requerimiento_Borrador
@IdEmpresa INT
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
  FROM ERP.Requerimiento R
  LEFT JOIN ERP.Entidad E ON E.ID = R.IdEntidad
  LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = R.IdEntidad
  LEFT JOIN ERP.Proyecto P ON P.ID = R.IdProyecto
  LEFT JOIN ERP.Establecimiento ES ON ES.ID = R.IdEstablecimiento
  WHERE R.FlagBorrador = 1 AND R.IdEmpresa = @IdEmpresa 
END
