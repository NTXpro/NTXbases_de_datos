CREATE PROC [ERP].[Usp_Sel_ObtenerCorrelativoAnulacionSunat]
@IdEmpresa INT
AS
BEGIN
	DECLARE @FechaActual DATETIME = (SELECT ERP.ObtenerFechaActual());
	DECLARE @UltimoCorrelativoAnulacionSunat INT = (SELECT MAX(CorrelativoAnulacionSunat) FROM
													(
													SELECT ISNULL(MAX(CorrelativoAnulacionSunat),0) AS CorrelativoAnulacionSunat FROM ERP.Comprobante
													WHERE IdComprobanteEstado = 3 AND IdEmpresa = @IdEmpresa AND CAST(FechaAnulado AS DATE) = CAST(@FechaActual AS DATE)
													UNION 
													SELECT ISNULL(MAX(CorrelativoAnulacionSunat),0) AS CorrelativoAnulacionSunat FROM ERP.GuiaRemision
													WHERE IdGuiaRemisionEstado = 3 AND IdEmpresa = @IdEmpresa AND CAST(FechaAnulado AS DATE) = CAST(@FechaActual AS DATE)
													) AS TEMP);

	SELECT ISNULL(@UltimoCorrelativoAnulacionSunat + 1,1)
END
