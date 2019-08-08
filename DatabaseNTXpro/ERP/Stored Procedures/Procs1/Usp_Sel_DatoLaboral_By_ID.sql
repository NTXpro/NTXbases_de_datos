CREATE PROC [ERP].[Usp_Sel_DatoLaboral_By_ID]
@ID int
AS
BEGIN
	SELECT DL.ID
      ,DL.IdEmpresa
      ,DL.IdTrabajador
      ,DL.FechaInicio
      ,DL.FechaCese
	  ,DL.FlagAsignacionFamiliar
	  ,DL.FechaInicioAsignacionFamiliar
	  ,E.Nombre NombreTrabajador
		,DL.IdMotivoCese
  FROM [ERP].[DatoLaboral] DL
  INNER JOIN ERP.Trabajador T ON T.ID = DL.IdTrabajador
  INNER JOIN ERP.Entidad E ON E.ID = T.IdEntidad
  WHERE DL.ID = @ID
END