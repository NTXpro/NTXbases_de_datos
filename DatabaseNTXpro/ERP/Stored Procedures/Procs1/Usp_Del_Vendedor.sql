CREATE PROC ERP.Usp_Del_Vendedor
@IdVendedor INT
AS
BEGIN

	DELETE FROM ERP.Vendedor WHERE ID = @IdVendedor

END