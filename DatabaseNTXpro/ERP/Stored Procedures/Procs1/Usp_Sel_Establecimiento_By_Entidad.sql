CREATE PROC [ERP].[Usp_Sel_Establecimiento_By_Entidad]
@IdEntidad INT
AS
BEGIN

	SELECT	E.ID,
			E.IdEntidad,
			ISNULL(E.Nombre, '') + ' - ' + ISNULL(E.Direccion + ' - ','')  + ((SELECT [PLAME].[ObtenerNombreDepartamento_By_Distrito](U.ID)) + ' - ' + ([PLAME].[ObtenerNombreProvincia_By_Distrito](U.ID)) + ' - ' + U.Nombre) AS Nombre,
			CONCAT(E.Nombre, ' - ', E.Direccion) AS Direccion
	FROM 
	ERP.Establecimiento E
	LEFT JOIN PLAME.T7Ubigeo U ON U.ID = E.IdUbigeo
	WHERE E.IdEntidad = @IdEntidad AND E.Flag = 1 AND E.FlagBorrador = 0
	

END