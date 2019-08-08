CREATE PROC ERP.Usp_Del_Proveedor
@IdProveedor INT
AS
BEGIN
	DELETE FROM ERP.Proveedor WHERE ID = @IdProveedor
END