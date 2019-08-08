CREATE PROC [ERP].[Usp_Sel_DatoLaboral_Utilidad_By_Tipo_Calendario]
@IdEmpresa INT,
@IdAnio INT,
@FechaInicioProceso DATETIME,
@FechaFinProceso DATETIME
AS
BEGIN
SELECT DISTINCT T.ID IdTrabajador,
SUM(DATEDIFF(DAY, IIF(CAST(@FechaInicioProceso AS DATE) <= CAST(DL.fechainicio AS DATE),DL.fechainicio, @FechaInicioProceso), IIF(DL.FechaCese IS NULL,@FechaFinProceso,DL.FechaCese))) DiasTrabajados,
(SELECT SUM(ISNULL(PP.Calculo, 0))
FROM ERP.PlanillaPago PP
LEFT JOIN ERP.PlanillaCabecera PC ON PP.IdPlanillaCabecera = PC.ID
LEFT JOIN ERP.Periodo P ON P.ID = PC.IdPeriodo
WHERE P.IdAnio = @IdAnio AND PC.IdTrabajador = T.ID
) RemuneracionPercibida
FROM ERP.Trabajador T
LEFT JOIN ERP.DatoLaboral DL ON DL.IdTrabajador = T.ID
WHERE DL.IdEmpresa = @IdEmpresa AND
((DL.FechaCese < @FechaFinProceso AND DL.FechaCese > @FechaInicioProceso) OR DL.FechaCese IS NULL) 
GROUP BY T.ID
END
