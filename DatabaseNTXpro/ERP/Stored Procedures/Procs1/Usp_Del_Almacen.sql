
create PROC [ERP].[Usp_Del_Almacen]
@IdAlmacen			INT
AS
BEGIN
	DELETE FROM ERP.Almacen WHERE ID = @IdAlmacen
END
