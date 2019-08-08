CREATE PROC [ERP].[Usp_Sel_Rol_Inactivo]
AS
BEGIN
		
	SELECT	RO.ID,
			RO.Nombre,
			RO.FechaEliminado
	FROM [Seguridad].[Rol] RO
	WHERE RO.Flag = 0 AND RO.FlagBorrador = 0

END
