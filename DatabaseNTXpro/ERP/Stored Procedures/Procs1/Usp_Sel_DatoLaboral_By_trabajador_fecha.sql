CREATE PROC [ERP].[Usp_Sel_DatoLaboral_By_trabajador_fecha] 
@idEmpresa    INT, 
@idTrabajador INT, 
@fechaInicio  DATETIME, 
@fechaFin     DATETIME
AS
     BEGIN
         SELECT TOP 1 dl.IdEmpresa, 
                      dl.IdTrabajador, 
                      dl.FechaInicio, 
                      dl.FechaCese, 
                      dl.FlagAsignacionFamiliar, 
                      dl.FechaInicioAsignacionFamiliar, 
                      dl.FechaFinAsignacionFamiliar, 
                      dld.IdTipoTrabajador, 
                      dld.IdPuesto, 
                      dld.IdTipoSueldo, 
                      dld.Sueldo, 
                      dld.FechaInicio AS FechaInicioDL, 
                      dld.FechaFin AS FechaFinDL, 
                      dld.IdCategoriaDatoLaboral, 
                      dld.IdPlanilla, 
                      dld.IdCategoriaOcupacional, 
                      dld.FlagJornadaTrabajoMaxima, 
                      dld.FlagJornadaAtipica, 
                      dld.FlagJornadaTrabajoHorarioNocturno, 
                      dld.IdSituacionEspecialTrabajador, 
                      dld.FlagSindicalizado, 
                      dld.IdSituacionTrabajador, 
                      dld.FlagPersonaDiscapacidad, 
                      dld.HoraBase
         FROM ERP.DatoLaboralDetalle dld
              INNER JOIN ERP.DatoLaboral dl ON dld.IdDatoLaboral = dl.ID
         WHERE dld.FechaInicio >= @fechaInicio
               AND (dld.FechaFin <= @fechaFin
                    OR dld.FechaFin IS NULL)
               AND dl.IdTrabajador = @idTrabajador
               AND dl.IdEmpresa = @idEmpresa
         ORDER BY dld.ID desc;
     END;