
CREATE PROC [ERP].[Usp_Del_TrabajadorFamilia]
@ID INT
AS
BEGIN
	DELETE ERP.TrabajadorFamilia WHERE ID = @ID
END
