CREATE PROCEDURE [ERP].[Usp_Sel_Propiedad_Export]    
@Flag bit
AS
BEGIN
SELECT       
			PR.ID											,
			UM.ID											IdUnidadMedida,
			PR.Nombre										NombrePropiedad,
			UM.Nombre										NombreUnidadMedida,
			UM.CodigoSunat									CodigoSunat,
			PR.FechaRegistro								FechaRegistro
		FROM [Maestro].[Propiedad] PR
		INNER JOIN [PLE].[T6UnidadMedida] UM
		ON UM.ID = PR.IdUnidadMedida
		WHERE PR.Flag = @Flag AND PR.FlagBorrador = 0
END