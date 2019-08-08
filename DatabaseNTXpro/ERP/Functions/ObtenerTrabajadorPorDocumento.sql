CREATE FUNCTION [ERP].[ObtenerTrabajadorPorDocumento](
@TipoDocumento INT,
@NumeroDocumento VARCHAR(20)
)
RETURNS INT
AS
BEGIN

	DECLARE @IdTrabajador INT =	(SELECT TOP 1 T.ID 
							FROM ERP.Trabajador T INNER JOIN ERP.Entidad E
								ON E.ID = T.IdEntidad
							INNER JOIN ERP.EntidadTipoDocumento ETD
								ON ETD.IdEntidad = E.ID
							WHERE T.FlagBorrador = 0 AND ETD.IdTipoDocumento = @TipoDocumento AND ETD.NumeroDocumento = @NumeroDocumento)


	RETURN ISNULL(@IdTrabajador,0)
END
