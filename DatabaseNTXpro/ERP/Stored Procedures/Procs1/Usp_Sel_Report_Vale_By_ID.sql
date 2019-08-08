CREATE PROC [ERP].[Usp_Sel_Report_Vale_By_ID]
@ID INT
AS
BEGIN
	SELECT V.ID
      ,V.IdTipoMovimiento
	  ,TM.Nombre NombreTipoMovimiento
      ,V.IdEntidad
	  ,ETD.NumeroDocumento+ ' ' + E.Nombre NombreEntidad
      ,V.IdConcepto
	  ,TTO.CodigoSunat +' '+ TTO.Nombre NombreConcepto
      ,V.IdProyecto
	  ,P.Nombre NombreProyecto
      ,V.IdAlmacen
	  ,A.Nombre NombreAlmacen
      ,V.IdMoneda
	  ,M.Nombre NombreMoneda
      ,V.IdEmpresa
      ,V.Fecha
      ,V.Documento
      ,V.TipoCambio
	  ,V.PorcentajeIGV
      ,V.Observacion
      ,V.SubTotal
      ,V.IGV
      ,V.Total
      ,V.Peso
	  ,EST.Nombre NombreEstablecimiento
  FROM ERP.Vale V 
  LEFT JOIN Maestro.TipoMovimiento TM ON TM.ID = V.IdTipoMovimiento
  LEFT JOIN ERP.Entidad E ON E.ID = V.IdEntidad
  LEFT JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = V.IdEntidad
  LEFT JOIN [PLE].[T12TipoOperacion] TTO ON TTO.ID = V.IdConcepto
  LEFT JOIN ERP.Proyecto P ON P.ID = V.IdProyecto
  LEFT JOIN ERP.Almacen A ON A.ID = V.IdAlmacen
  LEFT JOIN ERP.Establecimiento EST ON EST.ID = A.IdEstablecimiento
  LEFT JOIN Maestro.Moneda M ON M.ID = V.IdMoneda
  WHERE V.ID = @ID

END
