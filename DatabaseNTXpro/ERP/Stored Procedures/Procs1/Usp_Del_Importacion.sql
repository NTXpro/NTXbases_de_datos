CREATE PROC [ERP].[Usp_Del_Importacion]
@ID INT
AS
BEGIN
	DELETE FROM [ERP].[ImportacionReferencia] WHERE IdImportacion = @ID
	DELETE FROM [ERP].[ImportacionProductoDetalle] WHERE IdImportacion = @ID
	DELETE FROM [ERP].[ImportacionServicioDetalle] WHERE IdImportacion = @ID
	DELETE FROM [ERP].[Importacion] WHERE ID = @ID
END
