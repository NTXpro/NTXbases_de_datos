CREATE PROC [ERP].[Usp_Sel_LonguitudxGrado] 
@IdGrado INT
AS
BEGIN
	SELECT  GR.Nombre ,
			GR.Longitud

		  
	FROM [Maestro].[Grado] GR
	WHERE GR.ID = @IdGrado
END
