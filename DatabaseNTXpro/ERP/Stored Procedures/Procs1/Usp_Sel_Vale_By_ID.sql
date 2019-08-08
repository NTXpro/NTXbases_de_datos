
CREATE PROCEDURE [ERP].[Usp_Sel_Vale_By_ID] --1
@ID INT
AS
BEGIN
	SELECT V.ID
      ,V.IdTipoMovimiento
	  ,TM.Nombre NombreTipoMovimiento
      ,V.IdEntidad
	  ,E.Nombre NombreEntidad
	  ,ETD.NumeroDocumento NumeroDocumentoEntidad
	  ,ETD.IdTipoDocumento
	  ,TD.Abreviatura NombreTipoDocumento
      ,V.IdConcepto
	  ,TTO.Nombre NombreConcepto
      ,V.IdProyecto
	  ,P.Nombre NombreProyecto
      ,V.IdAlmacen
	  ,A.Nombre NombreAlmacen
      ,V.IdMoneda
	  ,M.Nombre NombreMoneda
      ,V.IdEmpresa
      ,V.Fecha
      ,V.UsuarioRegistro
      ,V.FechaRegistro
      ,V.UsuarioModifico
      ,V.FechaModificado
      ,V.UsuarioElimino
      ,V.FechaEliminado
      ,V.UsuarioActivo
      ,V.FechaActivacion
      ,V.FlagBorrador
      ,V.Flag
      ,V.Documento
      ,V.TipoCambio
	  ,V.PorcentajeIGV
      ,V.Observacion
      ,V.SubTotal
      ,V.IGV
      ,V.Total
      ,V.Peso
	  ,V.Serie
	  ,V.FlagTransferencia
	  ,V.IdValeEstado
	  ,V.FlagTransformacion
	  ,V.FlagComprobante
	  ,V.FlagGuiaRemision
  FROM ERP.Vale V 
  LEFT JOIN Maestro.TipoMovimiento TM ON TM.ID = V.IdTipoMovimiento
  LEFT JOIN ERP.Entidad E ON E.ID = V.IdEntidad
  LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = V.IdEntidad
  LEFT JOIN PLE.T2TipoDocumento TD ON TD.ID = ETD.IdTipoDocumento
  LEFT JOIN [PLE].[T12TipoOperacion] TTO ON TTO.ID = V.IdConcepto
  LEFT JOIN ERP.Proyecto P ON P.ID = V.IdProyecto
  LEFT JOIN ERP.Almacen A ON A.ID = V.IdAlmacen
  LEFT JOIN Maestro.Moneda M ON M.ID = V.IdMoneda
  WHERE V.ID = @ID
END
