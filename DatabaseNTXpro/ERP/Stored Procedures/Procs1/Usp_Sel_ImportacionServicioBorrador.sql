
CREATE PROC [ERP].[Usp_Sel_ImportacionServicioBorrador]
AS
BEGIN
			SELECT * 
			FROM Maestro.ImportacionServicio WHERE Flag = 1 AND FlagBorrador = 1 
END
