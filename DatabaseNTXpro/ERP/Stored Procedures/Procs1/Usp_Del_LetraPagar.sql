﻿
CREATE PROC [ERP].[Usp_Del_LetraPagar]
@ID int
AS
BEGIN
	DECLARE @TABLE_CUENTAPAGAR AS TABLE(IdCuentaPagar INT)

	INSERT INTO @TABLE_CUENTAPAGAR
	SELECT IdCuentaPagar FROM ERP.LetraPagarCuentaPagar WHERE IdLetraPagar = @ID

	DELETE FROM ERP.LetraPagarCuentaPagar WHERE IdLetraPagar = @ID 
	DELETE FROM ERP.LetraPagar WHERE ID = @ID
	DELETE FROM ERP.CuentaPagar WHERE ID IN (SELECT IdCuentaPagar FROM @TABLE_CUENTAPAGAR)
END