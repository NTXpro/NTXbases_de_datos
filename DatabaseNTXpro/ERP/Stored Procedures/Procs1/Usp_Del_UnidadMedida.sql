CREATE PROC [ERP].[Usp_Del_UnidadMedida] 
@IdUnidadMedida	 INT
AS
BEGIN
		DELETE FROM [PLE].[T6UnidadMedida] WHERE ID=@IdUnidadMedida AND FlagSunat = 0
END