CREATE PROC [ERP].[Usp_Del_Ubicacion]
@IdUbicacion INT
AS
BEGIN
	DELETE FROM ERP.Ubicacion 
	WHERE ID = @IdUbicacion
END