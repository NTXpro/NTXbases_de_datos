CREATE PROC ERP.Usp_Del_Transporte
@IdTransporte			INT
AS
BEGIN
	
	DELETE FROM ERP.Transporte WHERE ID = @IdTransporte

END
