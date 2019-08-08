CREATE PROC [ERP].[Usp_Del_Percepcion]
@ID		INT
AS
BEGIN
	UPDATE [ERP].[Percepcion] SET Documento = NULL , Fecha = NULL , Serie = NULL, Importe = NULL
	WHERE ID = @ID
END
