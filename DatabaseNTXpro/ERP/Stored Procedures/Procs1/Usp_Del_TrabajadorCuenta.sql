﻿CREATE PROC ERP.Usp_Del_TrabajadorCuenta
@ID INT
AS
BEGIN
	DELETE FROM ERP.TrabajadorCuenta WHERE ID = @ID
END
