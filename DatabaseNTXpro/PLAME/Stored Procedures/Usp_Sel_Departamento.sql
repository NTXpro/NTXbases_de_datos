
CREATE PROCEDURE [PLAME].[Usp_Sel_Departamento]
AS
BEGIN
	SELECT	ID,
			Nombre,
			CodigoSunat 
	FROM [PLAME].[T7Ubigeo] 
	WHERE CodigoSunat like '0000%'
END