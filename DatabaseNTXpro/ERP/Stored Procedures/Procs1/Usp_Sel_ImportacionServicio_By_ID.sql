
CREATE PROC [ERP].[Usp_Sel_ImportacionServicio_By_ID]
@IdImporteServicio INT
AS
BEGIN
			SELECT * 
			FROM Maestro.ImportacionServicio WHERE ID = @IdImporteServicio
END
