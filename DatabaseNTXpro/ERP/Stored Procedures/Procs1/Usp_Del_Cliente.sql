
CREATE PROC [ERP].[Usp_Del_Cliente]
@IdCliente	INT
AS
BEGIN
		DELETE FROM ERP.Cliente WHERE ID=@IdCliente
END
