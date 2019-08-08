CREATE PROC [ERP].[Usp_Sel_RegistroCompraPLE]
@IdEmpresa INT,
@IdPeriodo INT,
@idAnio VARCHAR(4),
@idMes VARCHAR(2),
@DiasMes INT
AS
BEGIN

DECLARE @FechaPeriodo DATE = DATEADD(day, -1, DATEADD(month, 1, CAST(@IdAnio+@idMes+'01' AS DATE)))

SELECT
CONCAT(@idAnio,@idMes,'00') Periodo, --1
CONCAT('05',RIGHT('000000' + CAST(A.Orden AS VARCHAR(8)), 7)) Asiento, --2
CONCAT('M',CONCAT('05',RIGHT('000000' + CAST(A.Orden AS VARCHAR(8)), 7))) Asiento2, --3
C.FechaEmision FechaEmision, --4
IIF(C.FechaVencimiento > EOMONTH(C.FechaEmision), EOMONTH(C.FechaEmision), C.FechaVencimiento) FechaVencimiento, --5
IIF(ISNULL(C.IdTipoComprobante,'') = '','00',T10.CodigoSunat) TipoComprobante, --6
CASE
				WHEN T10.CodigoSunat = '50' THEN CAST(CAST(C.Serie AS INT) AS VARCHAR(255))
				WHEN T10.CodigoSunat = '05' THEN '4'
				WHEN C.Serie IS NULL THEN ''
				WHEN LEFT(C.Serie, 1) = 'F' THEN UPPER(C.Serie)
				WHEN LEFT(C.Serie, 1) = 'B' THEN UPPER(C.Serie)
				WHEN LEFT(C.Serie, 1) = 'E' THEN UPPER(C.Serie)
				WHEN LEFT(C.Serie, 1) = 'T' THEN '0' + RIGHT(C.Serie, 3)				
				ELSE C.Serie END Serie, --7
IIF(T10.CodigoSunat = '50' or T10.CodigoSunat = '52',@idAnio,'') DUA, --8
CASE 
				WHEN T10.CodigoSunat = 50 THEN CAST(CAST(C.Numero AS INT) AS VARCHAR(255))
				ELSE ISNULL(NULLIF(RIGHT(C.Numero, 8), ''), A.Orden) END Documento, --9
'' Col10, --10
T2.CodigoSunat TipoIdentidad, --11
ETD.NumeroDocumento DocumentoIdentidad, --12
E.Nombre Entidad, --13
CASE WHEN C.IdMoneda = 1 THEN
	IIF(T10.CodigoSunat <> '02',IIF(TI.ID = '1',ISNULL(C.BaseImponible,0),0),0) * IIF(T10.CodigoSunat = '07', -1, 1)
ELSE
	IIF(T10.CodigoSunat <> '02',IIF(TI.ID = '1',ISNULL(C.BaseImponible,0),0),0) * C.TipoCambio * IIF(T10.CodigoSunat = '07', -1, 1)
END																			BaseImponible1, --14
CASE WHEN C.IdMoneda = 1 THEN
	IIF(T10.CodigoSunat <> '02',IIF(TI.ID = '1',ISNULL(C.IGV,0),0),0) * IIF(T10.CodigoSunat = '07', -1, 1)
ELSE
	IIF(T10.CodigoSunat <> '02',IIF(TI.ID = '1',ISNULL(C.IGV,0),0),0) * C.TipoCambio * IIF(T10.CodigoSunat = '07', -1, 1)
END																			IGV1, --15
CASE WHEN C.IdMoneda = 1 THEN
	IIF(T10.CodigoSunat <> '02',IIF(TI.ID = '2',ISNULL(C.BaseImponible,0),0),0) * IIF(T10.CodigoSunat = '07', -1, 1)
ELSE
	IIF(T10.CodigoSunat <> '02',IIF(TI.ID = '2',ISNULL(C.BaseImponible,0),0),0) * C.TipoCambio * IIF(T10.CodigoSunat = '07', -1, 1)
END																			BaseImponible2, --16
CASE WHEN C.IdMoneda = 1 THEN
	IIF(T10.CodigoSunat <> '02',IIF(TI.ID = '2',ISNULL(C.IGV,0),0),0) * IIF(T10.CodigoSunat = '07', -1, 1)
ELSE
	IIF(T10.CodigoSunat <> '02',IIF(TI.ID = '2',ISNULL(C.IGV,0),0),0) * C.TipoCambio * IIF(T10.CodigoSunat = '07', -1, 1)
END																			IGV2, --17
CASE WHEN C.IdMoneda = 1 THEN
	IIF(T10.CodigoSunat <> '02',IIF(TI.ID = '3',ISNULL(C.BaseImponible,0),0),0) * IIF(T10.CodigoSunat = '07', -1, 1)
ELSE
	IIF(T10.CodigoSunat <> '02',IIF(TI.ID = '3',ISNULL(C.BaseImponible,0),0),0) * C.TipoCambio * IIF(T10.CodigoSunat = '07', -1, 1)
END																			BaseImponible3, --18

CASE WHEN C.IdMoneda = 1 THEN
	IIF(T10.CodigoSunat <> '02',IIF(TI.ID = '3',ISNULL(C.IGV,0),0),0) * IIF(T10.CodigoSunat = '07', -1, 1)
ELSE
	IIF(T10.CodigoSunat <> '02',IIF(TI.ID = '3',ISNULL(C.IGV,0),0),0) * C.TipoCambio * IIF(T10.CodigoSunat = '07', -1, 1)
