CREATE PROC ERP.Usp_Del_Marca
@IdMarca INT
AS
BEGIN
		DELETE FROM  [Maestro].[Marca] WHERE ID=@IdMarca 
END

