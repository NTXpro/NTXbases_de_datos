CREATE PROC [ERP].[Usp_Del_Propiedad]
@IdPropiedad INT
AS
BEGIN
		DELETE FROM [Maestro].[Propiedad] WHERE ID=@IdPropiedad 
END

