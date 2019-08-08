CREATE PROCEDURE [ERP].[Usp_Sel_Marca_Export]
@Flag bit
AS
BEGIN
SELECT		
			MA.ID,
			MA.Nombre,
		    MA.FechaRegistro,
		    MA.FechaEliminado
		  
		FROM  Maestro.Marca MA
		WHERE MA.Flag = @Flag AND MA.FlagBorrador = 0
END