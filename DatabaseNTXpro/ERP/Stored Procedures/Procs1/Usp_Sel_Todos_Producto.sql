

CREATE PROC [ERP].[Usp_Sel_Todos_Producto] --1
@IdEmpresa INT
AS
BEGIN
        
    SELECT  PRO.ID,
            isnull(PRO.Nombre,'N/D') AS Nombre
    FROM [ERP].[Producto] PRO
    WHERE  IdEmpresa = @IdEmpresa 

END