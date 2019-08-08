---------

-- Stored Procedure

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE PROC [ERP].[Usp_Sel_DatoLaboralDetalle_By_IdDatoLaboral]
@IdDatoLaboral int
AS
BEGIN
		declare  @idTrabajador int = (SELECT top 1 dl.IdTrabajador FROM ERP.DatoLaboral dl WHERE dl.id = @IdDatoLaboral)
	
	SELECT DLD.ID
      ,DLD.IdDatoLaboral
      ,DLD.IdRegimenLaboral
      ,DLD.IdTipoTrabajador
      ,DLD.IdPuesto
      ,DLD.IdTipoSueldo
      ,DLD.Sueldo
      ,DLD.FechaInicio
      ,DLD.FechaFin
	  ,TS.Nombre NombreTipoSueldo
	  ,TT.Nombre NombreTipoTrabajador
	  ,P.Nombre NombrePuesto
	  ,DLD.HoraBase
	  ,DLD.IdEstadoTrabajador
  FROM ERP.DatoLaboralDetalle DLD
  INNER JOIN PLAME.T8TipoTrabajador TT ON TT.ID = DLD.IdTipoTrabajador
  INNER JOIN Maestro.TipoSueldo TS ON TS.ID = DLD.IdTipoSueldo
  INNER JOIN Maestro.Puesto P ON P.ID = DLD.IdPuesto
  INNER JOIN ERP.DatoLaboral dl ON DLD.IdDatoLaboral = dl.ID
  WHERE dl.IdTrabajador=@idTrabajador

END