END																			IGV3, --19
CASE WHEN C.IdMoneda = 1 THEN
	C.Inafecto * IIF(T10.CodigoSunat = '07', -1, 1)
ELSE
	C.Inafecto * C.TipoCambio * IIF(T10.CodigoSunat = '07', -1, 1)
END																			Exonerado, --20
CASE WHEN C.IdMoneda = 1 THEN
	C.ISC * IIF(T10.CodigoSunat = '07', -1, 1)
ELSE
	C.ISC * C.TipoCambio * IIF(T10.CodigoSunat = '07', -1, 1)
END																			ISC, --21
CASE WHEN C.IdMoneda = 1 THEN
	C.OtroImpuesto * IIF(T10.CodigoSunat = '07', -1, 1)
ELSE
	C.OtroImpuesto * C.TipoCambio * IIF(T10.CodigoSunat = '07', -1, 1)
END																			Otros, --22
CASE WHEN C.IdMoneda = 1 THEN 
	C.Total * IIF(T10.CodigoSunat = '07', -1, 1)
ELSE 
	C.Total * C.TipoCambio * IIF(T10.CodigoSunat = '07', -1, 1)
END																			Total, --23
M.CodigoSunat CodigoMoneda, --24
C.TipoCambio TipoCambio, --25
IIF(T10.CodigoSunat = '07' or T10.CodigoSunat = '08',B.FechaRef,'') FechaComprobanteModificaPago, --26
IIF(T10.CodigoSunat = '07' or T10.CodigoSunat = '08',CodigoSunatRef,'') TipoComprobanteModificaPago, --27
IIF(T10.CodigoSunat = '07' or T10.CodigoSunat = '08',SerieRef,'') SerieComprobanteModificaPago, --28
'' CodigoDependenciaAduanera, --29
IIF(T10.CodigoSunat = '07' or T10.CodigoSunat = '08',NumeroRef,'') NumeroComprobanteModificaPago, --30
IIF(CD.FechaRegistro is NULL,'01/01/1900',CD.FechaDetraccion) FechaEmisionDetraccion, --31
IIF(CD.Comprobante is NULL,'',RTRIM(LTRIM(CD.Comprobante))) NumeroDetraccion, --32
'' MarcaRetencion, --33
'' ClasificacionBienesServicios, --34
'' IdentificadorProyecto, --35
'' ErrorTipo1, --36
'' ErrorTipo2, --37
'' ErrorTipo3, --38
'' ErrorTipo4, --39
'' IndicadorComprobantePago, --40
--IIF(CONCAT(DATEPART(year, FechaEmision),'-',RIGHT('00'+CAST(DATEPART(month, FechaEmision) AS Varchar(2)),2)) = CONCAT(@IdAnio,'-',@IdMes),1 ,0) Operacion --41
CASE
	WHEN T10.CodigoSunat = '02' THEN 0
	WHEN T10.CodigoSunat = '03' THEN 0
	WHEN T10.CodigoSunat = '10' THEN 0
	WHEN T10.CodigoSunat = '16' THEN 0
	WHEN T10.CodigoSunat = '18' THEN 0
	WHEN T10.CodigoSunat = '21' THEN 0
ELSE
	IIF(CONCAT(DATEPART(year, FechaEmision),'-',RIGHT('00'+CAST(DATEPART(month, FechaEmision) AS Varchar(2)),2)) = CONCAT(@IdAnio,'-',@IdMes),0 ,6)
END Operacion --41
FROM ERP.Compra C
INNER JOIN ERP.Asiento A
ON C.IdAsiento = A.ID
INNER JOIN PLE.T10TipoComprobante T10
ON C.IdTipoComprobante = T10.ID
INNER JOIN ERP.Proveedor P
ON C.IdProveedor = P.ID
INNER JOIN ERP.Entidad E
ON E.ID = P.IdEntidad
INNER JOIN ERP.EntidadTipoDocumento ETD
ON E.ID = ETD.IdEntidad
INNER JOIN PLE.T2TipoDocumento T2
ON ETD.IdTipoDocumento = T2.ID
LEFT JOIN ERP.CompraDetraccion CD
ON C.ID = CD.IdCompra
INNER JOIN ERP.Periodo PR
ON C.IdPeriodo = PR.ID
INNER JOIN Maestro.Anio An
ON PR.IdAnio = An.ID
INNER JOIN Maestro.Mes Ms
ON PR.IdMes = Ms.ID
INNER JOIN Maestro.Moneda M
ON C.IdMoneda = M.ID
INNER JOIN Maestro.TipoIGV TI
ON C.IdTipoIGV = TI.ID
LEFT JOIN 
(SELECT CRI.IdReferencia, C.FechaEmision FechaRef, T10.CodigoSunat CodigoSunatRef,CRI.Serie SerieRef,CRI.Documento NumeroRef ,CRI.IdCompra 
FROM ERP.Compra C
INNER JOIN ERP.CompraReferencia CRI
ON C.ID = CRI.IdReferencia
INNER JOIN PLE.T10TipoComprobante T10
ON C.IdTipoComprobante = T10.ID
) B
ON C.ID = B.IdCompra
WHERE C.IdEmpresa = @IdEmpresa AND C.IdPeriodo = @IdPeriodo AND C.FlagBorrador = 0 AND C.Flag = 1 AND NOT C.IdTipoComprobante IN (1, 3, 39, 58, 60, 61)
ORDER BY C.FechaEmision ASC
END