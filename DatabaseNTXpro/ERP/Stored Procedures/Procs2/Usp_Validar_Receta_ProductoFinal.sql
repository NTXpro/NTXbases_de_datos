

-- =============================================
-- Author:        OMAR RODRIGUEZ    
-- Create date: 24/08/2018
-- Description:    VALIDACION PARA EVITAR PRODUCTOS ASOCIADOS A UNA RECETA DUPLICADOS
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Validar_Receta_ProductoFinal]
    @IdProducto INT
AS
BEGIN
      SELECT CASE WHEN A.total < 0 THEN 0 ELSE  A.total END FROM 
     (SELECT COUNT(r.IdProducto) -1 AS total FROM ERP.Receta r WHERE r.IdProducto = @IdProducto) A
END