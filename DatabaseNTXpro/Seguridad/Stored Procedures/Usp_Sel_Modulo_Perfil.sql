CREATE PROC [Seguridad].[Usp_Sel_Modulo_Perfil]
AS
BEGIN
	
	DECLARE @Sistema VARCHAR(4)= (SELECT Valor FROM ERP.Parametro WHERE Abreviatura = 'SIS')

	IF	@Sistema = 'FE'
	BEGIN
		
		SELECT	ID,
				Nombre,
				IdSistema
		FROM Seguridad.Modulo WHERE ID NOT IN (1,7,54,1064,5)
		ORDER BY ORDEN

	END
	ELSE
	BEGIN
		SELECT	ID,
				Nombre,
				IdSistema
		FROM Seguridad.Modulo WHERE ID NOT IN (1)
		ORDER BY ORDEN
	END

END