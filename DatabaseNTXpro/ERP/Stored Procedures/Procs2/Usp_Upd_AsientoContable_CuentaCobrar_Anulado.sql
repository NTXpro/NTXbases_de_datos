CREATE PROC [ERP].[Usp_Upd_AsientoContable_CuentaCobrar_Anulado]
@IdAsiento INT
AS
BEGIN

SET QUERY_GOVERNOR_COST_LIMIT 16000
	SET NOCOUNT ON;

	UPDATE ERP.AsientoDetalle SET ImporteSoles = 0 , ImporteDolares = 0 WHERE IdAsiento = @IdAsiento

	SET NOCOUNT OFF;
END
