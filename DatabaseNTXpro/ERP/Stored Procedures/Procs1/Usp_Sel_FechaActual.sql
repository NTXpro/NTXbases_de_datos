CREATE PROC [ERP].[Usp_Sel_FechaActual]
AS
BEGIN
	SELECT [ERP].[ObtenerFechaActual]()
END
