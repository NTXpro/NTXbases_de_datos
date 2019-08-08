
-- =============================================
-- Author:		OMAR RODRIGUEZ
-- ALTER date: 04/12/2018
-- Description:	RETORNA TOTALES DE UNA PLANILLA 
--				I= TotalIngreso, D= Total Descuento
--				A= TotalAportes, P = Neto a Pagar
-- =============================================
CREATE FUNCTION [ERP].[Obtener_Totales_Planilla]
(@idEmpresa   INT, 
 @campo       VARCHAR(1), 
 @fechaInicio DATETIME, 
 @fechaFin    DATETIME
)
RETURNS DECIMAL(14, 5)
AS
     BEGIN
         -- Declare the return variable here
         DECLARE @Retorno DECIMAL(14, 5)= 0.0;
         SET @Retorno =
         (
             SELECT TOP 1 CASE
                              WHEN @campo = 'I'
                              THEN pc.TotalIngreso
                              WHEN @campo = 'D'
                              THEN pc.TotalDescuentos
                              WHEN @campo = 'A'
                              THEN pc.TotalAportes
                              WHEN @campo = 'P'
                              THEN pc.NetoAPagar
                          END
             FROM ERP.PlanillaCabecera pc
             WHERE pc.IdEmpresa = @idEmpresa
                   AND pc.FechaInicio >= @fechaInicio
                   AND pc.FechaFin <= @fechaFin
         );
         -- Return the result of the function
         RETURN @Retorno;
     END