CREATE PROC [ERP].[Usp_Del_Rol]
@IdRol		INT
AS
BEGIN
		DELETE FROM [Seguridad].[Rol] WHERE ID = @IdRol
END
