CREATE procedure [ERP].[Usp_Sel_Puesto]


AS
BEGIN
		
	SELECT UM.ID,
	UM.IdOcupacion,
		   UM.FechaRegistro,
		   UM.FechaEliminado,
		   UM.Nombre,
UM.FlagSunat,
		   A.CodigoSunat + ' ' + A.Nombre CodigoSunat

	FROM [MAESTRO].[Puesto] UM
 inner JOIN PLAME.T10Ocupacion A ON A.ID = UM.IdOcupacion
	WHERE UM.Flag = 1 AND UM.FlagBorrador = 0

END