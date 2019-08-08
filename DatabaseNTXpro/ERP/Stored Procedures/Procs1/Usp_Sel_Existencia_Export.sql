CREATE PROCEDURE [ERP].[Usp_Sel_Existencia_Export]
@Flag bit
AS
BEGIN
SELECT       
			
			EX.ID,
			EX.Nombre,
			EX.FechaRegistro,
			EX.FechaEliminado,
			EX.CodigoSunat		
		FROM [PLE].[T5Existencia] EX
		WHERE EX.Flag = @Flag AND EX.FlagBorrador = 0 
END