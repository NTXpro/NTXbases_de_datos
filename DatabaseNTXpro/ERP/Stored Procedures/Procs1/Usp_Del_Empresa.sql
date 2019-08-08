
CREATE PROC [ERP].[Usp_Del_Empresa]
@IdEmpresa			INT
AS
BEGIN
	
	DELETE FROM ERP.Empresa WHERE ID = @IdEmpresa

END

