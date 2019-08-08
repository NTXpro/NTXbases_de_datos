
-----------
-- Stored Procedure

CREATE PROC [ERP].[Usp_Sel_DatoLaboralDetalle_By_ID]
@ID INT
AS
BEGIN
		SELECT TOP 1
			   DL.ID,
			   DLD.ID IdDetalle,
			   DL.IdEmpresa,
			   DLD.IdPlanilla,
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
			   DLD.Sueldo,
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
			   DL.FlagAsignacionFamiliar,
			   DLD.FlagJornadaTrabajoMaxima,
			   DLD.FlagJornadaAtipica,
			   DLD.FlagJornadaTrabajoHorarioNocturno,
			   DLD.FlagSindicalizado,
			   DLD.FlagPersonaDiscapacidad,
			   DLD.HoraBase,
			   DLD.IdEstadoTrabajador
		FROM ERP.DatoLaboral DL
		LEFT JOIN ERP.Trabajador TR ON TR.ID = DL.IdTrabajador
		LEFT JOIN ERP.DatoLaboralDetalle DLD ON DLD.IdDatoLaboral = DL.ID
		LEFT JOIN Maestro.Planilla PL ON PL.ID = DLD.IdPlanilla
		LEFT JOIN Maestro.Puesto P ON P.ID = DLD.IdPuesto
		LEFT JOIN Maestro.TipoSueldo TS ON TS.ID = DLD.IdTipoSueldo
		LEFT JOIN Maestro.CategoriaDatoLaboral CDL ON CDL.ID = DLD.IdCategoriaDatoLaboral
		LEFT JOIN PLAME.T8TipoTrabajador TT ON TT.ID = DLD.IdTipoTrabajador
		LEFT JOIN PLAME.T33RegimenLaboral RL ON RL.ID = DLD.IdRegimenLaboral
		LEFT JOIN PLAME.T24CategoriaOcupacional CO ON CO.ID = DLD.IdCategoriaOcupacional
		LEFT JOIN PLAME.T15SituacionTrabajador ST ON ST.ID = DLD.IdSituacionTrabajador
		LEFT JOIN PLAME.T35SituacionEspecialTrabajador TST ON TST.ID = DLD.IdSituacionEspecialTrabajador
		WHERE DLD.ID = @ID
END