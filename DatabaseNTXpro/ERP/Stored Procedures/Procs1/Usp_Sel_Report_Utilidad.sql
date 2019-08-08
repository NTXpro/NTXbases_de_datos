
CREATE PROC [ERP].[Usp_Sel_Report_Utilidad]
@IdUtilidad INT,
@IdUtilidadDetalle INT
AS
BEGIN
	SELECT
	   A.Nombre AnioProceso
	  ,ENT.Nombre NombreEmpresa
	  ,ETD.NumeroDocumento NumeroDocumentoEmpresa
	  ,EST.Direccion DireccionEmpresa
	  ,ENTREP.Nombre NombreRepresentanteLegal
	  ,ENTT.Nombre NombreTrabajador
	  ,U.RentaAnual
	  ,U.PorcentajeDistribuir
	  ,U.UtilidadDistribuir 
	  ,U.TotalDiasTrabajados
      ,UD.DiasTrabajados
	  ,UD.UtilidadDiasTrabajados
	  ,U.TotalRemuneracionPercibida
      ,UD.RemuneracionPercibida
      ,UD.UtilidadRemuneracionPercibida
      ,UD.Utilidad
  FROM ERP.UtilidadDetalle UD
  INNER JOIN ERP.Utilidad U ON U.ID = UD.IdUtilidad
  INNER JOIN Maestro.Anio A ON A.ID = U.IdAnioProcesado
  INNER JOIN ERP.Empresa E ON E.ID = U.IdEmpresa
  INNER JOIN ERP.Entidad ENT ON ENT.ID = E.IdEntidad
  INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = ENT.ID
  INNER JOIN ERP.Establecimiento EST ON EST.IdEntidad = ENT.ID
  INNER JOIN ERP.Entidad ENTREP ON ENTREP.ID = E.IdEntidadRepresentanteLegal
  INNER JOIN ERP.Trabajador T ON T.ID = UD.IdTrabajador
  INNER JOIN ERP.Entidad ENTT ON ENTT.ID = T.IdEntidad
  WHERE U.ID = @IdUtilidad AND (@IdUtilidadDetalle = 0 OR UD.ID = @IdUtilidadDetalle)
END
