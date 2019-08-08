
CREATE PROC [ERP].[Usp_Upd_RendirCuenta_Cierre]
@IdRendirCuenta	 INT
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000
	SET NOCOUNT ON;

	UPDATE ERP.MovimientoRendirCuenta SET FlagCierre = 1, FechaCierre = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdRendirCuenta

	SET NOCOUNT OFF;
END
