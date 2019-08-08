
-- =============================================
-- Author:		OMAR RODRIGUEZ
-- ALTER date: 04/12/2018
-- Description:	RETORNA  NUMERO DE EMPLEADOS DE UNA PLANILLA
-- =============================================
CREATE FUNCTION [ERP].[Obtener_Numero_Empleados_Planilla]
(@idEmpresa      INT, 
 @nombrePlanilla VARCHAR(100), 
 @fechaInicio    DATETIME, 
 @fechaFin       DATETIME
)
RETURNS INT
AS
     BEGIN
         -- Declare the return variable here
         DECLARE @RESULTADO INT= 0;
         DECLARE @IdTrabajador AS INT;
         DECLARE ProdInfo CURSOR
         FOR SELECT dl.IdTrabajador
             FROM ERP.DatoLaboralDetalle dld
                  INNER JOIN ERP.DatoLaboral dl ON dld.IdDatoLaboral = dl.ID
                  INNER JOIN Maestro.Planilla p ON dld.IdPlanilla = p.ID
             WHERE dld.FechaInicio >= @fechaInicio
                   AND (dld.FechaFin <= @fechaFin
                        OR dld.FechaFin IS NULL)
                   AND p.Nombre = @nombrePlanilla
                   AND dl.IdEmpresa = @idEmpresa
             GROUP BY dl.IdTrabajador;
         OPEN ProdInfo;
         FETCH NEXT FROM ProdInfo INTO @IdTrabajador;
         WHILE @@fetch_status = 0
             BEGIN
                 SET @RESULTADO = @RESULTADO + 1;
                 FETCH NEXT FROM ProdInfo INTO @IdTrabajador;
             END;
         CLOSE ProdInfo;
         DEALLOCATE ProdInfo;
         -- Return the result of the function
         RETURN   @RESULTADO;
     END