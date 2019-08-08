CREATE PROC [ERP].[Usp_Sel_Moneda_By_ID]
@IdMoneda INT
AS
BEGIN
	SELECT
		M.ID,
		M.Nombre
	FROM Maestro.Moneda M
	WHERE M.ID = @IdMoneda
END