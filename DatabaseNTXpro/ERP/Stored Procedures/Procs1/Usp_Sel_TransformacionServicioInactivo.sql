
CREATE PROC ERP.Usp_Sel_TransformacionServicioInactivo
AS
BEGIN
			SELECT * 
			FROM Maestro.TransformacionServicio WHERE Flag = 0 AND FlagBorrador = 0 
END
