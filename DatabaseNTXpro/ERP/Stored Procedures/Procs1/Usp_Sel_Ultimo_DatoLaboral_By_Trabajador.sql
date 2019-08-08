
CREATE PROC [ERP].[Usp_Sel_Ultimo_DatoLaboral_By_Trabajador]
@IdTrabajador INT,
@IdEmpresa INT
AS
BEGIN
		SELECT TOP 1
			   DL.ID,
			   B.ID IdDetalle,
			   DL.IdEmpresa,
			   B.IdPlanilla,
			   DL.IdTrabajador,
			   DL.FechaInicio,
			   DL.FechaCese,
			   DL.FlagAsignacionFamiliar,
			   DL.FechaInicioAsignacionFamiliar,
			   DL.FechaFinAsignacionFamiliar,
			   PL.ID AS IdPlanilla,
			   PL.Nombre AS NombrePlanilla,
			   PL.Codigo AS CodigoPlanilla,
			   P.ID AS IdPuesto,
			   P.Nombre AS NombrePuesto,
			   TS.ID IdTipoSueldo,
			   TS.Nombre NombreTipoSueldo,
			   B.Sueldo,
			   CDL.ID IdCategoriaDatoLaboral,
			   CDL.Nombre NombreCategoriaDatoLaboral,
			   TT.ID IdTipoTrabajador,
			   TT.Nombre NombreTipoTrabajador,
			   RL.ID IdRegimenLaboral,
			   RL.Nombre NombreRegimenLaboral,
			   CO.ID IdCategoriaOcupacional,
			   CO.Nombre NombreCategoriaOcupacional,
			   ST.ID IdSituacionTrabajador,
			   ST.Nombre NombreSituacionTrabajador,
			   TST.ID IdSituacionEspecialTrabajador,
			   TST.Nombre NombreSituacionEspecialTrabajador,
			   B.FlagJornadaTrabajoMaxima,
			   B.FlagJornadaAtipica,
			   B.FlagJornadaTrabajoHorarioNocturno,
			   B.FlagSindicalizado,
			   B.FlagPersonaDiscapacidad
			   ,B.FechaInicio AS FechaInicioDLD
			   ,B.horaBase
		FROM ERP.DatoLaboralDetalle b
     INNER JOIN ERP.DatoLaboral dl ON b.IdDatoLaboral = dl.ID
     LEFT JOIN Maestro.Planilla PL ON PL.ID = B.IdPlanilla
     LEFT JOIN Maestro.Puesto P ON P.ID = B.IdPuesto
     LEFT JOIN Maestro.TipoSueldo TS ON TS.ID = B.IdTipoSueldo
     LEFT JOIN Maestro.CategoriaDatoLaboral CDL ON CDL.ID = B.IdCategoriaDatoLaboral
     LEFT JOIN PLAME.T8TipoTrabajador TT ON TT.ID = B.IdTipoTrabajador
     LEFT JOIN PLAME.T33RegimenLaboral RL ON RL.ID = B.IdRegimenLaboral
     LEFT JOIN PLAME.T24CategoriaOcupacional CO ON CO.ID = B.IdCategoriaOcupacional
     LEFT JOIN PLAME.T15SituacionTrabajador ST ON ST.ID = B.IdSituacionTrabajador
     LEFT JOIN PLAME.T35SituacionEspecialTrabajador TST ON TST.ID = B.IdSituacionEspecialTrabajador
WHERE DL.IdTrabajador = @IdTrabajador
      AND DL.IdEmpresa = @IdEmpresa ORDER BY b.ID DESC
END