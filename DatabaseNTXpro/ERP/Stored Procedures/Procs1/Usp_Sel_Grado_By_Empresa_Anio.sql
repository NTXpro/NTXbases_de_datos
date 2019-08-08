CREATE PROC [ERP].[Usp_Sel_Grado_By_Empresa_Anio]
@IdEmpresa INT,
@IdAnio INT
AS
BEGIN
		SELECT ID , Nombre , Longitud , IdEmpresa,IdAnio
		FROM Maestro.Grado
		WHERE IdEmpresa = @IdEmpresa AND IdAnio = @IdAnio
END
