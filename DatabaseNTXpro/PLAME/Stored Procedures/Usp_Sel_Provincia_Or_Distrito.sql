
CREATE PROCEDURE [PLAME].[Usp_Sel_Provincia_Or_Distrito]
@Id INT
AS
BEGIN
	
	DECLARE @CodigoSunat CHAR(6) = (SELECT TOP 1 CodigoSunat FROM [PLAME].[T7Ubigeo] WHERE ID = @Id)

	SELECT	ID,
			Nombre,
			CodigoSunat
	FROM [PLAME].[T7Ubigeo] WHERE CodigoSunat like SUBSTRING(@CodigoSunat,3,5)+ '%'
END