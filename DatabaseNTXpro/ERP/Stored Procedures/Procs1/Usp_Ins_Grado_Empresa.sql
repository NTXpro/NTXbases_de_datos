
CREATE PROC [ERP].[Usp_Ins_Grado_Empresa]
@IdEmpresa INT,
@IdEmpresaPlantilla		INT
AS
BEGIN

		INSERT INTO Maestro.Grado (Nombre,Longitud,IdEmpresa,IdAnio)
									SELECT 
									Nombre,Longitud,@IdEmpresa,IdAnio FROM Maestro.Grado WHERE IdEmpresa = @IdEmpresaPlantilla
			
END
