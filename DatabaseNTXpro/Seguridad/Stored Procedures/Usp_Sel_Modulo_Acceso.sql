CREATE PROC [Seguridad].[Usp_Sel_Modulo_Acceso]
AS
BEGIN
	SELECT ID, 
		   IdSistema,
		   Nombre
	FROM Seguridad.Modulo
	WHERE ID NOT IN (5,1,53)
	ORDER BY ORDEN
END