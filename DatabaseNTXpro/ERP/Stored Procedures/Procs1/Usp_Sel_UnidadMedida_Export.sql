CREATE PROCEDURE [ERP].[Usp_Sel_UnidadMedida_Export]     
@Flag bit
AS
BEGIN
SELECT       
			UM.ID,
			UM.Nombre,
			UM.FechaRegistro,
			UM.FechaEliminado,
			UM.CodigoSunat	
		FROM [PLE].[T6UnidadMedida] UM
		WHERE UM.Flag = @Flag AND UM.FlagBorrador = 0
END