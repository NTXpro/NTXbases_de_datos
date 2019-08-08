

CREATE PROC [ERP].[Usp_Horas_por_TipoSueldo] 
@ID INT
AS
BEGIN
	
	SELECT TOP 1 ts.Hora FROM Maestro.TipoSueldo ts WHERE ts.ID = @ID

END