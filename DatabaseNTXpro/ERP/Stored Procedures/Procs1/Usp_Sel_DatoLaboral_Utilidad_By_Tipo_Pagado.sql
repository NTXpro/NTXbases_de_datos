CREATE PROC [ERP].[Usp_Sel_DatoLaboral_Utilidad_By_Tipo_Pagado] --1,8,'1/1/2017','12/31/2017'
@IdEmpresa INT,
@IdAnio INT,
@FechaInicioProceso DATETIME,
@FechaFinProceso DATETIME
AS
BEGIN
SELECT DISTINCT T.ID IdTrabajador,
((SELECT SUM(ISNULL(PHT.HoraPorcentaje, 0))
FROM ERP.PlanillaHojaTrabajo PHT
LEFT JOIN ERP.PlanillaCabecera PC ON PHT.IdPlanillaCabecera = PC.ID
LEFT JOIN ERP.Periodo P ON P.ID = PC.IdPeriodo
WHERE P.IdAnio = @IdAnio AND PC.IdTrabajador = T.ID AND PHT.IdConcepto = 1
) / 24) DiasTrabajados,
(SELECT SUM(ISNULL(PP.Calculo, 0))
FROM ERP.PlanillaPago PP
LEFT JOIN ERP.PlanillaCabecera PC ON PP.IdPlanillaCabecera = PC.ID
LEFT JOIN ERP.Periodo P ON P.ID = PC.IdPeriodo
WHERE P.IdAnio = @IdAnio AND PC.IdTrabajador = T.ID
) RemuneracionPercibida
FROM ERP.Trabajador T
LEFT JOIN ERP.DatoLaboral DL ON DL.IdTrabajador = T.ID
WHERE DL.IdEmpresa = @IdEmpresa  AND
((DL.FechaCese < @FechaFinProceso AND DL.FechaCese > @FechaInicioProceso) OR DL.FechaCese IS NULL) 

END
