CREATE PROC [ERP].[Usp_Sel_Cantidad_Empleado_por_planilla] 
@idEmpresa    INT, 
@nombrePlanilla varchar(100),
@fechaInicio  DATETIME, 
@fechaFin     DATETIME
AS
     BEGIN
      DECLARE @IdTrabajador AS int  
DECLARE @contador AS int = 0
DECLARE ProdInfo CURSOR FOR        SELECT dl.IdTrabajador
FROM ERP.DatoLaboralDetalle dld
     INNER JOIN ERP.DatoLaboral dl ON dld.IdDatoLaboral = dl.ID
     INNER JOIN Maestro.Planilla p ON dld.IdPlanilla = p.ID
WHERE dld.FechaInicio >= @fechaInicio
      AND (dld.FechaFin <= @fechaFin
           OR dld.FechaFin IS NULL)
      AND p.Nombre = @nombrePlanilla
      AND dl.IdEmpresa = @idEmpresa
GROUP BY dl.IdTrabajador 
OPEN ProdInfo
FETCH NEXT FROM ProdInfo INTO @IdTrabajador
WHILE @@fetch_status = 0
BEGIN
    SET @contador = @contador+ 1
    FETCH NEXT FROM ProdInfo INTO @IdTrabajador
END
CLOSE ProdInfo
DEALLOCATE ProdInfo


SELECT @contador AS contador
     END;