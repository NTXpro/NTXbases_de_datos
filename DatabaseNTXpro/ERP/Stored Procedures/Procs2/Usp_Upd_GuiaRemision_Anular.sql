
CREATE PROC [ERP].[Usp_Upd_GuiaRemision_Anular]
@IdGuiaRemision INT,
@CorrelativoAnulacionSunat INT,
@UsuarioAnulo VARCHAR(250),
@TicketAnulacion VARCHAR(250)
AS
BEGIN
		DECLARE @IdVale INT = (SELECT IdVale FROM ERP.GuiaRemision WHERE ID = @IdGuiaRemision)

		EXEC [ERP].[Usp_Upd_Vale_Anular] @IdVale

		UPDATE ERP.GuiaRemision SET IdGuiaRemisionEstado = 3,CorrelativoAnulacionSunat = @CorrelativoAnulacionSunat, TicketAnulacion = @TicketAnulacion,FechaAnulado = (SELECT ERP.ObtenerFechaActual()), UsuarioAnulo = @UsuarioAnulo  WHERE ID = @IdGuiaRemision
END
