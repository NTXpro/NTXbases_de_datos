
CREATE PROC ERP.Usp_Del_ImportacionServicio
@IdImporteServicio INT
AS
BEGIN
		DELETE Maestro.ImportacionServicio WHERE ID = @IdImporteServicio
END
