CREATE PROC [ERP].[Usp_Sel_UnidadMedidaByCodigoSunat]
AS
BEGIN
		
		SELECT UM.ID,
		   UM.FechaRegistro,
		   UM.FechaEliminado,
		   UM.Nombre,
		   UM.CodigoSunat
		FROM [PLE].[T6UnidadMedida] UM
		WHERE UM.FlagSunat=1 AND UM.FlagBorrador = 0 AND UM.Flag=1
		
END
