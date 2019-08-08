
CREATE FUNCTION [ERP].[ObtenerVentaBienesTransferidosAmazonia](
@IdEmpresa INT,
@Fecha DATETIME
)
RETURNS VARCHAR(MAX)
AS
BEGIN
DECLARE @BienesTransferidosAmazonia VARCHAR(MAX) = (SELECT TOP 1 Valor FROM ERP.Parametro P WHERE Abreviatura = 'VTD' AND P.IdEmpresa = @IdEmpresa)

RETURN @BienesTransferidosAmazonia

END