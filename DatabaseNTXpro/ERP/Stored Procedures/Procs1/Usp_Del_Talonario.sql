CREATE PROC ERP.Usp_Del_Talonario
@IdTalonario INT
AS
BEGIN
	DELETE FROM ERP.Talonario WHERE ID = @IdTalonario
END