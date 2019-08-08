

CREATE PROC [ERP].[Usp_Sel_ResumenDiario_Boleta_By_Fecha] 
@IdEmpresa INT,
@Fecha DATETIME
AS
BEGIN
WITH ListaBoletas AS(
SELECT      TC.Nombre NombreTipoComprobante,
			TC.CodigoSunat CodigoSunatTipoComprobante,
			C.IdTipoComprobante,
			C.Serie,
			MIN(C.Documento) DocumentoInicio,
			MAX(C.Documento) DocumentoFinal,
			SUM(C.Total) Total,
			SUM(C.IGV) IGV,
			SUM(C.TotalDetalleAfecto - (C.TotalDetalleAfecto * (C.PorcentajeDescuento/100))) TotalDetalleAfecto,
			SUM(C.TotalDetalleInafecto - (C.TotalDetalleInafecto * (C.PorcentajeDescuento/100))) TotalDetalleInafecto
	FROM ERP.Comprobante C INNER JOIN [PLE].[T10TipoComprobante] TC
		ON TC.ID = C.IdTipoComprobante
	WHERE CAST(C.Fecha AS DATE) = CAST(@Fecha AS DATE) AND C.IdEmpresa = @IdEmpresa AND C.FlagResumenDiario IS NULL
	AND C.IdTipoComprobante IN (4, 189) AND C.FlagComprobanteElectronico = 1 AND C.IdComprobanteEstado = 2 --REGISTRADO 
	GROUP BY TC.Nombre,TC.CodigoSunat,C.IdTipoComprobante, Serie--, IdMoneda
	)
	,
ListaNCBoleta AS(
SELECT      TC.Nombre NombreTipoComprobante,
			TC.CodigoSunat CodigoSunatTipoComprobante,
			C.IdTipoComprobante,
			C.Serie,
			MIN(C.Documento) DocumentoInicio,
			MAX(C.Documento) DocumentoFinal,
			SUM(C.Total) Total,
			SUM(C.IGV) IGV,
			SUM(C.TotalDetalleAfecto - (C.TotalDetalleAfecto * (C.PorcentajeDescuento/100))) TotalDetalleAfecto,
			SUM(C.TotalDetalleInafecto - (C.TotalDetalleInafecto * (C.PorcentajeDescuento/100))) TotalDetalleInafecto
	FROM ERP.Comprobante C INNER JOIN [PLE].[T10TipoComprobante] TC
		ON TC.ID = C.IdTipoComprobante
	INNER JOIN ERP.ComprobanteReferencia CRI
		ON CRI.IdComprobante = C.ID AND CRI.FlagInterno = 1
	INNER JOIN ERP.Comprobante CR
		ON CR.ID = CRI.IdReferencia
	WHERE CAST(C.Fecha AS DATE) = CAST(@Fecha AS DATE) AND C.IdEmpresa = @IdEmpresa AND CR.IdTipoComprobante IN (4, 189) AND C.FlagResumenDiario IS NULL
	AND C.IdTipoComprobante IN (8,9) AND C.IdComprobanteEstado = 1  AND C.FlagComprobanteElectronico = 2
	GROUP BY TC.Nombre,TC.CodigoSunat,C.IdTipoComprobante, C.Serie--, IdMoneda
)

SELECT * FROM ListaBoletas ORDER BY IdTipoComprobante


END
