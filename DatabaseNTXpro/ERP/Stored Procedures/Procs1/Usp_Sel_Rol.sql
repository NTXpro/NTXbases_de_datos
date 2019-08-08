
CREATE PROC [ERP].[Usp_Sel_Rol] --WITH ENCRYPTION
AS
BEGIN
		
	SELECT	RO.ID,
			RO.Nombre
	FROM [Seguridad].[Rol] RO
	WHERE RO.Flag = 1 AND RO.FlagBorrador = 0
	ORDER BY RO.Nombre
END
