CREATE procedure [ERP].[Usp_Sel_Puesto_Inactivo]

AS
BEGIN
		
	SELECT UM.ID,

		   UM.FechaRegistro,
		   UM.FechaEliminado,
		   UM.Nombre,
UM.FlagSunat,
		   A.CodigoSunat + ' ' + A.Nombre CodigoSunat

	FROM [MAESTRO].[Puesto] UM
 LEFT JOIN PLAME.T10Ocupacion A ON A.ID = UM.IdOcupacion
	
	WHERE UM.Flag = 0 AND UM.FlagBorrador = 0

END