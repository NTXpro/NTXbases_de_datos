
CREATE PROC ERP.Usp_Sel_TransformacionServicioBorrador
AS
BEGIN
			SELECT * 
			FROM Maestro.TransformacionServicio WHERE Flag = 1 AND FlagBorrador = 1 
END
