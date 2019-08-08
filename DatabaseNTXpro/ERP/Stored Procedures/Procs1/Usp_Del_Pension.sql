
CREATE PROC [ERP].[Usp_Del_Pension]
@IdPension INT,
@IdTrabajador INT
AS
BEGIN

	DECLARE @ID_EMPRESA INT = (SELECT TOP 1 IdEmpresa FROM ERP.TrabajadorPension WHERE ID = @IdPension);
	DECLARE @LAST_ID INT = (SELECT TOP 1 ID FROM ERP.TrabajadorPension
							WHERE IdEmpresa = @ID_EMPRESA AND IdTrabajador = @IdTrabajador AND ID != @IdPension
							ORDER BY ID DESC );

	DELETE ERP.TrabajadorPension WHERE ID = @IdPension

	UPDATE ERP.TrabajadorPension SET
	FechaFin = NULL
	WHERE ID = @LAST_ID;
END
