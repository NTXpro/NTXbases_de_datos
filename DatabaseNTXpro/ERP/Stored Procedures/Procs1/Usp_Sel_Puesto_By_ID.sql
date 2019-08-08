CREATE PROC [ERP].[Usp_Sel_Puesto_By_ID]
@IdPuesto int
AS
BEGIN
SELECT UM.ID,
		   UM.FechaRegistro,
		   UM.FechaEliminado,
		     UM.FechaModificado,
			 UM.FechaActivacion,
			 UM.UsuarioRegistro,
			 UM.UsuarioElimino,
			 UM.UsuarioElimino,
			 UM.UsuarioModifico,
			 UM.UsuarioActivo,
			 
			 
			
		   UM.Nombre,
UM.FlagSunat,
A.ID IdOcupacion,
		   A.CodigoSunat + ' ' + A.Nombre CodigoSunat

	FROM [MAESTRO].[Puesto] UM
 LEFT JOIN PLAME.T10Ocupacion A ON A.ID = UM.IdOcupacion
	WHERE  UM.ID=@IdPuesto
	
END