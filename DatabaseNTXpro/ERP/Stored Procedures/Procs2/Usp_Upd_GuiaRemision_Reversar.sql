CREATE PROC ERP.Usp_Upd_GuiaRemision_Reversar
@IdGuiaRemision INT
AS
BEGIN
		EXEC [ERP].[Usp_Upd_GuiaRemision_Anular] @IdGuiaRemision

		UPDATE ERP.GuiaRemision SET IdGuiaRemisionEstado = 1 WHERE ID = @IdGuiaRemision
END
