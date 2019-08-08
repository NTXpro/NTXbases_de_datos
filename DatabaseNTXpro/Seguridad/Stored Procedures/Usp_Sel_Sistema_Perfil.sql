
CREATE PROC [Seguridad].[Usp_Sel_Sistema_Perfil]
AS
BEGIN
	
	DECLARE @Sistema VARCHAR(4)= (SELECT Valor FROM ERP.Parametro WHERE Abreviatura = 'SIS')

	IF	@Sistema = 'FE'
	BEGIN
		
		SELECT	ID,
				Nombre
		FROM Seguridad.Sistema WHERE ID IN (1,2)
		ORDER BY ORDEN

	END
	ELSE
	BEGIN
		SELECT	ID,
				Nombre
		FROM Seguridad.Sistema 
		ORDER BY ORDEN
	END
END