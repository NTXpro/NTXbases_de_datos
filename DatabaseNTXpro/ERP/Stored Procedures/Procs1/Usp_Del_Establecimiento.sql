CREATE PROC [ERP].[Usp_Del_Establecimiento]
@IdEstablecimiento	INT
AS
BEGIN
	DELETE FROM ERP.Establecimiento WHERE ID = @IdEstablecimiento
END