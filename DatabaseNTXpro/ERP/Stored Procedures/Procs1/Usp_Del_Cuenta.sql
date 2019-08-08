

CREATE PROC [ERP].[Usp_Del_Cuenta]
@IdCuenta			INT
AS
BEGIN
	DELETE FROM ERP.Cuenta WHERE ID = @IdCuenta
END
