CREATE PROC [ERP].[Usp_Del_Existencia]
@IdExistencia INT
AS
BEGIN
		DELETE FROM [PLE].[T5Existencia] WHERE ID=@IdExistencia AND FlagSunat = 0
END
