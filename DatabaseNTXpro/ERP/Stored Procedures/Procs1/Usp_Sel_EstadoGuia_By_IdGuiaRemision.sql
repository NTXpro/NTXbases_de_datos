CREATE PROC [ERP].[Usp_Sel_EstadoGuia_By_IdGuiaRemision]
@IdGuiaRemision INT
AS
BEGIN
	DECLARE @IdGuiaRemisionEstado INT = (SELECT IdGuiaRemisionEstado FROM ERP.GuiaRemision WHERE ID = @IdGuiaRemision) 

	SELECT @IdGuiaRemisionEstado

END
