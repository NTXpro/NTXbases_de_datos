
CREATE PROC [ERP].[Usp_Sel_ImportacionServicioInactivo]
AS
BEGIN
			SELECT * 
			FROM Maestro.ImportacionServicio WHERE Flag = 0 AND FlagBorrador = 0 
END
